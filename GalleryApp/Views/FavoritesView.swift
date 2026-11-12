import SwiftUI
import CoreData

struct FavoritesView: View {
    @FetchRequest(
        entity: FavoritePhotoEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoritePhotoEntity.savedDate, ascending: false)]
    ) var favoritePhotos: FetchedResults<FavoritePhotoEntity>
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                if favoritePhotos.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Нет избранных фото")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(favoritePhotos, id: \.id) { entity in
                                NavigationLink(destination: FavoriteDetailView(favoritePhotos: favoritePhotos, selectedPhotoId: entity.id ?? "")) {
                                    ZStack(alignment: .bottomTrailing) {
                                        AsyncImage(url: URL(string: entity.urlString ?? "")) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(minWidth: 0, maxWidth: .infinity)
                                                .frame(height: 200)
                                                .cornerRadius(12)
                                                .clipped()
                                        } placeholder: {
                                            Color.gray.opacity(0.3)
                                                .frame(minWidth: 0, maxWidth: .infinity)
                                                .frame(height: 200)
                                                .cornerRadius(12)
                                        }
                                        
                                        Image(systemName: "heart.fill")
                                            .foregroundStyle(Color.red)
                                            .padding(8)
                                            .background(Circle().fill(.ultraThinMaterial))
                                            .padding(8)
                                    }
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            if let id = entity.id {
                                                CoreDataManager.shared.deletePhoto(withId: id)
                                            }
                                        } label: {
                                            Label("Удалить из избранного", systemImage: "trash")
                                        }
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Избранное")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
