import SwiftUI
import CoreData

struct FavoriteDetailView: View {
    var favoritePhotos: FetchedResults<FavoritePhotoEntity>
    @State var selectedPhotoId: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedPhotoId) {
                ForEach(favoritePhotos, id: \.id) { entity in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            AsyncImage(url: URL(string: entity.urlString ?? "")) { image in
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
                                Text(entity.photoDescription ?? "Без названия")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text("Автор: \(entity.authorName ?? "Неизвестен")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .tag(entity.id ?? "")
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            

            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    LazyHStack(spacing: 8) {
                        ForEach(favoritePhotos, id: \.id) { entity in
                            let isSelected = selectedPhotoId == entity.id
                            
                            AsyncImage(url: URL(string: entity.urlString ?? "")) { image in
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
                                    selectedPhotoId = entity.id ?? ""
                                }
                            }
                            .id(entity.id ?? "")
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
        .navigationTitle("Избранное фото")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    deleteCurrentPhoto()
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    private func deleteCurrentPhoto() {
        let currentIds = favoritePhotos.compactMap { $0.id }
        guard let currentIndex = currentIds.firstIndex(of: selectedPhotoId) else { return }
        
        let idToDelete = selectedPhotoId
        
        if currentIds.count > 1 {
            if currentIndex + 1 < currentIds.count {
                selectedPhotoId = currentIds[currentIndex + 1]
            } else if currentIndex - 1 >= 0 {
                selectedPhotoId = currentIds[currentIndex - 1]
            }
            CoreDataManager.shared.deletePhoto(withId: idToDelete)
        } else {
            CoreDataManager.shared.deletePhoto(withId: idToDelete)
            dismiss()
        }
    }
}
