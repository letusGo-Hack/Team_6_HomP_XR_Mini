//
//  ImagePickerViewModel.swift
//  HomeP_XR_Mini
//
//  Created by Seo Jae Hoon on 6/29/24.
//

import Combine
import Foundation
import UIKit
import Photos

public final class ImagePickerViewModel: ObservableObject {
    //MARK: - Dependency
    private let selectImageCountLimit: Int = 5
    private let repository: ImagePickerRepository
    private let imageSize: CGSize = .init(width: 270, height: 270)
    private let imagesPerPage: Int = 50
       
    var selectedAlbumIndex: Int {
        didSet {
            let endIndex: Int = self.albumList[selectedAlbumIndex].count > 20
            ? self.imagesPerPage
            : self.albumList[selectedAlbumIndex].count
            self.indexSet = IndexSet(integersIn: 0..<endIndex)
            self.imageList.removeAll()
            self.currentPage = 0
            self.fetchImages()
        }
    }
    
    
    //MARK: - Property
    @Published var albumList: [AlbumInfo] = []
    
    @Published var imageList: [ImageAsset] = []
    @Published var selectedImages: [ImageAsset] = []
        
    //Pagination
    private lazy var indexSet: IndexSet = .init(integersIn: 0..<imagesPerPage)
    private var currentPage: Int = 0
        
    private var cancellables: Set<AnyCancellable> = .init()
    
    var isLast: Bool {
        return self.imageList.count == self.albumList[self.selectedAlbumIndex].count
    }
    
    public init() {
        self.selectedAlbumIndex = 0
        self.repository = ImagePickerRepository()
        bind()
        fetchAlbums()
    }

    //MARK: - Pagination
    func fetchMoreImage(index: Int) {
        self.currentPage += 1
        let startIndex = currentPage * imagesPerPage
        let endIndex = min(startIndex + imagesPerPage, self.albumList[self.selectedAlbumIndex].count)
        guard endIndex > startIndex else { return }
        indexSet = IndexSet(integersIn: startIndex..<endIndex)
        fetchImages()
    }
    //MARK: - Image 선택시
    func imageSelected(imageAsset: ImageAsset) {
        var currentValue = selectedImages
        if let index = currentValue.firstIndex(where: { $0.id == imageAsset.id }) {
            //MARK: - Remove & Update Index
            currentValue.remove(at: index)
            currentValue.enumerated().forEach { (index, item) in
                currentValue[index].assetIndex = index
            }
            selectedImages = currentValue
        } else {
            //MARK: - Add New
            //MARK: Limit 5 Pictures
            guard currentValue.count != selectImageCountLimit else { return }
            //MARK: Append
            var newAsset = imageAsset
            newAsset.assetIndex = currentValue.count
            currentValue.append(newAsset)
            selectedImages = currentValue
        }
    }
    
}

extension ImagePickerViewModel {
    private func bind() {
        repository.$albumList
            .sink { [weak self] albums in
                guard let self else { return }
                self.albumList = albums
                self.fetchImages()
            }
            .store(in: &cancellables)
        
        repository.$imageList
            .sink { [weak self] images in
                self?.imageList.append(contentsOf: images)
            }
            .store(in: &cancellables)
    }
    
    private func fetchAlbums() {
        repository.fetchAlbums()
    }
    
    private func fetchImages() {
        let indexSet = self.albumList[self.selectedAlbumIndex].count > self.imagesPerPage
        ? self.indexSet
        : IndexSet(integersIn: 0..<self.albumList[self.selectedAlbumIndex].count)
        repository.fetchImages(album: albumList[self.selectedAlbumIndex].album,
                               size: imageSize,
                               indexSet: indexSet)
    }
}