import XCTest
@testable import GalleryApp 

@MainActor
final class GalleryViewModelTests: XCTestCase {

    var viewModel: GalleryViewModel!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = GalleryViewModel(networkService: mockNetworkService)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testLoadNextPage_Success() async {
        // Arrange
        let mockPhoto = UnsplashPhoto(
            id: "1",
            width: 100,
            height: 100,
            description: "Test",
            altDescription: nil,
            urls: PhotoURLs(raw: "", full: "", regular: "", small: "", thumb: ""),
            user: UnsplashUser(id: "u1", username: "testuser", name: "Test User")
        )
        mockNetworkService.mockPhotos = [mockPhoto]

        // Act
        await viewModel.loadNextPage()

        // Assert
        XCTAssertFalse(viewModel.photos.isEmpty)
        XCTAssertEqual(viewModel.photos.count, 1)
        XCTAssertEqual(viewModel.photos.first?.id, "1")
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadNextPage_Failure() async {
        // Arrange
        mockNetworkService.shouldReturnError = true

        // Act
        await viewModel.loadNextPage()

        // Assert
        XCTAssertTrue(viewModel.photos.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
