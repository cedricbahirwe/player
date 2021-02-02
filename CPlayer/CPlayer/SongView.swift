//
//  SongView.swift
//  CPlayer
//
//  Created by Cédric Bahirwe on 22/01/2021.
//

import SwiftUI
import Combine

let size = UIScreen.main.bounds.size
struct SongView: View {
    @ObservedObject var manager: ViewState
    
    @State private var currentTime: Double = 0.0
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .top)  {
            
            HStack {
                HStack {
                    Image("tree")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .offset(x: -20, y: -55)
                        .rotationEffect(.degrees(-45))
                    Spacer()
                    Image("happy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                        .clipShape(Circle())
                    
                }
            }
            .edgesIgnoringSafeArea(.top)
            
            
            VStack {
                VStack {
                    Text(manager.selectedTrack?.title ?? .defaultValue)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .shadow(color: Color.gray, radius: 0,  x: 0.3, y: 2)
                        
                        .lineLimit(1)
                    Text("by \(manager.songs.author)")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    
                    
                }
                
                
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(width: size.width-100)
                        .cornerRadius(30)
                        .overlay(
                            Image("famous")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        )
                        .clipped()
                        .cornerRadius(20)
                    
                    
                    VStack(spacing: 40) {
                        Button(action: manager.didPressPrevious) {
                            Image("previousbutton")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        
                        Button(action: manager.didPressPlay) {
                            Image(manager.isPlaying ? "pause.button" : "play.button")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                        
                        Button(action: manager.didPressNext) {
                            Image("nextbutton")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    }
                    .foregroundColor(Color(.label))
                    .frame(width: 85)
                }
                .frame(maxWidth: size.width)
                
                
                
                VStack {
                    
//                    Button(action: {
//                        withAnimation {
//                            manager.isLiked.toggle()
//                        }
//                    }, label: {
//                        Image(manager.isLiked ? "liked" : "like")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(.red)
//                            .padding()
//                            .overlay(
//                                Circle().strokeBorder(Color(.label))
//                            )
//                    })
//                    .padding(.bottom, 10)
//                    .hidden()
                    
                    Slider(value: $currentTime, in: 0...manager.length) { (changed) in
                        if changed {
                            print("Chaning")
//                            manager.pause()
                        } else {
                            manager.isPlaying = true
                            manager.player?.currentTime =  currentTime 
                        }
                    }
                    .accentColor(.green)
                    
                    HStack {
                        Text(String(format: "%.2f", currentTime))
                        Spacer()
                        Text(manager.songLength)
                    }
                }
                .padding(.bottom, 10)
                .padding(.top, 20)
                
                HStack(spacing: 10) {
                    Button(action: {}, label: {
                        Text("Rock")
                            .shadow(color: Color(.darkGray), radius: 0, x: -1, y: -0.5)
                            .frame(height: 32)
                            .frame(maxWidth: .infinity)
                            .background(Color(.label))
                            .clipShape(Capsule())
                    })
                    Button(action: {}, label: {
                        Text("Jazz")
                            .shadow(color: Color(.darkGray), radius: 0, x: -1, y: -0.5)
                            .frame(height: 32)
                            .frame(maxWidth: .infinity)
                            .background(Color(.label))
                            .clipShape(Capsule())
                    })
                    Button(action: {}, label: {
                        Text("Pop")
                            .shadow(color: Color(.darkGray), radius: 0, x: -1, y: -0.5)
                            .frame(height: 32)
                            .frame(maxWidth: .infinity)
                            .background(Color(.label))
                            .clipShape(Capsule())
                    })
                    Button(action: {}, label: {
                        Text("EDM")
                            .shadow(color: Color(.darkGray), radius: 0, x: -1, y: -0.5)
                            .frame(height: 32)
                            .frame(maxWidth: .infinity)
                            .background(Color(.label))
                            .clipShape(Capsule())
                        
                    })
                    
                }
                .font(.callout)
                .foregroundColor(Color(.systemBackground))
            }
            .padding()
            
            
            
        }
//        .onReceive(manager.timer, perform: { _ in
//            if manager.isPlaying {
//                currentTime = manager.player?.currentTime ?? 0.0
//            }
//        })
//        .onReceive(, perform: { _ in
//            value = manager.player?.currentTime ?? 0
//        })
    }
    
    
}



struct SongView_Previews: PreviewProvider {
    static var previews: some View {
        SongView(manager: ViewState())
        //            .environment(\.colorScheme, .dark)
    }
}



protocol Defaultable {
    static var defaultValue: Self { get }
}


extension String: Defaultable {
    static var defaultValue: String {
        "..."
    }
    
    
}


extension Binding {
    
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue )
            }
        )
    }
    
}


