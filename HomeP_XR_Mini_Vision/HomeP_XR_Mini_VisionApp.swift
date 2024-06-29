//
//  HomeP_XR_Mini_VisionApp.swift
//  HomeP_XR_Mini_Vision
//
//  Created by Bummo Koo on 6/29/24.
//

import SwiftUI

@main
struct HomeP_XR_Mini_VisionApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
        .windowStyle(.automatic)
        
        WindowGroup {
            ContentView()
        }
        .windowStyle(.volumetric)
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
