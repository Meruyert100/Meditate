//
//  MenuViewController.swift
//  Meditate
//
//  Created by Dina Yestemir on 13.05.2021.
//

import UIKit
import AMTabView

class MenuViewController: AMTabsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabsControllers()
    }
    
    private func setTabsControllers() {
        
        AMTabView.settings.tabColor = #colorLiteral(red: 0.5509303212, green: 0.5867726803, blue: 1, alpha: 1)
        AMTabView.settings.ballColor = #colorLiteral(red: 0.9994668365, green: 0.7879567742, blue: 0.4950447083, alpha: 1)
        AMTabView.settings.unSelectedTabTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let coursesViewController = storyboard.instantiateViewController(withIdentifier: "CoursesViewController")
        let chatViewController = storyboard.instantiateViewController(withIdentifier:"ChatsViewController")
        let meditateViewController = storyboard.instantiateViewController(withIdentifier: "MeditateViewController")
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")

        viewControllers = [
            coursesViewController,
            chatViewController,
            meditateViewController,
            profileViewController
        ]
      }

}
