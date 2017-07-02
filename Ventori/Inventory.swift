//
//  Inventory.swift
//  Ventori
//
//  Created by Yohannes Wijaya on 6/27/17.
//  Copyright © 2017 Corruption of Conformity. All rights reserved.
//

import UIKit

struct Inventory {
    var name: String
    var count: String
    var image: UIImage?
    var modifiedDate: String
    
    func convertToDictionaryForm() -> [String: String] {
        return [
            "name": self.name,
            "count": self.count,
            "modifiedDate": self.modifiedDate
        ]
    }
}
