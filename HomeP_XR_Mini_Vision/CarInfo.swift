//
//  CarInfo.swift
//  HomeP_XR_Mini_Vision
//
//  Created by Bummo Koo on 6/29/24.
//

import SwiftUI

struct CarInfo: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Model S")
                .font(.headline)
            HStack {
                HStack {
                    Image(systemName: "battery.75percent")
                    Text(" 72%")
                }
                HStack {
                    Image(systemName: "gauge.with.dots.needle.bottom.50percent")
                    Text("71,631 km")
                }
            }
        }
        .padding()
        .glassBackgroundEffect()
    }
}

#Preview {
    CarInfo()
}
