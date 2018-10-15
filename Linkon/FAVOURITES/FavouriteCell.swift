
//
//  FavouriteCell.swift
//  Linkon
//
//  Created by Avion on 8/16/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class FavouriteCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgFav: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDecription: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var containerView: UIView!
   // @IBOutlet weak var iconImgView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
       
    }
    
}
