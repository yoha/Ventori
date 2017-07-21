//
//  AddViewController.swift
//  Ventori
//
//  Created by Yohannes Wijaya on 6/8/17.
//  Copyright © 2017 Corruption of Conformity. All rights reserved.
//

import UIKit
import FirebaseStorage

class AddViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    var inventory: Inventory!
    
    var appDelegate: AppDelegate!
    
    var firebaseDatabaseSnapshotKey: String!
    
    var counter = 0 {
        willSet {
            self.counterLabel.text = String(describing: newValue)
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
        guard let validInventoryName = self.inventoryNameTextField.text, let validCounter = self.counterLabel.text, let validImage = self.inventoryImageView.image, let validImageData = UIImageJPEGRepresentation(validImage, 0.5) else { return }
        
        let databaseReferenceWithChildAutoID = self.firebaseDatabaseReference.childByAutoId()
        
        self.firebaseStorageReference.child("\(databaseReferenceWithChildAutoID.key)" + ".jpg").putData(validImageData, metadata: nil) { [weak self] (storageMetaData: StorageMetadata?, error: Error?) in
            guard let weakSelf = self, let validMetadata = storageMetaData, let validInventoryImageDownloadPath = validMetadata.name else {
                print("Error has occured: \(String(describing: error?.localizedDescription))")
                return
            }
            
            if weakSelf.inventory != nil {
                weakSelf.firebaseStorageReference.child(weakSelf.inventory.image).delete { (error: Error?) in
                    guard error == nil else {
                        print("Error removing image file in AddViewController: \(String(describing: error?.localizedDescription))")
                        return
                    }
                    weakSelf.inventory.firebaseDatabaseReference?.removeValue()
                }
            }
            
            weakSelf.inventory = Inventory(name: validInventoryName,
                                       count: validCounter,
                                       image: validInventoryImageDownloadPath,
                                       modifiedDate: weakSelf.getCurrentDateAndTime())
            
            if weakSelf.presentingViewController is UINavigationController {
                databaseReferenceWithChildAutoID.setValue(Inventory.returnDictionaryFormat(from: weakSelf.inventory))
            }
            else {
                weakSelf.firebaseDatabaseReference.child(weakSelf.firebaseDatabaseSnapshotKey).updateChildValues(Inventory.returnDictionaryFormat(from: weakSelf.inventory))
            }
            weakSelf.dismissAddViewController()
        }
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
        
        self.decrementButton.setTitle(String(), for: .normal)
        self.decrementButton.setImage(UIImage(named: Icon.decrement.getName()), for: .normal)
        self.incrementButton.setTitle("", for: .normal)
        self.incrementButton.setImage(UIImage(named: Icon.increment.getName()), for: .normal)
        
        self.inventoryNameTextField.delegate = self
        self.inventoryNameTextField.returnKeyType = .done
        self.inventoryNameTextField.autocorrectionType = .no
        self.inventoryNameTextField.spellCheckingType = .no
        
        self.inventoryImageView.contentMode = .scaleToFill
        self.inventoryImageView.layer.cornerRadius = 8
        self.inventoryImageView.layer.masksToBounds = true
        
        self.addGesturesToControlsWithin(self)
        
        if self.presentingViewController is UINavigationController {
            self.load(Inventory(name: "Inventory Name", count: "0", image: Icon.box.getName(), modifiedDate: self.getCurrentDateAndTime()))
        }
        else {
            self.load(self.inventory)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = true
    }
    
    // MARK: - Helper Methods
    
    func addGesturesToControlsWithin(_ viewController: AddViewController) {
        let dismissKeyboardGesture = UITapGestureRecognizer(target: viewController, action: #selector(AddViewController.dismissKeyboardIfPresent))
        viewController.view.addGestureRecognizer(dismissKeyboardGesture)
        
        // -----
        
        let tapImageViewToPresentImagePickerActionSheet = UITapGestureRecognizer(target: viewController, action: #selector(AddViewController.presentImagePickerActionSheet))
        viewController.inventoryImageView.isUserInteractionEnabled = true
        viewController.inventoryImageView.addGestureRecognizer(tapImageViewToPresentImagePickerActionSheet)
    }
    
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
        self.returnImageFromURL(inventory.image, within: self.firebaseStorageReference) { (image: UIImage) -> Void in
            DispatchQueue.main.async {
                self.inventoryImageView.image = image
            }
        }
        self.counter = Int(inventory.count)!
        self.firebaseDatabaseSnapshotKey = inventory.firebaseDataSnapshotKey
    }
    
    func initAndPresentCameraWith(_ imagePickerController: UIImagePickerController) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) == true else {
            let noCameraAlertController = UIAlertController(title: "Error: Missing Camera",
                                                            message: "The built-in camera may be malfunctioning",
                                                            preferredStyle: .alert)
            let okAlertAction = UIAlertAction(title: "OK",
                                              style: .cancel,
                                              handler: nil)
            noCameraAlertController.addAction(okAlertAction)
            self.present(noCameraAlertController, animated: true, completion: nil)
            return
        }

        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func initAndPresentPhotoLibraryWith(_ imagePickerController: UIImagePickerController) {
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func presentImagePickerActionSheet() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        let imagePickerAlertController = UIAlertController(title: "Choose Image From",
                                                            message: nil,
                                                            preferredStyle: .actionSheet)
        let cameraAlertAction = UIAlertAction(title: "Camera",
                                              style: .default) { [weak self] (_) in
                                                guard let weakSelf = self else { return }
                                                weakSelf.initAndPresentCameraWith(imagePickerController)
        }
        let photoLibraryAlertAction = UIAlertAction(title: "Photo Library",
                                                    style: .default) { [weak self] (_) in
                                                        guard let weakSelf = self else { return }
                                                        weakSelf.initAndPresentPhotoLibraryWith(imagePickerController)
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel",
                                              style: .cancel,
                                              handler: nil)
        let _ = [cameraAlertAction, photoLibraryAlertAction, cancelAlertAction].map { (alertAction: UIAlertAction) -> Void in
            imagePickerAlertController.addAction(alertAction)
        }
        self.present(imagePickerAlertController, animated: true, completion: nil)
    }
    
    func setupInventoryRelatedControls() {
        self.inventoryImageView.contentMode = .scaleAspectFill
        self.inventoryImageView.clipsToBounds = true
        self.inventoryImageView.layer.borderWidth = 0.5
        self.inventoryImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.50).cgColor
        self.inventoryImageView.layer.cornerRadius = 5
        
        self.decrementButton.setTitle("", for: .normal)
        self.decrementButton.setBackgroundImage(UIImage(named: Icon.decrement.getName()), for: .normal)
        
        self.incrementButton.setTitle("", for: .normal)
        self.incrementButton.setBackgroundImage(UIImage(named: Icon.increment.getName()), for: .normal)
    }
}

// MARK: - Extensions

extension AddViewController: CurrentAndDateTimeProtocol {}

extension AddViewController: FirebaseDatabaseStorageProtocol {}

extension AddViewController: StringToImageConversion {}

extension AddViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        self.inventoryImageView.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddViewController: UINavigationControllerDelegate {}

extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
