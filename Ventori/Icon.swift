//
//  Icon.swift
//  Ventori
//
//  Created by Yohannes Wijaya on 7/8/17.
//  Copyright © 2017 Corruption of Conformity. All rights reserved.
//

import Foundation

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
