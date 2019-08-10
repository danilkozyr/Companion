//
//  SectionCell.swift
//  swiftCompanion
//
//  Created by Ксения on 8/10/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class SectionCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
