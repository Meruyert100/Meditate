//
//  StoriesCollectionViewCell.swift
//  Meditate
//
//  Created by Dina Yestemir on 05.05.2021.
//

import UIKit

class StoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 47
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemRed.cgColor
        // Initialization code
    }

}
