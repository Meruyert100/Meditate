//
//  WelcomeViewController.swift
//  Meditate
//
//  Created by Meruyert Tastandiyeva on 4/22/21.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    var name = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUI()
        loadUserName()
    }
    
    private func loadUI() {
        navigationController?.navigationBar.isHidden = true
        
        getStartedButton.layer.cornerRadius = 30
    }

    private func loadUserName() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!)

        DispatchQueue.main.async {
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.name = value?["username"] as? String ?? ""
                self.nameLabel.text = "Hi \(self.name), Welcome to M E D I T A T E"
              }) { (error) in
                print(error.localizedDescription)
            }
            
        }
    
    }
    
    @IBAction func getStartedButtonPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
