import Foundation
import Combine

@MainActor
final class GalleryViewModel: ObservableObject {
    @Published var photos: [UnsplashPhoto] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let networkService: NetworkServiceProtocol
    private var currentPage = 1
    
    init(networkService: NetworkServiceProtocol? = nil) {
        self.networkService = networkService ?? NetworkService()
    }
    
    func loadNextPage() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let newPhotos = try await networkService.fetchPhotos(page: currentPage)
            photos.append(contentsOf: newPhotos)
            currentPage += 1
        } catch {
            errorMessage = "Не удалось загрузить фото: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

