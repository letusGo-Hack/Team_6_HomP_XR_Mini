//
//  ImmersiveView.swift
//  HomeP_XR_Mini_Vision
//
//  Created by Bummo Koo on 6/29/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ImmersiveView: View {
    @State private var isPhotoAlbumPresented = false
    
    var body: some View {
        RealityView { content, attachments in
            let anchor = AnchorEntity(.plane(.horizontal,
                                             classification: .table,
                                             minimumBounds: [0.3, 0.3]))
            content.add(anchor)
            
            let planeMesh = MeshResource.generateBox(width: 2, height: 0.015, depth: 1)
            //                let planeMesh = MeshResource.generatePlane(width: 2, depth: 1)
            let redMaterial = SimpleMaterial(color: .systemGreen, roughness: 0.8, isMetallic: false)
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
            
            if let calendarEvents = attachments.entity(for: "calendarEvents") {
                calendarEvents.position = [0, 1.0, 0]
                planeEntity.addChild(calendarEvents)
            }
            
            if let swift = try? await Entity(named: "Swift") {
                swift.position = [0, 0, 0]
                planeEntity.addChild(swift)
            }
            
            if let car = try? await Entity(named: "model_s") {
                car.position = [-0.6, 0, 0.3]
                planeEntity.addChild(car)
            }
            
            if let room = try? await Entity(named: "Room") {
                room.position = [0.5, 0.02, 0.3]
                room.scale = [0.025, 0.025, 0.025]
                planeEntity.addChild(room)
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
                .frame(maxWidth: 320, maxHeight: 480)
            }
            
            Attachment(id: "photoAlbum") {
                //                    ImagePickerView(viewModel: ImagePickerViewModel())
                Text("Image")
            }
            
            Attachment(id: "calendarEvents") {
                CalendarEventListView()
            }
        }
    }
}
