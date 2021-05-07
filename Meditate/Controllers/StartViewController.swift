//
//  ViewController.swift
//  Meditate
//
//  Created by Meruyert Tastandiyeva on 4/17/21.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUI()
    }
    
    private func loadUI() {
        navigationController?.navigationBar.isHidden = true
        signUpButton.layer.cornerRadius = 30
        loginButton.layer.cornerRadius = 30
    }
    
    @IBAction func languageButtonPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            signUpButton.setTitle(Helper.translate(title: "SIGN UP", lang: "kk"), for: .normal)
            loginButton.setTitle(Helper.translate(title: "LOG IN", lang: "kk"), for: .normal)
            Helper.selectedLanguage = "kk"
        }
        if sender.tag == 2 {
            signUpButton.setTitle(Helper.translate(title: "SIGN UP", lang: "en"), for: .normal)
            loginButton.setTitle(Helper.translate(title: "LOG IN", lang: "en"), for: .normal)
            Helper.selectedLanguage = "en"
        }
        if sender.tag == 3 {
            signUpButton.setTitle(Helper.translate(title: "SIGN UP", lang: "ru"), for: .normal)
            loginButton.setTitle(Helper.translate(title: "LOG IN", lang: "ru"), for: .normal)
            Helper.selectedLanguage = "ru"
        }
    }
    
}

