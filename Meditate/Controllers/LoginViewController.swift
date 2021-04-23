//
//  LoginViewController.swift
//  Meditate
//
//  Created by Meruyert Tastandiyeva on 4/21/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUI()
        addGestureRecognizer()
    }
    
    private func loadUI() {
        navigationController?.navigationBar.isHidden = true
        
        emailView.layer.cornerRadius = 20
        passwordView.layer.cornerRadius = 20
        
        loginButton.layer.cornerRadius = 30
    }
    
    private func addGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signUpLabelPressed))
        signUpLabel.isUserInteractionEnabled = true
        signUpLabel.addGestureRecognizer(tapGesture)
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
    
    @objc func signUpLabelPressed() {
        self.performSegue(withIdentifier: "LoginToSignUp", sender: self)
    }
}
