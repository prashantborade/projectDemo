//
//  NotificationCell.swift
//  Linkon
//
//  Created by Avion on 9/6/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
