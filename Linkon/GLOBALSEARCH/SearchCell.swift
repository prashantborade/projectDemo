//
//  SearchCell.swift
//  Linkon
//
//  Created by Avion on 9/14/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDicription: UILabel!
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var RatingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cardView.layer.borderWidth = 1
        self.cardView.layer.borderColor = UIColor.black.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
