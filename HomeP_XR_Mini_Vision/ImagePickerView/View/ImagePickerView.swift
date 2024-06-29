//
//  ImagePickerView.swift
//  HomeP_XR_Mini
//
//  Created by Seo Jae Hoon on 6/29/24.
//

import SwiftUI

public struct ImagePickerView: View {
    //MARK: - Private property
    @Environment(\.colorScheme) private var colorScheme
    
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)
    
    @StateObject private var viewModel: ImagePickerViewModel
    @State private var showAlbumView: Bool = false
            
    //MARK: - Public Property
    public init(viewModel: ImagePickerViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            topNavigation
            ZStack {
                thumbnailScrollView
                if showAlbumView {
                    albumScrollView
                }
            }//ZStack
        }//VStack
        .ignoresSafeArea(edges: .all)
        .glassBackgroundEffect()
    }
}
//MARK: - View
extension ImagePickerView {
    //MARK: - Navigation
    @ViewBuilder
    private var topNavigation: some View {
        HStack {
            albumNameButton
            Spacer()
            if $viewModel.selectedImages.isEmpty == false {
                selectImageButton
            }
        } //HStack
        .frame(width: .infinity, height: 66)
//        .background(backGroundColor)
        .zIndex(1)
    }

    // 앨범 선택 버튼
    @ViewBuilder
    private var albumNameButton: some View {
        HStack {
            let albumName: String = viewModel.albumList.isEmpty
            ? ""
            : $viewModel.albumList.wrappedValue[$viewModel.selectedAlbumIndex.wrappedValue].name
            Text(albumName)
                .font(.title3)
                .foregroundStyle(textColor)
                
            let angle: Double = self.showAlbumView ? -180 : 0
            arrowDownImage
                .rotationEffect(.degrees(angle))
        } //HStack
        .padding(.leading, 16)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                self.showAlbumView.toggle()
            }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 48))
    }
    // 이미지 선택 버튼
    @ViewBuilder
    private var selectImageButton: some View {
        Button {
            
        } label: {
            HStack(spacing: 0) {
                Text("\($viewModel.selectedImages.count)")
                    .font(.subheadline)
                    .foregroundStyle(.red)
                Text(" 선택")
                    .font(.subheadline)
                    .foregroundStyle(chooseTextColor)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 24))
    }
    //MARK: - Thumbnail
    @ViewBuilder
    private var thumbnailScrollView: some View {
        ScrollView(content: {
            LazyVGrid(columns: columns, spacing: 2, content: {
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
        .background(backGroundColor)
        .padding(.horizontal, 2)
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
                        if (self.viewModel.selectedImages.first(where: { $0.id == imageAsset.id }) != nil) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.4))
                            
                            Rectangle()
                                .stroke(Color.gray, lineWidth: 8)
                        } else {
                            Rectangle()
                                .stroke(Color.clear, lineWidth: 0)
                        }
                    }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .fill(Color.black.opacity(0.1))
                    
                    Circle()
                        .fill(Color.white.opacity(0.4))
                    
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                    
                    if let index = self.viewModel.selectedImages.firstIndex(where: {
                        $0.id == imageAsset.id
                    }) {
                        Circle()
                            .stroke(Color.black, lineWidth: 2)
                        
                        Circle()
                            .fill(Color.black)
                        
                        Text("\((self.viewModel.selectedImages[index].assetIndex + 1))")
                            .font(.body)
                            .foregroundColor(.white)
                    }
                } //ZStack
                .frame(width: 28, height: 28)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(10)
            }
            .clipped()
            .onTapGesture {
                self.viewModel.imageSelected(imageAsset: imageAsset)
            } // ZStack
        }
        .frame(width: viewSize, height: viewSize, alignment: .center)
    }
    //MARK: - Album
    @ViewBuilder
    private var albumScrollView: some View {
        ScrollView {
            LazyVStack {
                ForEach($viewModel.albumList) { $album in
                    albumView(album: album)
                        .onTapGesture {
                            withAnimation {
                                if let index = viewModel.albumList.firstIndex(where: { $0.id == album.id }),
                                   self.viewModel.selectedAlbumIndex != index {
                                    self.viewModel.selectedAlbumIndex = index
                                }
                                self.showAlbumView = false
                            }
                        }
                }
            }
            .padding(.bottom, 40)
        }
        .background(backGroundColor)
        .frame(maxHeight: .infinity)
        .animation(.easeInOut(duration: 0.1), value: showAlbumView)
        .transition(.move(edge: .top))
        .zIndex(1)
    }
    
    @ViewBuilder
    private func albumView(album: AlbumInfo) -> some View {
        HStack(spacing: 16) {
            Image(uiImage: album.thumbnail)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 56, height: 56)
                .clipped()
            VStack(spacing: 4, content: {
                Text(album.name)
                    .font(.body)
                    .foregroundStyle(albumNameTextColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(album.count)")
                    .font(.body)
                    .foregroundStyle(albumCountTextColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
        }
        .frame(width: .infinity, height: 72)
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
    

}
//MARK: - Private Method
extension ImagePickerView {
    private func openSettingURL() {
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingURL) {
            UIApplication.shared.open(settingURL)
        }
    }
}

//MARK: - ColorSet
private extension ImagePickerView {
    var backGroundColor: Color {
        return self.colorScheme == .dark ? .black : .white
    }
    var textColor: Color {
        return self.colorScheme == .dark ? .white : .black
    }
    var chooseTextColor: Color {
        return self.colorScheme == .dark ? Color.gray : .white
    }
    var albumNameTextColor: Color {
        return self.colorScheme == .dark ? .white : .black
    }
    var albumCountTextColor: Color {
        return self.colorScheme == .dark ? .white : .black
    }
    
    var arrowDownImage: some View {
        return Image(systemName: "chevron.down")
//            .resizable()
//            .frame(width: 24, height: 24)
    }
}
