//
//  MainViewController.swift
//  CPlayer
//
//  Created by Cedric Bahirwe on 10/1/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import UIKit
import WebKit
import SwiftUI


protocol SelectionOnTableDelegate {
    func didSelectSong(at Index: Int, with Author: String)
}


class MainViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    let songs = Bundle.main.decode(Album.self, from: "songs.json")
    var svgs = [ "walking", "happy", "listen", "media", "mello", "musci", "piano", "player", "playlist", "table", "video" ]
    var index = 0
    var transitions: [CGAffineTransform] = [CGAffineTransform(scaleX: 1.5, y: 1.5), CGAffineTransform(rotationAngle: 180), CGAffineTransform(scaleX: 0.6, y: 0.5), CGAffineTransform(translationX: 60, y: 100), CGAffineTransform(scaleX: 0.7, y: 1.5), CGAffineTransform(translationX: -50, y: -100), CGAffineTransform(rotationAngle: 280)]
    
    
    var songDelegate: SelectionOnTableDelegate?
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var listContainerView: UIView!
    var contentInset: CGFloat = .zero  {
        didSet {
            UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
                self.navigationController?.setNavigationBarHidden(self.contentInset >= 30, animated: true)
            })
        }
    }
    let customWebView: WKWebView = {
        let mySVGImage = "<svg height=\"190\"><polygon points=\"100,10 40,180 190,60 10,60 160,180\" style=\"fill:lime;stroke:purple;stroke-width:5;fill-rule:evenodd;\"></svg>"
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = false
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        let wv = WKWebView(frame: .zero, configuration: configuration)
        wv.scrollView.isScrollEnabled = false
        wv.loadHTMLString(mySVGImage, baseURL: nil)
        return wv
    }()
    var svgTimer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.rowHeight = 80
        
        
        self.navigationController?.tabBarItem.badgeValue = self.songs.tracks.count.description
        //        navigationItem.searchController = UISearchController(searchResultsController: nil)
        //        navigationItem.searchController?.searchBar.placeholder = "Search a Song or Artist"
        
    }
    
    @objc func loadSvg(with name: String) {
        let path: String = Bundle.main.path(forResource: name, ofType: "svg")!
        let url = URL(fileURLWithPath: path)
        let request: URLRequest = URLRequest(url: url)
        if #available(iOS 13.0, *) {
            webView.scalesLargeContentImage = false
        } else {
            // Fallback on earlier versions
        }
        webView.load(request)
    }
    func ifDeviceVersionHigherThan_13() {
        if #available(iOS 13.0, *) {
            let hostingController = UIHostingController(rootView: ListView())
            addChild(hostingController)
            
            view.addSubview(hostingController.view)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                hostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
                view.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor),
                view.rightAnchor.constraint(equalTo: hostingController.view.rightAnchor)
            ]
            
            NSLayoutConstraint.activate(constraints)
            hostingController.didMove(toParent: self)
            hostingController.rootView.present = {
                let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ViewController") as ViewController
                destination.didPressPlay(UIButton())
                hostingController.present(destination, animated: true, completion: nil)
            }
            
        } else {
            // Fallback on earlier versions
        }
    }
    
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.songs.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as! SongTableViewCell
        
        let song = self.songs.tracks[indexPath.row]
        cell.songTitle.text = song.title
        cell.songAuthor.text = self.songs.author
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.contentInset = scrollView.contentOffset.y
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let (song, author) = (self.songs.tracks[indexPath.row], self.songs.author)
        print(indexPath.row)
//        self.navigationController?.tabBarController?.selectedIndex = 1
        self.songDelegate?.didSelectSong(at: indexPath.row, with: self.songs.author)
        
    }
    
}

