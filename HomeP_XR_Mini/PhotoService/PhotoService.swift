//
//  PhotoService.swift
//  HomeP_XR_Mini
//
//  Created by Seo Jae Hoon on 6/29/24.
//

import Photos
import SwiftUI

final class PhotoService: NSObject {
    
    //MARK: - Private Property
    static private let sortDescriptors = [
        NSSortDescriptor(key: "creationDate", ascending: false),
        NSSortDescriptor(key: "modificationDate", ascending: false)
    ]
    
    static private let predicate: NSPredicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
    
    private let imageManager: PHCachingImageManager = {
        let manager = PHCachingImageManager()
        manager.allowsCachingHighQualityImages = true
        return manager
    }()
    
    //MARK: - Public Property
    static let shared = PhotoService()
    weak var delegate: PHPhotoLibraryChangeObserver?
    //MARK: - Initializers
    override private init() {
        super.init()
        
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func getAlbums(completion: @escaping ([AlbumInfo]) -> Void) {
        var allAlbums = [AlbumInfo]()
        
        // PHFetchOptions: predicate를 이용하여 sorting, mediaType 등을 쿼리하는데 사용
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = PhotoService.predicate
        fetchOptions.sortDescriptors = PhotoService.sortDescriptors
        fetchOptions.includeHiddenAssets = false
        DispatchQueue.global(qos: .userInteractive).async {

            let smartAlbums = PHAssetCollection.fetchAssetCollections(
                with: .smartAlbum,
                subtype: .any,
                options: PHFetchOptions()
            )
            guard 0 < smartAlbums.count else { return }
            smartAlbums.enumerateObjects { smartAlbum, index, pointer in
                guard index <= smartAlbums.count - 1 else {
                    pointer.pointee = true
                    return
                }
                if smartAlbum.estimatedAssetCount == NSNotFound {
                    let fetchOptions = PHFetchOptions()
                    fetchOptions.predicate = PhotoService.predicate
                    fetchOptions.sortDescriptors = PhotoService.sortDescriptors
                    let smartAlbums = PHAsset.fetchAssets(in: smartAlbum,
                                                          options: fetchOptions)
                    if let firstAsset = smartAlbums.firstObject {
                        self.fetchImage(asset: firstAsset,
                                        size: .init(width: 360, height: 360),
                                        contentMode: .aspectFill) { thumbnail in
                            allAlbums.append(
                                .init(
                                    id: smartAlbum.localIdentifier,
                                    name: smartAlbum.localizedTitle ?? "비어있는 타이틀",
                                    count: smartAlbums.count,
                                    album: smartAlbums,
                                    thumbnail: thumbnail
                                )
                            )
                        }
                    }
                    
                }
            }
            completion(allAlbums)
        }
       
    }
    
    func fetchImages(album: PHFetchResult<PHAsset>,
                     size: CGSize,
                     indexSet: IndexSet,
                     completion: @escaping ([ImageAsset]) -> Void) {
        guard 0 < album.count else { return }
        var imageAsset = [ImageAsset]()
        DispatchQueue.global(qos: .userInteractive).async {
            album.enumerateObjects(at: indexSet) { asset, index, stopPointer in
                guard index <= album.count - 1 else {
                    stopPointer.pointee = true
                    return
                }
                self.fetchImage(asset: asset,
                                size: size,
                                contentMode: .aspectFill) { image in
                    let asset = ImageAsset(asset: asset, image: image)
                    imageAsset.append(asset)
                }
            }
            
            completion(imageAsset)
        }
        
    }
    
    private func fetchImage(
        asset: PHAsset,
        size: CGSize,
        contentMode: PHImageContentMode,
        completion: @escaping (UIImage) -> Void
    ) {
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true // for icloud
        option.isSynchronous = true
        option.resizeMode = .exact
        
        self.imageManager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: contentMode,
            options: option
        ) { image, _ in
            guard let resizedImage = image else { return }
            completion(resizedImage)
        }
    }
}

extension PhotoService: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.delegate?.photoLibraryDidChange(changeInstance)
    }
}
