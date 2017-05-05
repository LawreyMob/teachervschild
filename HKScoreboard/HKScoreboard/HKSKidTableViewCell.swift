//
//  HKSKidTableViewCell.swift
//  HKScoreboard
//
//  Created by Lawrence Tan on 5/5/17.
//  Copyright © 2017 Lawrey. All rights reserved.
//

import UIKit

class HKSKidTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var scoreView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.scoreView.layer.borderWidth = 1.5
        self.scoreView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
