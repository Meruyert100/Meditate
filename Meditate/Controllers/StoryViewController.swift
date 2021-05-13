//
//  StoryViewController.swift
//  Meditate
//
//  Created by Dina Yestemir on 10.05.2021.
//

import UIKit

class StoryViewController: UIViewController {

    @IBOutlet weak var storyView: UIImageView!
    var photo = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        storyView.image = photo
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
