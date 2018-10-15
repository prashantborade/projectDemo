//
//  MenuCell.swift
//  Linkon
//
//  Created by Avion on 7/10/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

   
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
