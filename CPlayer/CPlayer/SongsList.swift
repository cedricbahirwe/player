//
//  SongsList.swift
//  CPlayer
//
//  Created by Cédric Bahirwe on 22/01/2021.
//

import SwiftUI

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}

struct SongsList: View {
    @ObservedObject var manager: ViewState
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                HStack {
                    Text("Songs")
                        .font(.system(size: 35, weight: .bold))
                    Spacer()
                    Image("lefa")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .shadow(color: .offWhite, radius: 0.5)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                List(manager.songs.tracks, id: \.index) { track in
                    SongRow(track: track, author: manager.songs.author)
                        .overlay(
                            Group {
                            if track.title == manager.selectedTrack?.title {
                                GIFView(gifName: "equal")
                                    .frame(width: 60, height: 50)
                                }
                            }
                            , alignment: .bottomTrailing
                        )
                        .onTapGesture {
                            print("Selected Track")
                            manager.setSongFor(track)
                            manager.selectedtab = 2
                        }
                }
                .listStyle(PlainListStyle())
                
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        
    }
}

struct SongsList_Previews: PreviewProvider {
    static var previews: some View {
        SongsList(manager: ViewState())
    }
}
