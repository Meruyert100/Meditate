//
//  MessageTableViewCell.swift
//  Meditate
//
//  Created by Dina Yestemir on 27.04.2021.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var messageBodyLabel: UILabel!
    @IBOutlet weak var bodyView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftImage.layer.cornerRadius = 25
        rightImage.layer.cornerRadius = 25
        bodyView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
