//
//  ImageTableViewCell.swift
//  Meditate
//
//  Created by Dina Yestemir on 08.05.2021.
//

import UIKit
import Firebase

protocol ImageTableViewCellDelegate {
    func dismiss()
}
class ImageTableViewCell: UITableViewCell {
    
    var delegate: ImageTableViewCellDelegate?
    var course = ""
    var strings = [String]()
    var uid = ""
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var bannerView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        strings = [String]()
        loadSaved()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        delegate?.dismiss()
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        if !isAdded() {
            likeButton.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            let regObject: Dictionary<String, Any> = [
                "sender" :  Auth.auth().currentUser!.email!,
                "course" : course,
                "date": Date().timeIntervalSince1970
            ]
            Database.database().reference().child("saved").child(Auth.auth().currentUser!.uid).child(course).setValue(regObject)
        } else {
            likeButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
            let ref = Database.database().reference().child("saved").child(Auth.auth().currentUser!.uid).child(course)
               ref.removeValue()
        }
    }
    
    private func loadSaved() {
        let ref = Database.database().reference().child("saved").child(Auth.auth().currentUser!.uid)
        
        DispatchQueue.main.async {
            ref.queryOrdered(byChild: "date").observe(DataEventType.value, with: { (snapshot) in
                if let snap = snapshot.children.allObjects as? [DataSnapshot]{
                    for (_,val) in snap.enumerated(){
                        let value: [String: Any] = val.value as! [String : Any]
                        let course = value["course"] as! String
                        self.strings.append(course)
                    }
                }
                self.reloadLikeButton()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    private func reloadLikeButton() {
        if isAdded() {
            likeButton.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            likeButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
    private func isAdded() ->Bool {
        for i in strings {
            if i == course {
                return true
            }
        }
        return false
    }
}
