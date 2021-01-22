//
//  SongsList.swift
//  CPlayer
//
//  Created by Cédric Bahirwe on 22/01/2021.
//

import SwiftUI

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
                }
                .padding(.horizontal)
                .padding(.top, 8)
                List(manager.songs.tracks, id: \.index) { track in
                    SongRow(track: track, author: manager.songs.author)
                        .overlay(
                            Group {
                            if track.title == manager.selectedTrack?.title {
                                GIFView(gifName: "equal")
                                    .frame(width: 50, height: 50)
                                }
                            }
                            , alignment: .bottomTrailing
                        )
                        .onTapGesture {
                            print("Selected Track")
                            manager.selectedTrack = track
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
