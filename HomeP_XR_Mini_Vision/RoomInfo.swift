//
//  RoomInfo.swift
//  HomeP_XR_Mini_Vision
//
//  Created by Bummo Koo on 6/29/24.
//

import SwiftUI

struct RoomInfo: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Conference Room")
                .font(.headline)
            HStack {
                HStack {
                    Image(systemName: "thermometer.variable")
                    Text("24~26℃")
                }
                HStack {
                    Image(systemName: "humidity")
                    Text("60~61%")
                }
            }
        }
        .padding()
        .glassBackgroundEffect()
    }
}

#Preview {
    RoomInfo()
}
