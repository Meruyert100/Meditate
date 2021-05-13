//
//  MusicViewController.swift
//  Meditate
//
//  Created by Dina Yestemir on 11.05.2021.
//

import UIKit
import AVFoundation
import Firebase

class MusicViewController: UIViewController {
    
    var titleName = "String"
    var courseName = "String"
    var musicLink = "String"
    var audioPlayer: AVAudioPlayer?
//    var updater = CADisplayLink()
    var timer = Timer()
    var isOn = false
    var isDownloaded = false

    @IBOutlet weak var durationView: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    var normalizedTime = Float()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = self.titleName
        courseLabel.text = self.courseName
        downloadFileFromURL(url: URL(string: musicLink)!)
        print("bbb", durationView.progress)
    }
    
    func setupView(title: String, courseName: String, musicLink: String) {
        self.titleName = title
        self.courseName = courseName
        self.musicLink = musicLink
    }
    
    func downloadFileFromURL(url: URL){
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url) { (url, response, error) in
            self.isDownloaded = true
            self.play(url: url!)
        }
        downloadTask.resume()
    }
    
    func play(url:URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url as URL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 5.0
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            
            DispatchQueue.main.async {
                if let audioPlayer = self.audioPlayer {
                    self.normalizedTime = Float(audioPlayer.currentTime / (audioPlayer.duration))
                    self.durationView.progress = self.normalizedTime
                }
            }
            
            if self.durationView.progress >= 1.0 {
                self.timer.invalidate()
            }
            })
        if !isDownloaded {
            return
        }
        
        if isOn {
            playButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
            audioPlayer?.stop()
            self.timer.invalidate()
            isOn = false
        } else {
            playButton.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
            audioPlayer?.play()
            isOn = true
        }
    }
    
}
