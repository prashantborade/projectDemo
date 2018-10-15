//
//  PlanCell.swift
//  Linkon
//
//  Created by Avion on 7/25/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class PlanCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var planTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
