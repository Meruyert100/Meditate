//
//  ViewController.swift
//  Meditate
//
//  Created by Meruyert Tastandiyeva on 4/17/21.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet var loginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUI()
        addGestureRecognizer()
    }
    
    private func loadUI() {
        signUpButton.layer.cornerRadius = 30
    }
    
    private func addGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loginLabelPressed))
        loginLabel.isUserInteractionEnabled = true
        loginLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func loginLabelPressed() {
        present(LoginViewController(), animated: true, completion: nil)
    }

}

