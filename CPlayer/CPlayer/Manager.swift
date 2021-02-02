//
//  Manager.swift
//  CPlayer
//
//  Created by Cédric Bahirwe on 22/01/2021.
//

import Foundation
import AVFoundation

class ViewState: NSObject, ObservableObject {
    
    let timer = Timer.publish(every: 0.9, on: .main, in: .common).autoconnect()
    
    
    @Published var selectedtab = 1
    @Published var songs = Bundle.main.decode(Album.self, from: "songs.json")
//
    @Published var currentTime: Double = 0.0
    
    @Published var error: (Bool, String) = (false, "")
    
    @Published var didPlayFirstSong = false
    
    @Published var isPlaying = false
    
    @Published var isLiked = false
    
    @Published var currentSongIndex: Int = 0 {
        didSet {
            playSound(index: currentSongIndex)
        }
    }
    
    @Published var player: AVAudioPlayer?
    @Published var songLength: String = "0.0"
    @Published var length: Double = 0.0
    
    func didPressPlay() {
        
        if player?.isPlaying ?? false {
            pause()
        } else {
            if didPlayFirstSong {
                player?.play()
                isPlaying = true
            } else {
                currentSongIndex = 0
                didPlayFirstSong = true
                
            }
        }
    }
    
    func didPressNext() {
        if player?.isPlaying ?? false {
            player?.stop()
            currentSongIndex += 1
        }
    }
    
    func didPressPrevious() {
        
        if player?.isPlaying ?? false {
            player?.stop()
            currentSongIndex -= 1
        }
    }
    
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func replay() {
        player?.prepareToPlay()
        player?.play()
        isPlaying = true
    }

    
    func setSongFor(_ track: Track) {
        if let index = songs.tracks.firstIndex(where: { $0.index == track.index }) {
            currentSongIndex = index
        }
    }
    
    func setSongFor(_ index: Int) {
        if index < songs.tracks.count {
            currentSongIndex = index
        }
    }
    
    
    func playSound(index: Int) {
        
        
        let trackSource = songs.tracks[index].title
        print(trackSource)
        let path = Bundle.main.path(forResource: "\(trackSource).mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        
        let  audioAsset: AVURLAsset = AVURLAsset(url: url, options: nil)
        let  audioDuration: CMTime = audioAsset.duration
        let  audioDurationSeconds: Double = CMTimeGetSeconds(audioDuration)
        length = audioDurationSeconds
        let minSecs = secondsToHoursMinutesSeconds(seconds: audioDurationSeconds)
        
        songLength = String(Int(minSecs.0)) + ":" + String(format: "%02d", Int(minSecs.1))
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            //            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            
            //            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            
            isPlaying = true
        } catch {
            self.error = (true , "We Couldn't play '\(songs.tracks[currentSongIndex])' track")
        }
        if !didPlayFirstSong { player!.delegate = self }
    }
    
    
    func secondsToHoursMinutesSeconds (seconds : Double) -> (Double, Double) {
        let (_,  minf) = modf (seconds / 3600)
        let (min, secf) = modf (60 * minf)
        return (min, round((60 * secf)))
    }
}


extension ViewState: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Finished playing \(flag)")
        currentSongIndex += 1
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


