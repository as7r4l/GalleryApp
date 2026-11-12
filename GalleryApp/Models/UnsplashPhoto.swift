//
//  UnsplashPhoto.swift
//  GalleryApp
//
//  Created by Никита Поведайко on 11/10/26.
//

import Foundation


struct UnsplashPhoto: Codable, Identifiable, Equatable {
    let id: String
    let width: Int
    let height: Int
    let description: String?
    let altDescription: String?
    let urls: PhotoURLs
    let user: UnsplashUser
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case description
        case altDescription = "alt_description"
        case urls
        case user
    }
}

struct PhotoURLs: Codable, Equatable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct UnsplashUser: Codable, Equatable {
    let id: String
    let username: String
    let name: String
}
