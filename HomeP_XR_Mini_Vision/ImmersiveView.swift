//
//  ImmersiveView.swift
//  HomeP_XR_Mini_Vision
//
//  Created by Bummo Koo on 6/29/24.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    var body: some View {
        VStack {
            RealityView { content in
                let anchor = AnchorEntity(.plane(.horizontal,
                                                 classification: .table,
                                                 minimumBounds: [0.3, 0.3]))
                content.add(anchor)
                
                let planeMesh = MeshResource.generatePlane(width: 2, depth: 1)
                let redMaterial = SimpleMaterial(color: .red, roughness: 0.8, isMetallic: false)
                let planeEntity = ModelEntity(mesh: planeMesh, materials: [redMaterial])
                planeEntity.position = [0, 0, 0]
                
                anchor.addChild(planeEntity)
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
