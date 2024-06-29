//
//  ImagePickerRepository.swift
//  HomeP_XR_Mini
//
//  Created by Seo Jae Hoon on 6/29/24.
//

import Combine
import Foundation
import Photos

final class ImagePickerRepository {
    
    private let photoService: PhotoService = .shared
    
    @Published var albumList: [AlbumInfo] = []
    @Published var imageList: [ImageAsset] = []
    @Published var isPaging: Bool = false
    var delegate: PHPhotoLibraryChangeObserver?
    
    init() {
        self.delegate = photoService.delegate
    }
    
    func fetchAlbums() {
        photoService.getAlbums { [weak self] albums in
            self?.albumList = albums
        }
    }
    
    public func fetchImages(album: PHFetchResult<PHAsset>, size: CGSize, indexSet: IndexSet) {
        photoService.fetchImages(album: album, size: size, indexSet: indexSet) { [weak self] images in
            let isPaging: Bool = !(indexSet.contains { $0 == 0 })
            self?.imageList = images
            self?.isPaging = isPaging
        }
    }
}
