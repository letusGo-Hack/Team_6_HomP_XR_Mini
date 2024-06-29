//
//  ImmersiveView.swift
//  HomeP_XR_Mini_Vision
//
//  Created by Bummo Koo on 6/29/24.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @State private var isPhotoAlbumPresented = false
    
    var body: some View {
        VStack {
            RealityView { content, attachments in
                let anchor = AnchorEntity(.plane(.horizontal,
                                                 classification: .table,
                                                 minimumBounds: [0.3, 0.3]))
                content.add(anchor)
                
                let planeMesh = MeshResource.generatePlane(width: 2, depth: 1)
                let redMaterial = SimpleMaterial(color: .red, roughness: 0.8, isMetallic: false)
                let planeEntity = ModelEntity(mesh: planeMesh, materials: [redMaterial])
                planeEntity.position = [0, 0, 0]
                
                anchor.addChild(planeEntity)
                
                if let sample = attachments.entity(for: "sample") {
                    sample.position = [0, 0.2, 0]
                    planeEntity.addChild(sample)
                }
                
                if let photoAlbum = attachments.entity(for: "photoAlbum") {
                    photoAlbum.position = [0, 0.8, 0]
                    planeEntity.addChild(photoAlbum)
                }
                
                if let swift = try? await Entity(named: "Swift") {
                    swift.position = [0, 0, 0]
                    planeEntity.addChild(swift)
                }
                
                if let swift = try? await Entity(named: "model_s") {
                    swift.position = [0.2, 0, 0.2]
                    planeEntity.addChild(swift)
                }
            } update: { content, attachments in
                // Update the RealityKit content when SwiftUI state changes
            } placeholder: {
                Text("Loading")
            } attachments: {
                Attachment(id: "sample") {
                    List {
                        ForEach(1..<10) { index in
                            Text("Item \(index)")
                        }
                    }
                    .padding()
                    .glassBackgroundEffect()
                }
                
                Attachment(id: "photoAlbum") {
                    Button("Album", systemImage: "photo.badge.plus.fill", role: .none) {
                        isPhotoAlbumPresented.toggle()
                    }
                    .sheet(isPresented: $isPhotoAlbumPresented) {
                        ImagePickerView(viewModel: ImagePickerViewModel())
                    }
                        
                }
            }
        }
    }
}
