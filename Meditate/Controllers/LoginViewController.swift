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
    
    var name = ""
    var placeholder = ""
    var message = ""
    var cancel = ""
    var reset = ""
    var resetFailed = ""
    var failed = ""
    var success = ""
    var check = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUI()
        addGestureRecognizer()
        setLanguage()
    }
    
    private func loadUI() {
        navigationController?.navigationBar.isHidden = true
        
        emailView.layer.cornerRadius = 20
        passwordView.layer.cornerRadius = 20
        
        loginButton.layer.cornerRadius = 30
    }
    
    private func addGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forgotTapped))
        forgotLabel.isUserInteractionEnabled = true
        forgotLabel.addGestureRecognizer(tapGesture)
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
    
}

extension LoginViewController {
    private func setLanguage() {
        if Helper.selectedLanguage == "en" {
            welcomeLabel.text = Helper.translate(title: "WELCOME BACK", lang: "en")
            
            emailTextField.placeholder = Helper.translate(title: "Email", lang: "en")
            passwordTextField.placeholder = Helper.translate(title: "Password", lang: "en")
            
            forgotLabel.text = Helper.translate(title: "Forgot Password", lang: "en")
            
            loginButton.setTitle(Helper.translate(title: "LOG IN", lang: "en"), for: .normal)
            
            name = Helper.translate(title: "Forgot Password", lang: "en")
            message = Helper.translate(title: "Enter Email", lang: "en")
            placeholder = Helper.translate(title: "Email", lang: "en")
            cancel = Helper.translate(title: "Cancel", lang: "en")
            reset = Helper.translate(title: "Reset Password", lang: "en")
            resetFailed = Helper.translate(title: "Reset Failed", lang: "en")
            failed = Helper.translate(title: "Error: Something went wrong. Try again", lang: "en")
            success = Helper.translate(title: "Reset email sent successfully", lang: "en")
            check = Helper.translate(title: "Check your email", lang: "en")
        }
        if Helper.selectedLanguage == "kk" {
            welcomeLabel.text = Helper.translate(title: "WELCOME BACK", lang: "kk")
            
            emailTextField.placeholder = Helper.translate(title: "Email", lang: "kk")
            passwordTextField.placeholder = Helper.translate(title: "Password", lang: "kk")
            
            forgotLabel.text = Helper.translate(title: "Forgot Password", lang: "kk")
            
            loginButton.setTitle(Helper.translate(title: "LOG IN", lang: "kk"), for: .normal)
            
            name = Helper.translate(title: "Forgot Password", lang: "kk")
            message = Helper.translate(title: "Enter Email", lang: "kk")
            placeholder = Helper.translate(title: "Email", lang: "kk")
            cancel = Helper.translate(title: "Cancel", lang: "kk")
            reset = Helper.translate(title: "Reset Password", lang: "kk")
            resetFailed = Helper.translate(title: "Reset Failed", lang: "kk")
            failed = Helper.translate(title: "Error: Something went wrong. Try again", lang: "kk")
            success = Helper.translate(title: "Reset email sent successfully", lang: "kk")
            check = Helper.translate(title: "Check your email", lang: "kk")
        }
        if Helper.selectedLanguage == "ru" {
            welcomeLabel.text = Helper.translate(title: "WELCOME BACK", lang: "ru")
            
            emailTextField.placeholder = Helper.translate(title: "Email", lang: "ru")
            passwordTextField.placeholder = Helper.translate(title: "Password", lang: "ru")
            
            forgotLabel.text = Helper.translate(title: "Forgot Password", lang: "ru")
            
            loginButton.setTitle(Helper.translate(title: "LOG IN", lang: "ru"), for: .normal)
            
            name = Helper.translate(title: "Forgot Password", lang: "ru")
            message = Helper.translate(title: "Enter Email", lang: "ru")
            placeholder = Helper.translate(title: "Email", lang: "ru")
            cancel = Helper.translate(title: "Cancel", lang: "ru")
            reset = Helper.translate(title: "Reset Password", lang: "ru")
            resetFailed = Helper.translate(title: "Reset Failed", lang: "ru")
            failed = Helper.translate(title: "Error: Something went wrong. Try again", lang: "ru")
            success = Helper.translate(title: "Reset email sent successfully", lang: "ru")
            check = Helper.translate(title: "Check your email", lang: "ru")
        }
    }
}

extension LoginViewController {
    @objc func forgotTapped() {
        let forgotPasswordAlert = UIAlertController(title: name, message: message, preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = self.placeholder
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: reset, style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: self.resetFailed, message: self.failed, preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else {
                    let resetEmailSentAlert = UIAlertController(title: self.success, message: self.check, preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
        }))
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
}
