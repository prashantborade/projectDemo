//
//  LatestCategoryCell.swift
//  Linkon
//
//  Created by Avion on 7/30/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class LatestCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
}
