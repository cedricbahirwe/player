//
//  GifView.swift
//  CPlayer
//
//  Created by Cédric Bahirwe on 22/01/2021.
//

import SwiftUI

class GIFPlayerView: UIView {
    private let imageView = UIImageView()

    convenience init(gifName: String) {
        self.init()
        let gif = UIImage.gifImageWithName(gifName)
        imageView.image = gif
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
}

struct GIFView: UIViewRepresentable {
    var gifName: String
    
    func makeUIView(context: Context) -> UIView {
        return GIFPlayerView(gifName: gifName)
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<GIFView>) {
        
    }
}
