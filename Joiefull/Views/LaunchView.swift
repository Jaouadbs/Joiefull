//
//  LaunchView.swift
//  Joiefull
//
//  Created by Jaouad on 27/04/2026.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        ZStack {
            Color.joieSplash
                .ignoresSafeArea()
                .accessibilityHidden(true)

            Image("Transparentlogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
        }
        .accessibilityLabel("Joiefull, chargement en cours")
        .accessibilityElement(children: .ignore)
    }
}

#Preview { LaunchView() }
