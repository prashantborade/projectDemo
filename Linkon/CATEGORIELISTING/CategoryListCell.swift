//
//  CategoryListCell.swift
//  Linkon
//
//  Created by Avion on 9/7/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class CategoryListCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    
  //  @IBOutlet weak var lblContactNo: UILabel!
    
    @IBOutlet weak var lblDicription: UILabel!
    
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var RatingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
