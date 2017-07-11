//
//  StringToImageConversion.swift
//  Ventori
//
//  Created by Yohannes Wijaya on 7/8/17.
//  Copyright © 2017 Corruption of Conformity. All rights reserved.
//

import UIKit
import FirebaseStorage

protocol StringToImageConversion { }

extension StringToImageConversion where Self: UIViewController {
    func returnImageFromURL(_ downloadImageURL: String, within storageReference: StorageReference, completionHandler: @escaping (_ image: UIImage) -> Void) {
        storageReference.child(downloadImageURL).getData(maxSize: 1 * 1024 * 1024) { (inventory: Data?, error: Error?) in
            if let validError = error {
                print("Error downloading inventory image: \(validError.localizedDescription)")
                completionHandler(UIImage(named: Icon.box.getName())!)
            }
            else if let validInventory = inventory, let validImage = UIImage(data: validInventory) {
                completionHandler(validImage)
            }
        }
    }
}
