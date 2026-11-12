import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Галерея", systemImage: "photo.on.rectangle")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Избранное", systemImage: "heart.fill")
                }
        }
    }
}
