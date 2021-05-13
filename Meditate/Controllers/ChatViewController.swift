//
//  ChatViewController.swift
//  Meditate
//
//  Created by Dina Yestemir on 27.04.2021.
//

import UIKit
import Firebase
import AMTabView

class ChatViewController: UIViewController, TabItem {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var messages = [Message]()
    
    var tabImage: UIImage? {
        return UIImage(systemName: "message")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.layer.cornerRadius = 8
        setupTableView()
        startLoading()
        loadMessages()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        self.tableView.separatorStyle = .none
    }
    
    private func startLoading() {
        showIndicator(animationType: .ballTrianglePath, color: #colorLiteral(red: 0.5509303212, green: 0.5867726803, blue: 1, alpha: 1))
    }
    
    private func stopLoading() {
        hideIndicator()
    }
    
    //MARK: - Networking
    
    private func loadMessages() {
        let ref = Database.database().reference().child("messages").child(Auth.auth().currentUser!.uid)
        
        DispatchQueue.main.async {
            ref.queryOrdered(byChild: "date").observe(DataEventType.value, with: { (snapshot) in
                if let snap = snapshot.children.allObjects as? [DataSnapshot]{
                    self.messages.removeAll()
                    for (_,val) in snap.enumerated(){
                        let message: [String: Any] = val.value as! [String : Any]
                        let sender = message["sender"] as! String
                        let text = message["text"] as! String
                        self.messages.append(Message(sender: sender, text: text))
 
                        self.tableView?.reloadData()
                    }
                }
                self.stopLoading()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        let id = UUID().uuidString
        let regObject: Dictionary<String, Any> = [
            "sender" :  Auth.auth().currentUser!.email!,
            "text" : messageTextField.text!,
            "date": Date().timeIntervalSince1970
        ]
        Database.database().reference().child("messages").child(Auth.auth().currentUser!.uid).child(id).setValue(regObject)
        
        emptyView.isHidden = true
        tableView.isHidden = false
        messageTextField.text = ""
    }
    
}

//MARK: - Table View Protocols

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages.count == 0 {
            emptyView.isHidden = false
            tableView.isHidden = true
            return 0
        }
        tableView.isHidden = false
        emptyView.isHidden = true
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        cell.selectionStyle = .none
        if messages[indexPath.row].sender == Auth.auth().currentUser!.email! {
            cell.rightImage.image = UIImage(named: "course_cell2")
            cell.messageBodyLabel.text = messages[indexPath.row].text
            cell.bodyView.backgroundColor = .systemYellow
            cell.leftImage.isHidden = true
            cell.rightImage.isHidden = false
        } else {
            cell.leftImage.image = UIImage(named: "course_cell1")
            cell.messageBodyLabel.text = messages[indexPath.row].text
            cell.rightImage.isHidden = true
            cell.leftImage.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
