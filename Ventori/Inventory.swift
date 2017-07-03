//
//  Inventory.swift
//  Ventori
//
//  Created by Yohannes Wijaya on 6/27/17.
//  Copyright © 2017 Corruption of Conformity. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct Inventory {
    
    // MARK: - Stored Properties
    
    var name: String
    var count: String
    var image: UIImage?
    var modifiedDate: String
    
    var firebaseDataSnapshotKey: String
    var firebaseDatabaseReference: DatabaseReference?
    
    // MARK:- Initializers
    
    init(name: String, count: String, image: UIImage?, modifiedDate: String, firebaseDataSnapshotKey: String = "") {
        self.name = name
        self.count = count
        self.image = image
        self.modifiedDate = modifiedDate
        self.firebaseDataSnapshotKey = firebaseDataSnapshotKey
        self.firebaseDatabaseReference = nil
    }
    
    init?(dataSnapshot: DataSnapshot) {
        guard let validDataSnapshotValue = dataSnapshot.value as? [String: Any], let validInventoryName = validDataSnapshotValue["name"] as? String, let validInventoryCount = validDataSnapshotValue["count"] as? String, let validModifiedDate = validDataSnapshotValue["modifiedDate"] as? String else { return nil}
        self.name = validInventoryName
        self.count = validInventoryCount
        self.modifiedDate = validModifiedDate
        self.firebaseDataSnapshotKey = dataSnapshot.key
        self.firebaseDatabaseReference = dataSnapshot.ref
    }
    
    // MARK: - Helper Methods
    
    func convertToDictionaryForm() -> [String: Any] {
        return [
            "name": self.name,
            "count": self.count,
            "modifiedDate": self.modifiedDate
        ]
    }
}
