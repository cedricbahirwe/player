//
//  SongRow.swift
//  CPlayer
//
//  Created by Cédric Bahirwe on 22/01/2021.
//

import SwiftUI

struct SongRow: View {
    var track: Track
    var author: String = "Lefa"
    
    
    var body: some View {
        HStack {
            Image("vinyl")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 56, height: 56)
                .background(Color.black)
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
