//
//  CourseDetailsViewController.swift
//  Meditate
//
//  Created by Dina Yestemir on 08.05.2021.
//

import UIKit
import Firebase

class CourseDetailsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var songs = [Songs]()
    private var courseName = String()
    private var courseDescription = String()
    private var courseBanner = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        startLoading()
        loadSongs()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        tableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
        tableView.register(UINib(nibName: "SongsTableViewCell", bundle: nil), forCellReuseIdentifier: "SongsTableViewCell")
    }
    
    func setupView(courseName: String, courseDescription: String, courseBanner: UIImage) {
        self.courseName = courseName
        self.courseDescription = courseDescription
        self.courseBanner = courseBanner
    }
    
    private func startLoading() {
        showIndicator(animationType: .ballTrianglePath, color: #colorLiteral(red: 0.5509303212, green: 0.5867726803, blue: 1, alpha: 1))
    }
    
    private func stopLoading() {
        hideIndicator()
    }
    
    //MARK: - Loading
    
    private func loadSongs() {
        let ref = Database.database().reference().child("songs")
        
        DispatchQueue.main.async {
            ref.observe(DataEventType.value, with: { (snapshot) in
                if let snap = snapshot.children.allObjects as? [DataSnapshot]{
                    for (_,val) in snap.enumerated(){
                        let song: [String: Any] = val.value as! [String : Any]
                        let name = song["name"] as! String
                        let duration = song["duration"] as! String
                        let course = song["course"] as! String
                        let music = song["music"] as! String
                        if course == self.courseName {
                            self.songs.append(Songs(name: name, duration: duration, music: music))
                            self.tableView?.reloadData()
                        }
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

extension CourseDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
            cell.delegate = self
            cell.bannerView.image = courseBanner
            cell.course = courseName
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
            cell.namelabel.text = courseName
            cell.descriptionLabel.text = courseDescription
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongsTableViewCell", for: indexPath) as! SongsTableViewCell
            cell.nameLabel.text = songs[indexPath.row - 2].name
            cell.timeLabel.text = songs[indexPath.row - 2].duration
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= 2 {
            let vc = storyboard!.instantiateViewController(identifier: "MusicViewController") as! MusicViewController
            vc.setupView(title: songs[indexPath.row - 2].name, courseName: songs[indexPath.row - 2].name, musicLink: songs[indexPath.row - 2].music)
            present(vc, animated: true, completion: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        } else if indexPath.row == 1 {
            return 200
        } else {
            return 50
        }
    }
    
}

//MARK: - custom delegates

extension CourseDetailsViewController: ImageTableViewCellDelegate {
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
