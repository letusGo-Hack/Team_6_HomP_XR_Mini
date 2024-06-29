//
//  AlbumInfo.swift
//  HomeP_XR_Mini
//
//  Created by Seo Jae Hoon on 6/29/24.
//

import SwiftUI
import Photos

public struct AlbumInfo: Identifiable {
    public let id: String?
    public var name: String
    public let count: Int
    public let album: PHFetchResult<PHAsset>
    public let thumbnail: UIImage
    
    public init(id: String?,
                name: String,
                count: Int,
                album: PHFetchResult<PHAsset>,
                thumbnail: UIImage) {
        self.id = id
        self.name = name
        self.count = count
        self.album = album
        self.thumbnail = thumbnail
    }
}
