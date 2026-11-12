import Foundation
@testable import GalleryApp

final class MockNetworkService: NetworkServiceProtocol {
    var shouldReturnError = false
    var mockPhotos: [UnsplashPhoto] = []

    func fetchPhotos(page: Int) async throws -> [UnsplashPhoto] {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        return mockPhotos
    }
}
