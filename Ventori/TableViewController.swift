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
    
    var firebaseDatabaseReference: DatabaseReference = Database.database().reference(withPath: "inventory-items")
    
    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "VENTORI"
        
        self.firebaseDatabaseReference.observe(.value) { (dataSnapshot: DataSnapshot) in
            self.inventories = dataSnapshot.children.map({ (child) -> Inventory in
                return Inventory(snapshot: child as! DataSnapshot)
            })
            self.tableView.reloadData()
        }
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
        customTableViewCell.imageView?.image = currentInventory.image
        customTableViewCell.textLabel?.text = currentInventory.name
        customTableViewCell.detailTextLabel?.text = currentInventory.modifiedDate
        customTableViewCell.inventoryCount.text = currentInventory.count
        
        return customTableViewCell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        if let validAddViewController = segue.destination as? AddViewController, let validIndexPathForSelectedRow = self.tableView.indexPathForSelectedRow {
            validAddViewController.inventory = self.inventories[validIndexPathForSelectedRow.row]
        }
    }
}
