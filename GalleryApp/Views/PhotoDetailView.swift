import SwiftUI

struct PhotoDetailView: View {
    @ObservedObject var viewModel: GalleryViewModel
    @State var selectedPhotoId: String
    
    
    var body: some View {
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
        .navigationTitle("Детали")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // TODO: Сохранение в бд
                }) {
                    Image(systemName: "heart")
                        .foregroundColor(.red)
                }
            }
        }
    }
}
