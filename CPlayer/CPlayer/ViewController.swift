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
    let songs = Bundle.main.decode(Album.self, from: "songs.json")
    var currentSongIndex: Int = 0 {
        didSet {
            self.songTitle = self.songs.tracks[currentSongIndex].title
        }
    }
    var songTitle: String = "" {
        didSet {
            self.songTitleLabel.text = songTitle
        }
    }
//    var filePaths = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil).sorted()
    var player: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentSongIndex = 0
        self.customization()
        self.updateTheme(userInterfaceStyle: self.traitCollection.userInterfaceStyle)
        self.songAuthor.text = self.songs.author
        print(songs.tracks.count)

    }
    
    @IBAction func didPressPlay(_ sender: UIButton) {
        if self.player?.isPlaying ?? false {
            self.pause()
        } else {
            self.playSound(index: self.currentSongIndex)
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
//        let prefix  = index <= 9 ? "0\(index)" : String(index)
        let trackSource = self.songs.tracks[self.currentSongIndex].title
        print(trackSource)
        let path = Bundle.main.path(forResource: "\(trackSource).mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            let alert = UIAlertController(title: "Sorry!!!", message: "We Couldn't play '\(self.songs.tracks[self.currentSongIndex])' track" , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Dismiss", style: .cancel)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func pause() {
        player?.pause()
    }
    
    func replay() {
        player?.prepareToPlay()
        player?.play()
       
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
    
    
}

struct Album: Codable {
    var author: String
    var tracks: [Track]
}

struct Track: Codable {
    var index: Int
    var title: String
}



extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}
