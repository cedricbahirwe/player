//
//  Manager.swift
//  CPlayer
//
//  Created by Cédric Bahirwe on 22/01/2021.
//

import Foundation
import AVFoundation

class ViewState: NSObject, ObservableObject {
    @Published var selectedtab = 1
    @Published var songs = Bundle.main.decode(Album.self, from: "songs.json")
    @Published var selectedTrack: Track? = nil {
        didSet {
            if let index = songs.tracks.firstIndex(where: { $0.title == selectedTrack?.title}) {
                playSound(index: index)
            }
        }
    }
    
    @Published var error: (Bool, String) = (false, "")
    
    @Published var didPlayFirstSong = false

    @Published var isPlaying = false
    
    @Published var isLiked = false
    
    @Published var currentSongIndex: Int = 0
    
    @Published var player: AVAudioPlayer?

    func didPressPlay() {
        
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
    
    func didPressNext() {
        if player?.isPlaying ?? false {
            self.currentSongIndex += 1
            self.stopAndPlay(index: self.currentSongIndex)
        }
    }
    
    func didPressPrevious() {
        
        if self.player?.isPlaying ?? false {
            self.currentSongIndex -= 1
            self.stopAndPlay(index: self.currentSongIndex)
        }
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
    
    
    func playSound(index: Int) {
        let trackSource = songs.tracks[index].title
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
            self.error = (true , "We Couldn't play '\(songs.tracks[self.currentSongIndex])' track")
        }
        if !didPlayFirstSong { self.player!.delegate = self }
    }
}


extension ViewState: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Finished playing \(flag)")
        currentSongIndex += 1
        playSound(index: currentSongIndex)
    }
    
}



//let customWebView: WKWebView = {
//    let mySVGImage = "<svg height=\"190\"><polygon points=\"100,10 40,180 190,60 10,60 160,180\" style=\"fill:lime;stroke:purple;stroke-width:5;fill-rule:evenodd;\"></svg>"
//    let preferences = WKPreferences()
//
//    ///       javaScriptEnabled' was deprecated in iOS 14.0: Use WKWebPagePreferences.allowsContentJavaScript to disable content JavaScript on a per-navigation basis
//    //        preferences.javaScriptEnabled = false
//    let configuration = WKWebViewConfiguration()
//    configuration.preferences = preferences
//    let wv = WKWebView(frame: .zero, configuration: configuration)
//    wv.scrollView.isScrollEnabled = false
//    wv.loadHTMLString(mySVGImage, baseURL: nil)
//    return wv
//}()
//
//@State var showSong = false
//@State private var songs = Bundle.main.decode(Album.self, from: "songs.json")
////    let songs = Bundle.main.decode(Album.self, from: "songs.json")
//var svgs = [ "walking", "happy", "listen", "media", "mello", "musci", "piano", "player", "playlist", "table", "video" ]


