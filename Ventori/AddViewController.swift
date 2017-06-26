//
//  AddViewController.swift
//  Ventori
//
//  Created by Yohannes Wijaya on 6/8/17.
//  Copyright © 2017 Corruption of Conformity. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    var inventoryTitle: String!
    
    let boxIcon = "box100"
    let minusIcon = "Minus100"
    let plusIcon = "Plus100"
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet var inventoryImageView: UIImageView!
    @IBOutlet weak var inventoryNameTextField: UITextField!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet var minusButtonImageView: UIImageView!
    @IBOutlet var plusButtonImageView: UIImageView!
    
    // MARK: - IBAction Methods
    
    @IBAction func cancelBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
        if self.presentingViewController is UINavigationController {
            self.dismiss(animated: true, completion: nil)
        }
        else { self.navigationController?.popViewController(animated: true) }
    }
    
    @IBAction func saveBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        self.inventoryImageView.contentMode = .center
        self.inventoryImageView.layer.borderWidth = 0.5
        self.inventoryImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.50).cgColor
        self.inventoryImageView.layer.cornerRadius = 5
        self.inventoryImageView.image = UIImage(named: self.boxIcon)
        
        self.inventoryNameTextField.text = "Inventory Name"
        
        self.counterLabel.text = "1"
        self.minusButtonImageView.image = UIImage(named: self.minusIcon)
        self.plusButtonImageView.image = UIImage(named: self.plusIcon)
        
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(AddViewController.dismissKeyboardIfPresent))
        self.view.addGestureRecognizer(dismissKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isToolbarHidden = true
    }
    
    // MARK: - Helper Methods
    
    func dismissKeyboardIfPresent() {
        self.inventoryNameTextField.resignFirstResponder()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
