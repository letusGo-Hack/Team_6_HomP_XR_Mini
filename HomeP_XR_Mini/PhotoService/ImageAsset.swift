//
//  ImageAsset.swift
//  HomeP_XR_Mini
//
//  Created by Seo Jae Hoon on 6/29/24.
//

import SwiftUI
import Photos

public struct ImageAsset: Identifiable, Equatable, Hashable {
    public var id: String
    
    public var asset: PHAsset
    public var image: UIImage
    public var assetIndex: Int
    
    public init(id: String = UUID().uuidString,
                asset: PHAsset,
                image: UIImage,
                assetIndex: Int = -1) {
        self.id = id
        self.asset = asset
        self.image = image
        self.assetIndex = assetIndex
    }
}
