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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textLabel?.frame = CGRect(x: 75, y: 3, width: self.frame.width, height: 23.5)
        self.textLabel?.backgroundColor = UIColor.clear
        self.detailTextLabel?.frame = CGRect(x: 75, y: 26.5, width: self.frame.width, height: 15.5)
        self.detailTextLabel?.backgroundColor = UIColor.clear
        self.inventoryCount.frame = CGRect(x: self.frame.width - 60, y: self.frame.height / 2 - (23.5 / 2), width: 60, height: 23.5)
        self.imageView?.frame = CGRect(x: 16, y: 0, width: 44, height: 44)
        self.imageView?.applyCircleAndBorder()
    }

}

extension UIImageView {
    func applyCircleAndBorder() {
        self.contentMode = .scaleToFill
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
}
