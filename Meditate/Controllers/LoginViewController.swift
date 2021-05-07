//
//  LoginViewController.swift
//  Meditate
//
//  Created by Meruyert Tastandiyeva on 4/21/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var forgotLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUI()
        setLanguage()
    }
    
    private func loadUI() {
        navigationController?.navigationBar.isHidden = true
        
        emailView.layer.cornerRadius = 20
        passwordView.layer.cornerRadius = 20
        
        loginButton.layer.cornerRadius = 30
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error {
                    print(e)
                    let alert = UIAlertController(title: "Invalid Credentials", message: "Please check again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                } else {
                    self?.performSegue(withIdentifier: "LoginToWelcome", sender: self)
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setLanguage() {
        if Helper.selectedLanguage == "en" {
            welcomeLabel.text = Helper.translate(title: "WELCOME BACK", lang: "en")
            
            emailTextField.placeholder = Helper.translate(title: "Email", lang: "en")
            passwordTextField.placeholder = Helper.translate(title: "Password", lang: "en")
            
            forgotLabel.text = Helper.translate(title: "Forgot Password", lang: "en")
            
            loginButton.setTitle(Helper.translate(title: "LOG IN", lang: "en"), for: .normal)
        }
        if Helper.selectedLanguage == "kk" {
            welcomeLabel.text = Helper.translate(title: "WELCOME BACK", lang: "kk")
            
            emailTextField.placeholder = Helper.translate(title: "Email", lang: "kk")
            passwordTextField.placeholder = Helper.translate(title: "Password", lang: "kk")
            
            forgotLabel.text = Helper.translate(title: "Forgot Password", lang: "kk")
            
            loginButton.setTitle(Helper.translate(title: "LOG IN", lang: "kk"), for: .normal)
        }
        if Helper.selectedLanguage == "ru" {
            welcomeLabel.text = Helper.translate(title: "WELCOME BACK", lang: "ru")
            
            emailTextField.placeholder = Helper.translate(title: "Email", lang: "ru")
            passwordTextField.placeholder = Helper.translate(title: "Password", lang: "ru")
            
            forgotLabel.text = Helper.translate(title: "Forgot Password", lang: "ru")
            
            loginButton.setTitle(Helper.translate(title: "LOG IN", lang: "ru"), for: .normal)
        }
    }
    
}
