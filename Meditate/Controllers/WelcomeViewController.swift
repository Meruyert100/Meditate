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
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    var activityView: UIActivityIndicatorView?
    
    var name = ""
    
    var name1 = ""
    var name2 = ""
    
    override func loadView() {
        super.loadView()
        loadUserName()
        setLanguage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicatory()
        setLanguage()
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
                self.nameLabel.text = "\(self.name1) \(self.name), \(self.name2)"
                self.activityView?.stopAnimating()
                self.nameLabel.isHidden = false
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }

        
    }
    
    @IBAction func getStartedButtonPressed(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(identifier: "MenuViewController") as! MenuViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension WelcomeViewController {
    private func setLanguage() {
        if Helper.selectedLanguage == "en" {
            name1 = Helper.translate(title: "Hi", lang: "en")
            name2 = Helper.translate(title: "Welcome to M E D I T A T E", lang: "en")
            
            quoteLabel.text = Helper.translate(title: "Explore the app, Find some peace of mind to prepare for meditation", lang: "en")

            getStartedButton.setTitle(Helper.translate(title: "GET STARTED", lang: "en"), for: .normal)
        }
        if Helper.selectedLanguage == "kk" {
            name1 = Helper.translate(title: "Hi", lang: "kk")
            name2 = Helper.translate(title: "Welcome to M E D I T A T E", lang: "kk")
            
            quoteLabel.text = Helper.translate(title: "Explore the app, Find some peace of mind to prepare for meditation", lang: "kk")

            getStartedButton.setTitle(Helper.translate(title: "GET STARTED", lang: "kk"), for: .normal)
        }
        if Helper.selectedLanguage == "ru" {
            name1 = Helper.translate(title: "Hi", lang: "ru")
            name2 = Helper.translate(title: "Welcome to M E D I T A T E", lang: "ru")
            
            quoteLabel.text = Helper.translate(title: "Explore the app, Find some peace of mind to prepare for meditation", lang: "ru")

            getStartedButton.setTitle(Helper.translate(title: "GET STARTED", lang: "ru"), for: .normal)
        }
    }
}
