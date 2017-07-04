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
    var name: String
    var count: String
    var image: UIImage?
    var modifiedDate: String
    
    var firebaseDataSnapshotKey: String
    
    // MARK: - Initalizers
    
    init(name: String, count: String, image: UIImage?, modifiedDate: String, dataSnapshotKey: String = "") {
        self.name = name
        self.count = count
        self.image = image
        self.modifiedDate = modifiedDate
        self.firebaseDataSnapshotKey = dataSnapshotKey
    }
    
    init(snapshot: DataSnapshot) {
        self.firebaseDataSnapshotKey = snapshot.key
        let validSnapshotValue = snapshot.value as! [String: Any]
        self.name = validSnapshotValue["name"] as! String
        self.count = validSnapshotValue["count"] as! String
        self.modifiedDate = validSnapshotValue["modifiedDate"] as! String
    }
    
    // MARK: - Helper Methods
    
    static func returnDictionaryFormat(from inventory: Inventory) -> [String: Any] {
        return [
            "name": inventory.name,
            "count": inventory.count,
            "modifiedDate": inventory.modifiedDate
        ]
    }
}
