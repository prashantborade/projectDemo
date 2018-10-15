//
//  HealthcareCell.swift
//  Linkon
//
//  Created by Avion on 7/26/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class HealthcareCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopDescription: UILabel!
    
    @IBOutlet weak var rating: CosmosView!
    
    @IBOutlet weak var reviewCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
