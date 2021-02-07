//
//  HelperViews.swift
//  CPlayer
//
//  Created by Cédric Bahirwe on 02/02/2021.
//

import Foundation
import SwiftUI


struct PopView: ViewModifier {
    let action: (() -> ())?
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onEnded { _ in
                        withAnimation {
                           action?()
                        }
                }
        )
    }
}
