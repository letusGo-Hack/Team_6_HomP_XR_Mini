//
//  ImagePickerView.swift
//  HomeP_XR_Mini
//
//  Created by Seo Jae Hoon on 6/29/24.
//

import SwiftUI

public struct ImagePickerView: View {
    //MARK: - Private property
    
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)
    
    @StateObject private var viewModel: ImagePickerViewModel
    @State private var showAlbumView: Bool = false
            
    //MARK: - Public Property
    public init(viewModel: ImagePickerViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            thumbnailScrollView
        }//VStack
        .ignoresSafeArea(edges: .all)
        .glassBackgroundEffect()
    }
}
//MARK: - View
extension ImagePickerView {
    //MARK: - Thumbnail
    @ViewBuilder
    private var thumbnailScrollView: some View {
        ScrollView(content: {
            LazyVGrid(columns: columns, spacing: 10, content: {
                ForEach($viewModel.imageList, id: \.id) { $photo in
                    //썸네일 Cell
                    thumbnailView(imageAsset: photo)
                        .onAppear {
                            guard let index = viewModel.imageList.firstIndex(where: { $0.id == photo.id }) else { return }
                            if self.viewModel.isLast == false && index == self.viewModel.imageList.count - 20 {
                                self.viewModel.fetchMoreImage(index: index)
                            }
                        }
                }
            })
        })
        .padding(.horizontal, 10)
        .frame(maxHeight: .infinity)
    }
    @ViewBuilder
    private func thumbnailView(imageAsset: ImageAsset) -> some View {
        let viewSize: CGFloat = 300
        
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                Image(uiImage: imageAsset.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .contentShape(Rectangle())
                    .overlay {
                        Rectangle()
                            .stroke(Color.clear, lineWidth: 0)
                    }
            }
        }
        .frame(width: viewSize, height: viewSize, alignment: .center)
    }

}
