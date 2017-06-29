//
//  TableViewCell.swift
//  Ventori
//
//  Created by Yohannes Wijaya on 6/16/17.
//  Copyright © 2017 Corruption of Conformity. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var inventoryCount: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
