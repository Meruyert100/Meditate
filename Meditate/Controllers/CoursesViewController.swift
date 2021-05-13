//
//  CoursesViewController.swift
//  Meditate
//
//  Created by Dina Yestemir on 27.04.2021.
//

import UIKit
import Firebase
import ANActivityIndicator
import AMTabView

class CoursesViewController: UIViewController, TabItem {
    
    @IBOutlet var helloLabel: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tabImage: UIImage? {
        return UIImage(systemName: "house.fill")
    }
    
    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        startLoading()
        loadCourses()
        loadUserName()
    }
    
    private func startLoading() {
        helloLabel.isHidden = true
        welcomeLabel.isHidden = true
        showIndicator(animationType: .ballTrianglePath, color: #colorLiteral(red: 0.5509303212, green: 0.5867726803, blue: 1, alpha: 1))
    }
    
    private func stopLoading() {
        helloLabel.isHidden = false
        welcomeLabel.isHidden = false
        hideIndicator()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CourseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CourseCollectionViewCell")
    }
    
    //MARK: - Networking
    
    private func loadUserName() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!)
        
        DispatchQueue.main.async {
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = value?["username"] as? String ?? ""
                self.welcomeLabel?.text = "Welcome to Meditate, \(name)!"
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
                        self.collectionView?.reloadData()
                    }
                }
                self.stopLoading()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
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

//MARK: - Collection View Protocols

extension CoursesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseCollectionViewCell", for: indexPath) as! CourseCollectionViewCell
        cell.courseTitleLabel.text = courses[indexPath.row].name
        cell.durationLabel.text = courses[indexPath.row].duration
        cell.backgroundImageView.image = fetchImage(imageURL: courses[indexPath.row].image)
        
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
