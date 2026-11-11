import SwiftUI
import CoreData

struct ContentView: View {
    // Подключаем нашу ViewModel
    @StateObject private var viewModel = GalleryViewModel()
    
    @FetchRequest(entity: FavoritePhotoEntity.entity(), sortDescriptors: []) var favorites: FetchedResults<FavoritePhotoEntity>
    
    // Настраиваем сетку: 2 одинаковые колонки
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                // Ленивая сетка (создает ячейки только когда они появляются на экране)
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.photos, id: \.id) { photo in
                        let isFavorite = favorites.contains(where: { $0.id == photo.id })
                        
                        NavigationLink(destination: PhotoDetailView(viewModel: viewModel, selectedPhotoId: photo.id)) {
                            
                            PhotoItemView(photo: photo, isFavorite: isFavorite)
                                .onAppear {
                                    // Пагинация: если долистали до последней картинки — грузим следующую страницу
                                    if photo.id == viewModel.photos.last?.id {
                                        Task {
                                            await viewModel.loadNextPage()
                                        }
                                    }
                                }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
                
                // Индикатор загрузки внизу
                if viewModel.isLoading {
                    ProgressView("Загрузка...")
                        .padding()
                }
            }
            .navigationTitle("Unsplash Gallery")
            // Выполняется один раз при запуске экрана
            .task {
                if viewModel.photos.isEmpty {
                    await viewModel.loadNextPage()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
