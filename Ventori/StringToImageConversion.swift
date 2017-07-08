//
//  StringToImageConversion.swift
//  Ventori
//
//  Created by Yohannes Wijaya on 7/8/17.
//  Copyright © 2017 Corruption of Conformity. All rights reserved.
//

import UIKit
import FirebaseStorage

protocol StringToImageConversion {
    func returnImageFrom(_ downloadImageURL: String, within storageReference: StorageReference) -> UIImage
}

extension StringToImageConversion {
    func returnImageFrom(_ downloadImageURL: String, within storageReference: StorageReference) -> UIImage {
        var image: UIImage?
        storageReference.child(downloadImageURL).getData(maxSize: 1 * 1024 * 1024) { (inventory: Data?, error: Error?) in
            if let validError = error {
                print("Error downloading inventory image: \(validError.localizedDescription)")
            }
            else if let validInventory = inventory {
                image = UIImage(data: validInventory)!
            }
        }
        return image ?? UIImage(named: Icon.box.getName())!
    }
}
