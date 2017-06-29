//
//  AddViewController.swift
//  Ventori
//
//  Created by Yohannes Wijaya on 6/8/17.
//  Copyright © 2017 Corruption of Conformity. All rights reserved.
//

import UIKit

protocol AddViewControllerDelegate {
    func getInventory(_ inventory: Inventory)
}

class AddViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    var inventory: Inventory?
    
    var counter = 0 {
        willSet {
            self.counterLabel.text = String(describing: newValue)
        }
    }
    
    var delegate: AddViewControllerDelegate?
    
    enum Icon: String {
        case box, decrement, increment
        
        func getName() -> String {
            switch self {
            case .box: return "box100"
            case .decrement: return "Minus100"
            case .increment: return "Plus100"
            }
        }
    }
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var inventoryImageView: UIImageView!
    @IBOutlet weak var inventoryNameTextField: UITextField!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var incrementButton: UIButton!
    
    // MARK: - IBAction Methods
    
    @IBAction func cancelBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
        self.dismissAddViewController()
    }
    
    @IBAction func saveBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
        guard let validInventoryName = self.inventoryNameTextField.text, let validCounter = self.counterLabel.text else { return }
        self.inventory = Inventory(name: validInventoryName, count: validCounter, image: self.inventoryImageView.image, modifiedDate: self.getCurrentDateAndTime())
        self.delegate?.getInventory(self.inventory!)
        self.dismissAddViewController()
    }
    
    @IBAction func decrementButtonDidTouch(_ sender: UIButton) {
        guard self.counter != 0 else { return }
        self.counter -= 1
    }
    
    @IBAction func incrementButtonDidTouch(_ sender: UIButton) {
        self.counter += 1
    }
    
    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        self.setupInventoryRelatedControls()
        
        if self.presentingViewController is UINavigationController {
            self.load(Inventory(name: "Inventory Name", count: "0", image: UIImage(named: Icon.box.getName()), modifiedDate: self.getCurrentDateAndTime()))
        }
        else {
            self.load(self.inventory!)
        }
        
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
    
    func dismissAddViewController() {
        if self.presentingViewController is UINavigationController {
            self.dismiss(animated: true, completion: nil)
        }
        else { self.navigationController?.popViewController(animated: true) }
    }
    
    func load(_ inventory: Inventory) {
        self.inventoryNameTextField.text = inventory.name
        self.inventoryImageView.image = inventory.image
        self.counterLabel.text = inventory.count
        self.counter = Int(inventory.count)!
    }
    
    func setupInventoryRelatedControls() {
        self.inventoryImageView.contentMode = .center
        self.inventoryImageView.layer.borderWidth = 0.5
        self.inventoryImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.50).cgColor
        self.inventoryImageView.layer.cornerRadius = 5
        
        self.decrementButton.setTitle("", for: .normal)
        self.decrementButton.setBackgroundImage(UIImage(named: Icon.decrement.getName()), for: .normal)
        
        self.incrementButton.setTitle("", for: .normal)
        self.incrementButton.setBackgroundImage(UIImage(named: Icon.increment.getName()), for: .normal)
    }
}

extension AddViewController: CurrentAndDateTimeProtocol {}
