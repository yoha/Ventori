//
//  CurrentDateAndTimeProtocol.swift
//  Ventori
//
//  Created by Yohannes Wijaya on 6/28/17.
//  Copyright © 2017 Corruption of Conformity. All rights reserved.
//

import Foundation

protocol CurrentAndDateTimeProtocol {
    func getCurrentDateAndTime() -> String
}

extension CurrentAndDateTimeProtocol {
    func getCurrentDateAndTime() -> String {
        return DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .short)
    }
}
