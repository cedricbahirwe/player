//
//  ViewController.swift
//  CPlayer
//
//  Created by Cedric Bahirwe on 9/29/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songAuthor: UILabel!
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var genreStack: UIStackView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var mainController: MainViewController?
    var didPlayFirstSong = false
    
    var isPlaying = false {
        didSet {
            let image = self.isPlaying ? #imageLiteral(resourceName: "pause.button") : #imageLiteral(resourceName: "play.button")
            UIView.animate(withDuration: 0.16, animations: {
                self.playButton.setImage(image, for: .normal)
            })
        }
    }
    var isLiked = false {
        didSet {
            let image = self.isLiked ? #imageLiteral(resourceName: "liked") : #imageLiteral(resourceName: "like")
            UIView.animate(withDuration: 0.16, animations: {
                self.favoriteButton.setImage(image, for: .normal)
            })
        }
    }
    let songs = Bundle.main.decode(Album.self, from: "songs.json")
    var currentSongIndex: Int = 0 {
        didSet {
            self.songTitle = self.songs.tracks[currentSongIndex].title
             self.tabBarItem.badgeValue = self.songs.tracks[currentSongIndex].index.description
        }
    }
    var songTitle: String = "" {
        didSet {
            self.songTitleLabel.text = songTitle
        }
    }
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTheme(userInterfaceStyle: self.traitCollection.userInterfaceStyle)
        self.currentSongIndex = 0
        self.customization()
        self.songAuthor.text = self.songs.author
        
        let navController =  self.tabBarController?.viewControllers?.first as! UINavigationController
        let musicController = navController.viewControllers.first as! MainViewController
        musicController.songDelegate = self
        
    }
    
    @IBAction func didPressPlay(_ sender: UIButton) {
        
        if self.player?.isPlaying ?? false {
            self.pause()
            self.isPlaying = false
        } else {
            if self.didPlayFirstSong {
                self.player?.play()
            } else {
                self.playSound(index: self.currentSongIndex)
                self.didPlayFirstSong = true
                
            }
        }
    }
    
    @IBAction func didPressNext(_ sender: UIButton) {
        if player?.isPlaying ?? false {
            self.currentSongIndex += 1
            self.stopAndPlay(index: self.currentSongIndex)
        }
    }
    
    @IBAction func didPressPrevious(_ sender: UIButton) {
        
        if self.player?.isPlaying ?? false {
            self.currentSongIndex -= 1
            self.stopAndPlay(index: self.currentSongIndex)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        updateTheme(userInterfaceStyle: userInterfaceStyle)
        
    }
    
    func updateTheme(userInterfaceStyle: UIUserInterfaceStyle) {
        switch  userInterfaceStyle {
        case .dark:
            songImage.layer.borderWidth = 1.5
            songImage.layer.borderColor = UIColor.red.withAlphaComponent(0.75).cgColor
        case .light, .unspecified:
            songImage.layer.borderWidth = .zero
            songImage.layer.borderColor = nil
        default:
            songImage.layer.borderWidth = 0
            songImage.layer.borderColor = nil
        }
    }
    
    func playSound(index: Int) {
        let trackSource = self.songs.tracks[index].title
        print(trackSource)
        let path = Bundle.main.path(forResource: "\(trackSource).mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            
            self.isPlaying = true
        } catch {
            let alert = UIAlertController(title: "Sorry!!!", message: "We Couldn't play '\(self.songs.tracks[self.currentSongIndex])' track" , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Dismiss", style: .cancel)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        if !didPlayFirstSong { self.player!.delegate = self }
    }
    func pause() {
        player?.pause()
        self.isPlaying = false
    }
    
    func replay() {
        player?.prepareToPlay()
        player?.play()
        self.isPlaying = true
    }
    
    func stopAndPlay(index: Int?) {
        player?.stop()
        if let playedIndex = index {
            self.playSound(index: playedIndex)
        }
    }
    
    func customization() {
        previousButton.layer.cornerRadius = previousButton.frame.width / 2
        playButton.layer.cornerRadius = playButton.frame.width / 2
        nextButton.layer.cornerRadius = nextButton.frame.width / 2
        
        songImage.layer.cornerRadius = 20
        songImage.layer.shadowColor = UIColor.red.cgColor
        songImage.layer.shadowOffset = CGSize(width: 3, height: 3)
        songImage.layer.shadowRadius = 4
        songImage.layer.shadowOpacity = 0.8
        
        favoriteButton.layer.cornerRadius = favoriteButton.frame.width / 2
        favoriteButton.layer.borderWidth = 1.5
        if #available(iOS 13.0, *) {
            favoriteButton.layer.borderColor = UIColor.label.cgColor
        } else {
            favoriteButton.layer.borderColor = UIColor.black.cgColor
        }
        
        
        genreStack.subviews.forEach { subview in
            if subview.isKind(of: UIButton.self) {
                subview.layer.cornerRadius = subview.frame.height / 2
            }
        }
        
    }
    @IBAction func likePressFavorite(_ sender: UIButton) {
        self.isLiked.toggle()
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished playing song")
    }
}

extension ViewController: SelectionOnTableDelegate {
    func didSelectSong(at Index: Int, with Author: String) {
        print("Merde")
        self.playSound(index: Index)
        self.currentSongIndex = Index
    }

}

