//
//  TestingView.swift
//  CPlayer
//
//  Created by Cédric Bahirwe on 22/01/2021.
//

import SwiftUI

struct TestingView: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            GIFView(gifName: "equal")
                .frame(width: 70, height: 50)
                .background(Color.red)
            
        }
    }
}

struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}
