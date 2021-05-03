//
//  SignUpViewController.swift
//  Meditate
//
//  Created by Meruyert Tastandiyeva on 4/21/21.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var rightNameImageView: UIImageView!
    @IBOutlet weak var rightEmailImageView: UIImageView!
    @IBOutlet weak var passwordImageView: UIImageView!
    
    @IBOutlet weak var policyImageView: UIImageView!
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    var policyIsChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUI()
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
                        self.createAlert(title: "Invalid Credentials", message: "Please check again")
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

}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !nameTextField.text!.isEmpty || !emailTextField.text!.isEmpty {
            rightNameImageView.image = UIImage(named: "right")
        } else {
            rightNameImageView.image = nil
        }
        
        if !emailTextField.text!.isEmpty {
            rightEmailImageView.image = UIImage(named: "right")
        } else {
            rightEmailImageView.image = nil
        }
    }
}
