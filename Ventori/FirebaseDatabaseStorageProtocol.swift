//
//  FirebaseDatabaseStorageProtocol.swift
//  Ventori
//
//  Created by Yohannes Wijaya on 7/17/17.
//  Copyright © 2017 Corruption of Conformity. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseDatabaseStorageProtocol {
    var firebaseDatabaseReference: DatabaseReference { get }
    var firebaseStorageReference: StorageReference { get }
}

extension FirebaseDatabaseStorageProtocol {
    var firebaseDatabaseReference: DatabaseReference {
        return Database.database().reference(withPath: "inventory-items")
    }
    var firebaseStorageReference: StorageReference {
        return Storage.storage().reference(withPath: "inventory-images")
    }
}
