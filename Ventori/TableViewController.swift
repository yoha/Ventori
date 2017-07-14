//
//  TableViewController.swift
//  Ventori
//
//  Created by Yohannes Wijaya on 6/8/17.
//  Copyright © 2017 Corruption of Conformity. All rights reserved.
//

import UIKit
import Firebase

class TableViewController: UITableViewController {
    
    // MARK: - Stored Properties
    
    let tableViewCellID = "reusableCell"
    
    var inventories = [Inventory]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // MARK: - Helper Methods
    
    func updateInventoriesInTableView() {
        self.appDelegate.firebaseDatabaseReference.observe(.value) { [weak self] (dataSnapshot: DataSnapshot) in
            guard let weakSelf = self else { return }
            weakSelf.inventories = dataSnapshot.children.map({ (child) -> Inventory in
                return Inventory(snapshot: child as! DataSnapshot)
            })
            weakSelf.tableView.reloadData()
        }
    }

    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "VENTORI"
        self.updateInventoriesInTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.isToolbarHidden = false
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inventories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.tableViewCellID, for: indexPath) as! TableViewCell
        
        let currentInventory = self.inventories[indexPath.row]
        
        self.returnImageFromURL(currentInventory.image, within: self.appDelegate.firebaseStorageReference) { (image: UIImage) in
            DispatchQueue.main.async {
                customTableViewCell.imageView?.image = image
            }
        }
        customTableViewCell.textLabel?.text = currentInventory.name
        customTableViewCell.detailTextLabel?.text = currentInventory.modifiedDate
        customTableViewCell.inventoryCount.text = currentInventory.count
        
        return customTableViewCell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let inventoryItem = self.inventories[indexPath.row]
            self.appDelegate.firebaseStorageReference.child(inventoryItem.image).delete(completion: { (error: Error?) in
                guard error == nil else {
                    print("Error removing image file: \(String(describing: error?.localizedDescription))")
                    return
                }
                inventoryItem.firebaseDatabaseReference?.removeValue()
            })
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let validNavigationController = segue.destination as? UINavigationController, let validAddViewController = validNavigationController.topViewController as? AddViewController {
            validAddViewController.appDelegate = self.appDelegate
        }
        if let validAddViewController = segue.destination as? AddViewController, let validIndexPathForSelectedRow = self.tableView.indexPathForSelectedRow {
            validAddViewController.inventory = self.inventories[validIndexPathForSelectedRow.row]
            validAddViewController.appDelegate = self.appDelegate
        }
    }
}


// MARK: - Extensions

extension TableViewController: StringToImageConversion {}
