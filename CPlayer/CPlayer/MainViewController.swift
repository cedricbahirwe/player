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


class MainViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    var svgs = [ "walking", "happy", "listen", "media", "mello", "musci", "piano", "player", "playlist", "table", "video" ]
    var index = 0
    var transitions: [CGAffineTransform] = [CGAffineTransform(scaleX: 1.5, y: 1.5), CGAffineTransform(rotationAngle: 180), CGAffineTransform(scaleX: 0.6, y: 0.5), CGAffineTransform(translationX: 60, y: 100), CGAffineTransform(scaleX: 0.7, y: 1.5), CGAffineTransform(translationX: -50, y: -100), CGAffineTransform(rotationAngle: 280)]
    
    
    @IBOutlet weak var listContainerView: UIView!
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
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            UIView.animate(withDuration: 1, delay: 0, options: .transitionFlipFromBottom, animations: {
                self.webView.transform = self.transitions.randomElement()!
                self.loadSvg(with: self.svgs[self.index])
            }, completion: { _ in
                UIView.animate(withDuration: 1) {
                    self.webView.transform = CGAffineTransform.identity
                }
            })
            
            self.index += 1
            if self.index == self.svgs.count {
                timer.invalidate()
            }
        }
        if #available(iOS 13.0, *) {
            addSubSwiftUIView(ListView(), to: self.listContainerView)
        } else {
            // Fallback on earlier versions
        }
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


@available(iOS 13.0, *)
extension UIViewController {
    
    /// Add a SwiftUI `View` as a child of the input `UIView`.
    /// - Parameters:
    ///   - swiftUIView: The SwiftUI `View` to add as a child.
    ///   - view: The `UIView` instance to which the view should be added.
    func addSubSwiftUIView<Content>(_ swiftUIView: Content, to view: UIView) where Content : View {
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        /// Add as a child of the current view controller.
        addChild(hostingController)
        
        /// Add the SwiftUI view to the view controller view hierarchy.
        view.addSubview(hostingController.view)
        
        /// Setup the contraints to update the SwiftUI view boundaries.
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            view.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor),
            view.rightAnchor.constraint(equalTo: hostingController.view.rightAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        /// Notify the hosting controller that it has been moved to the current view controller.
        hostingController.didMove(toParent: self)
    }
}
