//
//  WelcomeView.swift
//  HomeP_XR_Mini_Vision
//
//  Created by Bummo Koo on 6/29/24.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    
    var body: some View {
        VStack {
            Text("Welcome to Vision Desk !")
                .font(.largeTitle)
//            Button("Start") {
//                showImmersiveSpace = true
//            }
            Toggle("Show My Workspace", isOn: $showImmersiveSpace)
                .font(.headline)
                .frame(width: 400)
                .padding(20)
                .glassBackgroundEffect()
            .onChange(of: showImmersiveSpace) { _, newValue in
                Task {
                    if newValue {
                        switch await openImmersiveSpace(id: "ImmersiveSpace") {
                        case .opened:
                            immersiveSpaceIsShown = true
                        case .error, .userCancelled:
                            fallthrough
                        @unknown default:
                            immersiveSpaceIsShown = false
                            showImmersiveSpace = false
                        }
                    } else if immersiveSpaceIsShown {
                        await dismissImmersiveSpace()
                        immersiveSpaceIsShown = false
                    }
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
