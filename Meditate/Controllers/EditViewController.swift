//
//  EditViewController.swift
//  Meditate
//
//  Created by Dina Yestemir on 31.05.2021.
//


import UIKit
import Firebase

class EditViewController: UIViewController {
    
    @IBOutlet weak var userImageview: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfo()
    }
    
    private func loadInfo() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(uid!)
        
        DispatchQueue.main.async {
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.nameTextField.text = value?["username"] as? String
                self.emailTextField.text = value?["email"] as? String
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let values: [String: Any] = ["username": nameTextField.text! , "email": emailTextField.text!]
        let _ = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).updateChildValues(values)
        dismiss(animated: true, completion: nil)
    }
    
}


