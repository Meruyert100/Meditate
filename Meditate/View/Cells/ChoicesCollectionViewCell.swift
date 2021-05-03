//
//  ChoicesCollectionViewCell.swift
//  Meditate
//
//  Created by Meruyert Tastandiyeva on 4/23/21.
//

import UIKit

class ChoicesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var choiceImageView: UIImageView?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadUI()
    }
    
    private func loadUI() {
        choiceImageView?.layer.cornerRadius = 15
    }
    
}


