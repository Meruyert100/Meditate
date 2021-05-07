//
//  HomeViewController.swift
//  Meditate
//
//  Created by Meruyert Tastandiyeva on 4/23/21.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var wishLabel: UILabel?
    @IBOutlet weak var topLabel: UILabel?
    
    @IBOutlet weak var coursesCollectionView: UICollectionView?
    @IBOutlet weak var choicesCollectionView: UICollectionView?
    
    var courses: [Course] = []
    var choices: [Choice] = []
    
    var name = ""
    
    var activityView: UIActivityIndicatorView?
    
    var name1 = ""
    var name2 = ""
    
    override func loadView() {
        super.loadView()
        loadUserName()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        setLanguage()
        showActivityIndicatory()
        loadCourses()
        loadChoices()
    }
    
    private func loadUI() {
        [nameLabel, wishLabel, topLabel, coursesCollectionView, choicesCollectionView].forEach {
            $0?.isHidden = true
        }
    }
    
    private func showUI() {
        [nameLabel, wishLabel, topLabel, coursesCollectionView, choicesCollectionView].forEach {
            $0?.isHidden = false
        }
    }
    
    private func showActivityIndicatory() {
        activityView = UIActivityIndicatorView(style: .gray)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    private func loadCourses() {
        let ref = Database.database().reference().child("courses")
        
        var imageLink = ""
        var name = ""
        var time = ""
        
        DispatchQueue.main.async {
            ref.observe(DataEventType.value, with: { (snapshot) in
                if let snap = snapshot.children.allObjects as? [DataSnapshot]{
                    for (_,val) in snap.enumerated(){
                        let course: [String: Any] = val.value as! [String : Any]
                        imageLink = course["imageLink"] as! String
                        name = course["name"] as! String
                        time = course["time"] as! String
                        self.courses.append(Course(imageLink: imageLink, name: name, time: time))
                        DispatchQueue.main.async {
                            self.coursesCollectionView?.reloadData()
                        }
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    private func fetchImage(imageURL: String) -> UIImage {
        let url = URL(string: imageURL)
        
        let imageData = try? Data(contentsOf: url!)
        
        let image = UIImage(data: imageData!)
        
        return image!
    }
    
    private func loadChoices() {
        let ref = Database.database().reference().child("choices")
        
        var imageLink = ""
        var name = ""
        var time = ""
        
        DispatchQueue.main.async {
            ref.observe(DataEventType.value, with: { (snapshot) in
                if let snap = snapshot.children.allObjects as? [DataSnapshot]{
                    for (_,val) in snap.enumerated(){
                        let course: [String: Any] = val.value as! [String : Any]
                        imageLink = course["imageLink"] as! String
                        name = course["name"] as! String
                        time = course["time"] as! String
                        self.choices.append(Choice(imageLink: imageLink, name: name, time: time))
                        DispatchQueue.main.async {
                            self.choicesCollectionView?.reloadData()
                            self.activityView?.stopAnimating()
                            self.showUI()
                        }
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    private func loadUserName() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!)
        
        DispatchQueue.main.async {
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.name = value?["username"] as? String ?? ""
                self.nameLabel?.text = "\(self.name1) \(self.name), \(self.name2)"
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    private func setLanguage() {
        if Helper.selectedLanguage == "en" {
            name1 = Helper.translate(title: "Hi", lang: "en")
            name2 = Helper.translate(title: "Welcome to M E D I T A T E", lang: "en")
            
            wishLabel?.text = Helper.translate(title: "We Wish you have a good day", lang: "en")
            
            topLabel?.text = Helper.translate(title: "TOP Choices", lang: "en")
        }
        if Helper.selectedLanguage == "kk" {
            name1 = Helper.translate(title: "Hi", lang: "kk")
            name2 = Helper.translate(title: "Welcome to M E D I T A T E", lang: "kk")
            
            wishLabel?.text = Helper.translate(title: "We Wish you have a good day", lang: "kk")
            
            topLabel?.text = Helper.translate(title: "TOP Choices", lang: "kk")
        }
        if Helper.selectedLanguage == "ru" {
            name1 = Helper.translate(title: "Hi", lang: "ru")
            name2 = Helper.translate(title: "Welcome to M E D I T A T E", lang: "ru")
            
            wishLabel?.text = Helper.translate(title: "We Wish you have a good day", lang: "ru")
            
            topLabel?.text = Helper.translate(title: "TOP Choices", lang: "ru")
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.coursesCollectionView {
            return courses.count
        }
        return choices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.coursesCollectionView {
            let course = collectionView.dequeueReusableCell(withReuseIdentifier: "courseCell", for: indexPath) as! CourseCollectionViewCell
            let url = courses[indexPath.row].imageLink
            course.courseImageView!.image = fetchImage(imageURL: url!)
            course.nameLabel?.text = courses[indexPath.row].name
            course.timeLabel?.text = "\(Helper.translate(title: "Time", lang: Helper.selectedLanguage)) \(courses[indexPath.row].time ?? "")"
            return course
        } else {
            let choice = collectionView.dequeueReusableCell(withReuseIdentifier: "choiceCell", for: indexPath) as! ChoicesCollectionViewCell
            let url = choices[indexPath.row].imageLink
            choice.choiceImageView!.image = fetchImage(imageURL: url!)
            choice.nameLabel.text = choices[indexPath.row].name
            choice.timeLabel.text = "\(Helper.translate(title: "Time", lang: Helper.selectedLanguage)) \(choices[indexPath.row].time ?? "")"
            return choice
        }
    }
 
}

