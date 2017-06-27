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
    
    var inventories: [Inventory]?
    
    var counter = 0 {
        willSet {
            self.counterLabel.text = String(describing: newValue)
        }
    }
    
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
    
    @IBOutlet var inventoryImageView: UIImageView!
    @IBOutlet weak var inventoryNameTextField: UITextField!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet var decrementButton: UIButton!
    @IBOutlet var incrementButton: UIButton!
    
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
        
        self.inventoryImageView.contentMode = .center
        self.inventoryImageView.layer.borderWidth = 0.5
        self.inventoryImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.50).cgColor
        self.inventoryImageView.layer.cornerRadius = 5
        self.inventoryImageView.image = UIImage(named: Icon.box.getName())
        
        self.inventoryNameTextField.text = "Inventory Name"
        
        self.counterLabel.text = "0"
        
        self.decrementButton.setTitle("", for: .normal)
        self.decrementButton.setBackgroundImage(UIImage(named: Icon.decrement.getName()), for: .normal)
    
        self.incrementButton.setTitle("", for: .normal)
        self.incrementButton.setBackgroundImage(UIImage(named: Icon.increment.getName()), for: .normal)
        
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
