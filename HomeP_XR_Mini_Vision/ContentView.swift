//
//  ContentView.swift
//  HomeP_XR_Mini_Vision
//
//  Created by Bummo Koo on 6/29/24.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    var body: some View {
        VStack {
            RealityView { content in
                
                let planeMesh = MeshResource.generatePlane(width: 2, depth: 1)
                let redMaterial = SimpleMaterial(color: .red, roughness: 0.8, isMetallic: false)
                let planeEntity = ModelEntity(mesh: planeMesh, materials: [redMaterial])
                planeEntity.position = [0, 0, 0]
                content.add(planeEntity)
            } update: { content in
                // Update the RealityKit content when SwiftUI state changes
            }
            VStack {
                Text("Hello, visionOS!")
            }
            .padding()
            .glassBackgroundEffect()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
