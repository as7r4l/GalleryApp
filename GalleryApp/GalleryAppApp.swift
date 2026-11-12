//
//  GalleryAppApp.swift
//  GalleryApp
//
//  Created by Никита Поведайко on 11/10/26.
//

import SwiftUI

@main
struct GalleryAppApp: App {
    
    let coreDataManager = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, coreDataManager.context)
        }
    }
}
