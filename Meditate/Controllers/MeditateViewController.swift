//
//  MeditateViewController.swift
//  Meditate
//
//  Created by Dina Yestemir on 05.05.2021.
//

import UIKit
import Firebase
import AMTabView

class MeditateViewController: UIViewController, TabItem {
    
    var meditations = [Meditation]()
    var stories = [Story]()
    
    var tabImage: UIImage? {
        return UIImage(systemName: "timelapse")
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        startLoading()
        loadMeditations()
        loadStories()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        storiesCollectionView.delegate = self
        storiesCollectionView.dataSource = self
    }
    
    private func startLoading() {
        showIndicator(animationType: .ballTrianglePath, color: #colorLiteral(red: 0.5509303212, green: 0.5867726803, blue: 1, alpha: 1))
    }
    
    private func stopLoading() {
        hideIndicator()
    }
    
    //MARK: - Networking
    
    private func loadStories() {
        let ref = Database.database().reference().child("stories")
        
        DispatchQueue.main.async {
            ref.observe(DataEventType.value, with: { (snapshot) in
                if let snap = snapshot.children.allObjects as? [DataSnapshot]{
                    for (_,val) in snap.enumerated(){
                        let story: [String: Any] = val.value as! [String : Any]
                        let image = story["image"] as! String
                        let name = story["name"] as! String
                        let photo = story["photo"] as! String
                        self.stories.append(Story(image: image, name: name, photo: photo))
                        
                        self.storiesCollectionView?.reloadData()
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadMeditations() {
        let ref = Database.database().reference().child("mediations")
        
        DispatchQueue.main.async {
            ref.observe(DataEventType.value, with: { (snapshot) in
                if let snap = snapshot.children.allObjects as? [DataSnapshot]{
                    for (_,val) in snap.enumerated(){
                        let mediations: [String: Any] = val.value as! [String : Any]
                        let image = mediations["image"] as! String
                        let name = mediations["name"] as! String
                        let music = mediations["music"] as! String
                        self.meditations.append(Meditation(name: name, image: image, music: music))
                        
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


//MARK: - CollectionView Delegates

extension MeditateViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return meditations.count
        } else {
            return stories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeditateCollectionViewCell", for: indexPath) as! MeditateCollectionViewCell
            cell.imageView.image = fetchImage(imageURL: meditations[indexPath.row].image)
            cell.nameLabel.text = meditations[indexPath.row].name
            return cell
        } else {
            let cell = storiesCollectionView.dequeueReusableCell(withReuseIdentifier: "StoriesCollectionViewCell", for: indexPath) as! StoriesCollectionViewCell
            cell.imageView.image = fetchImage(imageURL: stories[indexPath.row].image)
            cell.nameLabel.text = stories[indexPath.row].name
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView {
            let vc = storyboard!.instantiateViewController(identifier: "MusicViewController") as! MusicViewController
            vc.setupView(title: meditations[indexPath.row].name, courseName: meditations[indexPath.row].name, musicLink: meditations[indexPath.row].music)
            present(vc, animated: true, completion: nil)
        } else {
            let vc = storyboard!.instantiateViewController(identifier: "StoryViewController") as! StoryViewController
            vc.modalPresentationStyle = .fullScreen
            vc.photo = fetchImage(imageURL: stories[indexPath.row].photo)
            present(vc, animated: true, completion: nil)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 10
        return UIEdgeInsets(top: inset, left: inset, bottom: 0, right: 0)
    }

}
