//
//  SignUpViewController.swift
//  Meditate
//
//  Created by Meruyert Tastandiyeva on 4/21/21.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var createLabel: UILabel!
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var rightNameImageView: UIImageView!
    @IBOutlet weak var rightEmailImageView: UIImageView!
    @IBOutlet weak var passwordImageView: UIImageView!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var policyLabel: UILabel!
    @IBOutlet weak var policyImageView: UIImageView!
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    var policyIsChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUI()
        setLanguage()
        addGestureRecognizers()
        addDelegates()
    }
    
    private func addDelegates() {
        nameTextField.delegate = self
        emailTextField.delegate = self
    }
    
    private func loadUI() {
        navigationController?.navigationBar.isHidden = true
        
        nameView.layer.cornerRadius = 20
        emailView.layer.cornerRadius = 20
        passwordView.layer.cornerRadius = 20
        
        getStartedButton.layer.cornerRadius = 30
    }
    
    private func addGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(policyChecked))
        policyImageView.isUserInteractionEnabled = true
        policyImageView.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(passwordRevealed))
        passwordImageView.isUserInteractionEnabled = true
        passwordImageView.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(showPolicy))
        policyLabel.isUserInteractionEnabled = true
        policyLabel.addGestureRecognizer(tapGesture3)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getStartedButtonPressed(_ sender: Any) {
        if let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
            
            if policyIsChecked {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let e = error {
                        print(e)
                        if password.count < 6 {
                            self.createAlert(title: "Password must be more than 6 symbols long", message: "Please check again")
                        } else {
                            self.createAlert(title: "Wrong email format", message: "Please check again")
                        }
                    } else {
                        
                        if let uid = Auth.auth().currentUser?.uid {
                            
                            let regObject: Dictionary<String, Any> = [
                                "uid" : uid,
                                "username" : name,
                                "email": email
                            ]
                            Database.database().reference().child("users").child(uid).setValue(regObject)
                        }
                        
                        self.performSegue(withIdentifier: "RegisterToWelcome", sender: self)
                    }
                }
            } else {
                self.createAlert(title: "Check the Policy", message: "Please...")
            }
        }
    }
        
}

extension SignUpViewController {
    private func setLanguage() {
        if Helper.selectedLanguage == "en" {
            createLabel.text = Helper.translate(title: "CREATE YOUR ACCOUNT", lang: "en")
            
            nameTextField.placeholder = Helper.translate(title: "Name", lang: "en")
            emailTextField.placeholder = Helper.translate(title: "Email", lang: "en")
            passwordTextField.placeholder = Helper.translate(title: "Password", lang: "en")
            
            questionLabel.text = Helper.translate(title: "I have read the", lang: "en")
            policyLabel.text = Helper.translate(title: "Privacy Policy", lang: "en")
            
            getStartedButton.setTitle(Helper.translate(title: "GET STARTED", lang: "en"), for: .normal)
        }
        if Helper.selectedLanguage == "kk" {
            createLabel.text = Helper.translate(title: "CREATE YOUR ACCOUNT", lang: "kk")
            
            nameTextField.placeholder = Helper.translate(title: "Name", lang: "kk")
            emailTextField.placeholder = Helper.translate(title: "Email", lang: "kk")
            passwordTextField.placeholder = Helper.translate(title: "Password", lang: "kk")
            
            questionLabel.text = Helper.translate(title: "I have read the", lang: "kk")
            policyLabel.text = Helper.translate(title: "Privacy Policy", lang: "kk")
            
            getStartedButton.setTitle(Helper.translate(title: "GET STARTED", lang: "kk"), for: .normal)
        }
        if Helper.selectedLanguage == "ru" {
            createLabel.text = Helper.translate(title: "CREATE YOUR ACCOUNT", lang: "ru")
            
            nameTextField.placeholder = Helper.translate(title: "Name", lang: "ru")
            emailTextField.placeholder = Helper.translate(title: "Email", lang: "ru")
            passwordTextField.placeholder = Helper.translate(title: "Password", lang: "ru")
            
            questionLabel.text = Helper.translate(title: "I have read the", lang: "ru")
            policyLabel.text = Helper.translate(title: "Privacy Policy", lang: "ru")
            
            getStartedButton.setTitle(Helper.translate(title: "GET STARTED", lang: "ru"), for: .normal)

        }
    }
}

extension SignUpViewController {
    @objc func policyChecked() {
        if policyImageView.image == UIImage(named: "policyRectangleChecked") {
            policyImageView.image = UIImage(named: "policyRectangle")
            policyIsChecked = false
        } else {
            policyImageView.image = UIImage(named: "policyRectangleChecked")
            policyIsChecked = true
        }
    }
    
    @objc func passwordRevealed() {
        if passwordImageView.image == UIImage(named: "openEye") {
            passwordImageView.image = UIImage(named: "closedEye")
            passwordTextField.isSecureTextEntry = true
        } else {
            passwordImageView.image = UIImage(named: "openEye")
            passwordTextField.isSecureTextEntry = false
        }
    }
    
    private func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func showPolicy() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "policyVC")
        as! PrivacyViewController
        self.present(vc, animated: true, completion: nil)
    }

}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !nameTextField.text!.isEmpty {
            rightNameImageView.image = UIImage(named: "right")
        } else {
            rightNameImageView.image = nil
        }
        
        if !emailTextField.text!.isEmpty {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            if emailPred.evaluate(with: emailTextField.text) {
                rightEmailImageView.image = UIImage(named: "right")
            } else {
                rightEmailImageView.image = UIImage(named: "openEye")
            }
        } else {
            rightEmailImageView.image = nil
        }
    }
}
