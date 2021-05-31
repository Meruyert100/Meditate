//
//  ChatsTableViewCell.swift
//  Meditate
//
//  Created by Dina Yestemir on 30.05.2021.
//

import UIKit

class ChatsTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var recievedImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImage.backgroundColor = #colorLiteral(red: 0.5509303212, green: 0.5867726803, blue: 1, alpha: 1)
        avatarImage.layer.cornerRadius = 65 / 2
        avatarImage.layer.borderWidth = 2
        avatarImage.layer.borderColor = #colorLiteral(red: 0.9994668365, green: 0.7879567742, blue: 0.4950447083, alpha: 1).cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
