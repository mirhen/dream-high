//
//  SchoolTableViewCell.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/14/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import UIKit

class SchoolTableViewCell: UITableViewCell {

    @IBOutlet weak var schoolImageView: UIImageView!
    @IBOutlet weak var schoolLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
