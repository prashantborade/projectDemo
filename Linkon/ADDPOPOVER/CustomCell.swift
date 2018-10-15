//
//  CustomCell.swift
//  Linkon
//
//  Created by Avion on 8/24/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var viewEffect: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewEffect.setCardLayoutEffect()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
