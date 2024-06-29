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
    private let boxWidth: Float = 2
    private let boxHeight: Float = 0.015
    private let boxDepth: Float = 1

    var body: some View {
        RealityView { content, attachments in
            let anchor = AnchorEntity(.plane(.horizontal,
                                             classification: .table,
                                             minimumBounds: [0.3, 0.3]))
            content.add(anchor)
            
            let smallestDimension = min(boxWidth, boxHeight, boxDepth)
            let cornerRadius: Float = smallestDimension / 2
            
            let planeMesh = MeshResource.generateBox(width: boxWidth, height: boxHeight, depth: boxDepth, cornerRadius: cornerRadius)
            let planeMaterial = SimpleMaterial(color: .systemGray6, roughness: 0.8, isMetallic: false)
            let planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
            planeEntity.position = [0, 0, 0]
            
            anchor.addChild(planeEntity)
            
            if let attachment = attachments.entity(for: "clock") {
                attachment.position = [0, 0, 0.52]
                planeEntity.addChild(attachment)
            }
            
            if let map = attachments.entity(for: "map") {
                map.position = [0, 0, 0.3]
                planeEntity.addChild(map)
            }
            
            if let photoAlbum = attachments.entity(for: "photoAlbum") {
                photoAlbum.position = [0.6, 0.3, -0.4]
                planeEntity.addChild(photoAlbum)
            }
            
            if let calendarEvents = attachments.entity(for: "calendarEvents") {
                calendarEvents.position = [-0.9, 0.45, -0.15]
                planeEntity.addChild(calendarEvents)
            }
            
            if let reminder = attachments.entity(for: "reminder") {
                reminder.position = [-0.6, 0.45, -0.25]
                planeEntity.addChild(reminder)
            }
            
            if let car = try? await Entity(named: "model_s") {
                car.position = [-0.65, 0.015, 0.3]
//                let rotationAngle: Float = .pi / 4  // 45 degrees in radians
//                car.transform.rotation = simd_quatf(angle: rotationAngle, axis: [1, 0, 0])
                planeEntity.addChild(car)
            }
            
            if let attachment = attachments.entity(for: "carinfo") {
                attachment.position = [-0.85, 0.035, 0.4]
                planeEntity.addChild(attachment)
            }
            
            if let room = try? await Entity(named: "Room") {
                room.position = [0.65, 0.015, 0.3]
                room.scale = [0.03, 0.03, 0.03]
//                let rotationAngle: Float = .pi / 2  // 90 degrees in radians
//                room.transform.rotation = simd_quatf(angle: rotationAngle, axis: [0, 1, 0])  // Y-axis rotation
                planeEntity.addChild(room)
            }
        } update: { content, attachments in
            // Update the RealityKit content when SwiftUI state changes
        } placeholder: {
            Text("Loading")
        } attachments: {
            Attachment(id: "photoAlbum") {
                ImagePickerView(viewModel: ImagePickerViewModel())
                    .background(.clear)
                    .frame(maxWidth: 910, maxHeight: 800)
            }
            
            Attachment(id: "calendarEvents") {
                CalendarEventListView()
                    .frame(maxWidth: 320, maxHeight: 720)
            }
            
            Attachment(id: "reminder") {
                ReminderListView()
                    .frame(maxWidth: 320, maxHeight: 720)
            }
            
            Attachment(id: "clock") {
                Dock()
            }
            
            Attachment(id: "carinfo") {
                CarInfo()
            }
            
            Attachment(id: "map") {
                MapView()
            }
        }
    }
}

#Preview {
    ImmersiveView()
}
