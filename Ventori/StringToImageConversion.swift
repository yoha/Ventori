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
    func returnImageFrom(_ downloadImageURL: String, within storageReference: StorageReference) -> UIImage {
        // TODO: remove me
        print("ioioioioioi:\(downloadImageURL)")
        print("bybybbybyL:\(storageReference.fullPath)")
        var image = UIImage()
        storageReference.child(downloadImageURL).getData(maxSize: 1 * 1024 * 1024) { (inventory: Data?, error: Error?) in
            if let validError = error {
                print("Error downloading inventory image: \(validError.localizedDescription)")
                image = UIImage(named: Icon.box.getName())!
            }
            else if let validInventory = inventory, let validImage = UIImage(data: validInventory) {
                // TODO: - remove me
                print("kkkkk:\(UIImage(data: validInventory ))")
                print("2222:\(validInventory.debugDescription)")
                print("it's a valid image")
                image = validImage
            }
        }
        return image
    }
}
