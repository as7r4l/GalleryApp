import SwiftUI

struct PhotoItemView: View {
    let photo: UnsplashPhoto
    
    var body: some View {
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
    }
}
