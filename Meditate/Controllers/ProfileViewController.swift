//
//  ProfileViewController.swift
//  Meditate
//
//  Created by Dina Yestemir on 07.05.2021.
//

import UIKit
import AMTabView

class ProfileViewController: UIViewController, TabItem {

    @IBOutlet weak var courcesCollectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var courses = [Course]()
    
    var tabImage: UIImage? {
        return UIImage(systemName: "person.fill")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        courcesCollectionView.delegate = self
        courcesCollectionView.dataSource = self
        courcesCollectionView.register(UINib(nibName: "CourseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CourseCollectionViewCell")
        
        profileImageView.layer.cornerRadius = 75
    }
}

//MARK: - CollectionView Delegate

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseCollectionViewCell", for: indexPath) as! CourseCollectionViewCell
        cell.courseTitleLabel.text = courses[indexPath.row].name
        cell.durationLabel.text = courses[indexPath.row].duration
        cell.backgroundImageView.image = UIImage(named: courses[indexPath.row].image)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 10
        return UIEdgeInsets(top: inset, left: inset, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 190, height: 220)
    }
    
}
