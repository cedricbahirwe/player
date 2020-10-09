//
//  ListView.swift
//  CPlayer
//
//  Created by Cedric Bahirwe on 10/2/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct ListView: View {
    var dismiss: (() -> Void)?
    var present: (() -> Void)?
    @State var showSong = false
    @State private var songs = Bundle.main.decode(Album.self, from: "songs.json")
    var body: some View {
        List(self.songs.tracks, id: \.index) { track in
            ProfileAvatar(track: track, author: self.songs.author)
                .onTapGesture {
                    self.present?()
            }
            .sheet(isPresented: self.$showSong) {
                MainVC()
            }
        }
    }
}

@available(iOS 13.0.0, *)
struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

@available(iOS 13.0.0, *)
struct ProfileAvatar: View {
    var track: Track
    var author: String = "Lefa"
    
    
    var body: some View {
        HStack {
            Image("vinyl")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(3.5)
                .overlay(
                    Circle()
                        .strokeBorder(LinearGradient(gradient: Gradient(colors: [.blue, .purple, .green, .black]), startPoint: .bottomLeading, endPoint: .trailing), lineWidth: 1)
            )
            
            VStack(alignment: .leading, spacing: 0) {
                Text(track.title)
                    .bold()
                    .font(.system(size: 18))
                Text(self.author).foregroundColor(.gray)
            }
            Spacer()
        }
    }
}

struct MainVC: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}
