import SwiftUI

struct PhotoItemView: View {
    let photo: UnsplashPhoto
    let isFavorite: Bool
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            AsyncImage(url: URL(string: photo.urls.regular)) { image in
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
            
            if isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundStyle(Color.red)
                    .padding(8)
                    .background(Circle().fill(.ultraThinMaterial))
                    .padding(8)
            }
        }
        .contextMenu {
            Button(action: {
                if isFavorite {
                    CoreDataManager.shared.deletePhoto(withId: photo.id)
                } else {
                    CoreDataManager.shared.savePhoto(photo)
                }
            }) {
                if isFavorite {
                    Label("Удалить из избранного", systemImage: "heart.slash")
                } else {
                    Label("В избранное", systemImage: "heart")
                }
            }
        }
    }
}
