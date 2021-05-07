//
//  CourseCollectionViewCell.swift
//  Meditate
//
//  Created by Meruyert Tastandiyeva on 4/23/21.
//

import UIKit

class CourseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var courseImageView: UIImageView?
    
    @IBOutlet weak var nameLabel: UILabel?
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel?
    
    @IBOutlet weak var startButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadUI()
        setLanguage()
    }
    
    private func loadUI() {
        courseImageView?.layer.cornerRadius = 15
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        
    }
    
    private func setLanguage() {
        if Helper.selectedLanguage == "en" {
            typeLabel?.text = Helper.translate(title: "COURSE", lang: "en")

            startButton?.setTitle(Helper.translate(title: "Start", lang: "en"), for: .normal)
        }
        if Helper.selectedLanguage == "kk" {
            typeLabel?.text = Helper.translate(title: "COURSE", lang: "kk")
            
            startButton?.setTitle(Helper.translate(title: "Start", lang: "kk"), for: .normal)
        }
        if Helper.selectedLanguage == "ru" {
            typeLabel?.text = Helper.translate(title: "COURSE", lang: "ru")
            
            startButton?.setTitle(Helper.translate(title: "Start", lang: "ru"), for: .normal)
        }
    }
    
}


