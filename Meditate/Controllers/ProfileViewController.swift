//
//  ProfileViewController.swift
//  Meditate
//
//  Created by Dina Yestemir on 07.05.2021.
//

import UIKit
import AMTabView
import Firebase

class ProfileViewController: UIViewController, TabItem {

    @IBOutlet weak var courcesCollectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var courses = [Course]()
    var saved = [Course]()
    var strings = [String]()
    
    var tabImage: UIImage? {
        return UIImage(systemName: "person.fill")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadCourses()
        loadUser()
    }
    
    func setupCollectionView() {
        courcesCollectionView.delegate = self
        courcesCollectionView.dataSource = self
        courcesCollectionView.register(UINib(nibName: "CourseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CourseCollectionViewCell")
        
        profileImageView.layer.cornerRadius = 75
    }
    @IBAction func editButtonPressed(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(identifier: "EditViewController") as! EditViewController
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true)
        } catch {
            print(error)
        }
        
    }
    
    //MARK: - Networking
    
    private func loadUser() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!)
        
        DispatchQueue.main.async {
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as! NSDictionary
                let username = value["username"] as! String
                self.nameLabel.text = username
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadCourses() {
        let ref = Database.database().reference().child("courses")
        
        DispatchQueue.main.async {
            ref.observe(DataEventType.value, with: { (snapshot) in
                if let snap = snapshot.children.allObjects as? [DataSnapshot]{
                    for (_,val) in snap.enumerated(){
                        let course: [String: Any] = val.value as! [String : Any]
                        let image = course["imageLink"] as! String
                        let name = course["name"] as! String
                        let duration = course["time"] as! String
                        let description = course["description"] as! String
                        let banner = course["banner"] as! String
                        self.courses.append(Course(name: name, duration: duration, image: image, description: description, banner: banner))
                        self.courcesCollectionView?.reloadData()
                    }
                    self.loadSaved()
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadSaved() {
        
        let ref = Database.database().reference().child("saved").child(Auth.auth().currentUser!.uid)
        
        DispatchQueue.main.async {
            ref.queryOrdered(byChild: "date").observe(DataEventType.value, with: { (snapshot) in
                if let snap = snapshot.children.allObjects as? [DataSnapshot]{
                    self.strings.removeAll()
                    for (_,val) in snap.enumerated(){
                        let value: [String: Any] = val.value as! [String : Any]
                        let course = value["course"] as! String
                        self.strings.append(course)
                    }
                    self.addToSaved()
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    private func addToSaved() {
        saved.removeAll()
        for i in strings {
            for j in courses {
                if i == j.name {
                    saved.append(j)
                }
            }
        }
        courcesCollectionView.reloadData()
    }
    
    private func fetchImage(imageURL: String) -> UIImage {
        let url = URL(string: imageURL)
        let imageData = try? Data(contentsOf: url!)
        let image = UIImage(data: imageData!)
        if let image = image {
            return image
        }
        return UIImage(named: "course_cell1")!
    }
}

//MARK: - CollectionView Delegate

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return saved.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseCollectionViewCell", for: indexPath) as! CourseCollectionViewCell
        cell.courseTitleLabel.text = saved[indexPath.row].name
        cell.durationLabel.text = saved[indexPath.row].duration
        cell.backgroundImageView.image = fetchImage(imageURL: saved[indexPath.row].image)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 10
        return UIEdgeInsets(top: inset, left: inset, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 190, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard!.instantiateViewController(identifier: "CourseDetailsViewController") as! CourseDetailsViewController
        vc.setupView(courseName: courses[indexPath.row].name, courseDescription: courses[indexPath.row].description, courseBanner: fetchImage(imageURL: courses[indexPath.row].banner))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
}
