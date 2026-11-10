import Foundation

protocol NetworkServiceProtocol {
    func fetchPhotos(page: Int) async throws -> [UnsplashPhoto]
}

final class NetworkService: NetworkServiceProtocol {
    private let accessKey = "Om5tJ-YFGAPRZ71elgkCXObePx-4Z5tAYLyzFwPGQ0I"
    private let baseURL = "https://api.unsplash.com/photos"
    
    func fetchPhotos(page: Int) async throws -> [UnsplashPhoto] {
        guard let url = URL(string: "\(baseURL)?page=\(page)&per_page=30&client_id=\(accessKey)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([UnsplashPhoto].self, from: data)
    }
}
