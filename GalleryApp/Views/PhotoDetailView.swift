import SwiftUI
import CoreData

struct PhotoDetailView: View {
    @ObservedObject var viewModel: GalleryViewModel
    @State var selectedPhotoId: String
    
    @FetchRequest(entity: FavoritePhotoEntity.entity(), sortDescriptors: []) var favorites: FetchedResults<FavoritePhotoEntity>
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedPhotoId) {
                ForEach(viewModel.photos, id: \.id) { photo in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            AsyncImage(url: URL(string: photo.urls.regular)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            } placeholder: {
                                ProgressView()
                                    .frame(maxWidth: .infinity, minHeight: 300)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(photo.description ?? photo.altDescription ?? "Без названия")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text("Автор: \(photo.user.name)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .tag(photo.id)
                    .onAppear {
                        if photo.id == viewModel.photos.last?.id {
                            Task {
                                await viewModel.loadNextPage()
                            }
                        }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    LazyHStack(spacing: 8) {
                        ForEach(viewModel.photos, id: \.id) { photo in
                            let isSelected = selectedPhotoId == photo.id
                            
                            AsyncImage(url: URL(string: photo.urls.thumb)) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame(width: isSelected ? 65 : 50, height: isSelected ? 65 : 50)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                            )
                            .onTapGesture {
                                withAnimation {
                                    selectedPhotoId = photo.id
                                }
                            }
                            .id(photo.id)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .onChange(of: selectedPhotoId) { _, newId in
                        withAnimation {
                            proxy.scrollTo(newId, anchor: .center)
                        }
                    }
                }
            }
            .frame(height: 80)
            .background(Color(UIColor.systemBackground).shadow(radius: 1))
        }
        .navigationTitle("Детали")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                let isFavorite = favorites.contains(where: { $0.id == selectedPhotoId })
                
                Button(action: {
                    if isFavorite {
                        CoreDataManager.shared.deletePhoto(withId: selectedPhotoId)
                    } else {
                        if let currentPhoto = viewModel.photos.first(where: { $0.id == selectedPhotoId }) {
                            CoreDataManager.shared.savePhoto(currentPhoto)
                        }
                    }
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .primary)
                }
            }
        }
    }
}
