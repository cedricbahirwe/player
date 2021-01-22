//
//  SongView.swift
//  CPlayer
//
//  Created by Cédric Bahirwe on 22/01/2021.
//

import SwiftUI


let size = UIScreen.main.bounds.size
struct SongView: View {
    @ObservedObject var manager: ViewState
    
    var body: some View {
        ZStack(alignment: .top)  {
            
            HStack {
                HStack {
                    Image("tree")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                        .offset(y: -25)
                        .rotationEffect(.degrees(-45))
                    Spacer()
                    Image("happy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
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
                        .overlay(
                            Image("famous")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        )
                        .clipped()
                        .cornerRadius(20)

                    
                    VStack(spacing: 50) {
                        Button(action: manager.didPressPrevious) {
                            Image("previousbutton")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        
                        Button(action: manager.didPressPlay) {
                            Image(manager.isPlaying ? "pause.button" : "play.button")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                        
                        Button(action: manager.didPressNext) {
                            Image("nextbutton")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    }
                    .frame(width: 85)
                }
                .frame(maxWidth: size.width)
                
                
                
                VStack {
                    
                    Button(action: {
                        withAnimation {
                            manager.isLiked.toggle()
                        }
                    }, label: {
                        Image(manager.isLiked ? "liked" : "like")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                            .padding()
                            .overlay(
                                Circle().strokeBorder(Color.black)
                            )
                    })
                    .padding(.bottom, 10)
                    Slider(value: .constant(2.0), in: 0.0...4.0, step: 0.1)
                        .accentColor(.green)
                    
                    HStack {
                        Text("2.37")
                        Spacer()
                        Text("3.40")
                    }
                }
                .padding(.bottom, 10)
                .padding(.top, 20)
                .background(
                    Image("walk")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size.width-100, height: size.height*0.25)
                        .opacity(0.6)
                        .clipped()
                        .zIndex(-3)
                )
                
                HStack(spacing: 10) {
                    Button(action: {}, label: {
                        Text("Rock")
                            .shadow(color: Color(.darkGray), radius: 0, x: -1, y: -0.5)
                            .frame(height: 32)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .clipShape(Capsule())
                    })
                    Button(action: {}, label: {
                        Text("Jazz")
                            .shadow(color: Color(.darkGray), radius: 0, x: -1, y: -0.5)
                            .frame(height: 32)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .clipShape(Capsule())
                    })
                    Button(action: {}, label: {
                        Text("Pop")
                            .shadow(color: Color(.darkGray), radius: 0, x: -1, y: -0.5)
                            .frame(height: 32)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .clipShape(Capsule())
                    })
                    Button(action: {}, label: {
                        Text("EDM")
                            .shadow(color: Color(.darkGray), radius: 0, x: -1, y: -0.5)
                            .frame(height: 32)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .clipShape(Capsule())
                        
                    })
                    
                }
                .font(.callout)
                .foregroundColor(.white)
            }
            .padding()
            
            
            
        }
    }
    
}



struct SongView_Previews: PreviewProvider {
    static var previews: some View {
        SongView(manager: ViewState())
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
