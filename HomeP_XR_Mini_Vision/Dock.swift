//
//  Dock.swift
//  HomeP_XR_Mini_Vision
//
//  Created by Bummo Koo on 6/29/24.
//

import SwiftUI

struct Dock: View {
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: Date())
    }
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter.string(from: Date())
    }
    
    @State private var batteryLevel: Float = 0.0
    
    private func batteryImageName(for level: Float) -> String {
        switch level {
        case 0.75...1.0:
            return "battery.100percent"
        case 0.5..<0.75:
            return "battery.75percent"
        case 0.25..<0.5:
            return "battery.50percent"
        case 0.1..<0.25:
            return "battery.25percent"
        default:
            return "battery.0percent"
        }
    }
    
    var body: some View {
        HStack(spacing: 36) {
            HStack {
                Text("\(formattedDate)   \(formattedTime)")
                    .font(.headline)
            }
            .padding()
            .glassBackgroundEffect()
            HStack {
                Image(systemName: batteryImageName(for: batteryLevel))
                Text("\(Int(batteryLevel * 100))%")
            }
            .padding()
            .glassBackgroundEffect()
        }
        .onAppear {
            UIDevice.current.isBatteryMonitoringEnabled = true
            batteryLevel = UIDevice.current.batteryLevel
        }
        .onDisappear {
            UIDevice.current.isBatteryMonitoringEnabled = false
        }
    }
}

#Preview {
    Dock()
}
