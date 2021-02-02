//
//  ContentView.swift
//  CPlayer
//
//  Created by Cédric Bahirwe on 22/01/2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewManager = ViewState()
    
    @State private var badgeNumber: Int = 3
    private var badgePosition: CGFloat = 2
    private var tabsCount: CGFloat = 2
    
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                // TabView
                TabView(selection: $viewManager.selectedTab) {
                    SongsList(manager: viewManager)
                        .tabItem {
                            Image(systemName: "music.note.list")
                            Text("Songs")
                            
                        }.tag(1)
                    SongView(manager: viewManager)
                        .tabItem {
                            Image(systemName: "play.fill")
                            Text("Playing")
                            
                        }.tag(2)
                }
                
                // Badge View
                ZStack {
                    Circle()
                        .foregroundColor(.red)
                    
                    Text("\(badgeNumber)")
                        .foregroundColor(.white)
                        .font(Font.system(size: 12))
                }
                .frame(width: 20, height: 20)
                .offset(x: ( ( 2 * badgePosition) - 1 ) * ( geometry.size.width / ( 2 * tabsCount ) ), y: -30)
                .opacity(badgeNumber == 0 ? 0 : 1)
            }
        }
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
            viewManager.player?.delegate = viewManager
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


