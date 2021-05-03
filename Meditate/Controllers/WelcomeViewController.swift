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
    
    var activityView: UIActivityIndicatorView?
    
    var name = ""
    
    override func loadView() {
        super.loadView()
        loadUserName()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicatory()
        loadUI()
    }
    
    private func loadUI() {
        navigationController?.navigationBar.isHidden = true
        
        getStartedButton.layer.cornerRadius = 30
        
        nameLabel.isHidden = true
    }
    
    private func showActivityIndicatory() {
        activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    private func loadUserName() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!)
        
        DispatchQueue.main.async {
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.name = value?["username"] as? String ?? ""
                self.nameLabel.text = "Hi \(self.name), Welcome to \nM E D I T A T E"
                self.activityView?.stopAnimating()
                self.nameLabel.isHidden = false
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }

        
    }
    
    @IBAction func getStartedButtonPressed(_ sender: Any) {
        
    }
}
