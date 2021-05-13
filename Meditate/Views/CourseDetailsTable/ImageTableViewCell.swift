//
//  ImageTableViewCell.swift
//  Meditate
//
//  Created by Dina Yestemir on 08.05.2021.
//

import UIKit

protocol ImageTableViewCellDelegate {
    func dismiss()
}
class ImageTableViewCell: UITableViewCell {
    
    var delegate: ImageTableViewCellDelegate?

    @IBOutlet weak var bannerView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        delegate?.dismiss()
    }
    
}
