//
//  ChatsViewController.swift
//  Meditate
//
//  Created by Dina Yestemir on 30.05.2021.
//

struct Chats {
    let name: String
    let photo: String
    let login: String
    let uid: String
}
import UIKit
import AMTabView
import Firebase

class ChatsViewController: UIViewController, TabItem {
    var tabImage: UIImage? {
        return UIImage(systemName: "message")
    }
    
    private var isAdmin: Bool = false
    
    private var chats: [Chats] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupTableView()
        checkForAdmin()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register((UINib(nibName: "ChatsTableViewCell", bundle: nil)), forCellReuseIdentifier: "ChatsTableViewCell")
    }
    
    
    private func startLoading() {
        showIndicator(animationType: .ballTrianglePath, color: #colorLiteral(red: 0.5509303212, green: 0.5867726803, blue: 1, alpha: 1))
    }
    
    private func stopLoading() {
        hideIndicator()
    }

    
    //MARK: - Networking
    private func checkForAdmin() {
        startLoading()
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!)
        
        DispatchQueue.main.async {
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as! NSDictionary
                let status = value["status"] as! String
                if status == "admin" {
                    self.isAdmin = true
                    self.loadChats()
                } else {
                    self.isAdmin = false
                    self.chats = [Chats(name: "Mediator", photo: "admin", login: "moderator@maditate.com", uid: userID!)]
                    self.stopLoading()
                    self.tableView.reloadData()
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadChats() {
        let ref = Database.database().reference().child("users")
        
        DispatchQueue.main.async {
            ref.observe(DataEventType.value, with: { (snapshot) in
                if let snap = snapshot.children.allObjects as? [DataSnapshot]{
                    for (_,val) in snap.enumerated(){
                        let value: [String: Any] = val.value as! [String : Any]
                        let nickname = value["nickname"] as! String
                        let avatar = value["avatar"] as! String
                        let status = value["status"] as! String
                        let uid = value["uid"] as! String
                        if status != "admin" {
                            self.chats.append(Chats(name: nickname, photo: avatar, login: status, uid: uid))
                        }
 
                        self.tableView?.reloadData()
                    }
                }
                self.stopLoading()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }

}

//MARK: - Table View Delegates

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsTableViewCell", for: indexPath) as! ChatsTableViewCell
        cell.selectionStyle = .none
        cell.avatarImage.image = UIImage(named: chats[indexPath.row].photo) ?? UIImage(systemName: "person")!
        cell.nameLabel.text = chats[indexPath.row].name
        cell.messageLabel.text = chats[indexPath.row].login
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard!.instantiateViewController(identifier: "MessagesViewController") as! MessagesViewController
        vc.setPeer(uid: chats[indexPath.row].uid)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
