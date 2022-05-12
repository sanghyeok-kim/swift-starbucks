//
//  HomeModel.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/10.
//

import Foundation

struct StarbucksEntity {}

extension StarbucksEntity {
    struct Home: Decodable {
        let displayName: String
        let yourRecommand: Recommand
        let mainEvent: MainEvent
        let nowRecommand: Recommand
        
        enum CodingKeys: String, CodingKey {
            case displayName = "display-name"
            case yourRecommand = "your-recommand"
            case mainEvent = "main-event"
            case nowRecommand = "now-recommand"
        }
    }
    
    struct Recommand: Decodable {
        let products: [String]?
    }
    
    struct MainEvent: Decodable {
        let imageUploadPath: URL
        let thumbnail: String
        
        enum CodingKeys: String, CodingKey {
            case imageUploadPath = "img_UPLOAD_PATH"
            case thumbnail = "mob_THUM"
        }
    }
}

extension StarbucksEntity {
    struct HomeEvent: Decodable {
        let list: [Event]
    }
    
    struct Event: Decodable {
        let title: String
        let imageUploadPath: URL
        let thumbnail: String
        
        enum CodingKeys: String, CodingKey {
            case title
            case imageUploadPath = "img_UPLOAD_PATH"
            case thumbnail = "mob_THUM"
        }
    }
}

extension StarbucksEntity {
    struct ProductDetail: Decodable {
        let view: ProductInfo?
    }
    
    struct ProductInfo: Decodable {
        let productName: String
        
        enum CodingKeys: String, CodingKey {
            case productName = "product_NM"
        }
    }
    
    struct ProductImage: Decodable {
        let file: [ProductImageInfo]?
    }
    
    struct ProductImageInfo: Decodable {
        let filePath: String
        let imageUploadPath: URL
        
        enum CodingKeys: String, CodingKey {
            case filePath = "file_PATH"
            case imageUploadPath = "img_UPLOAD_PATH"
        }
        
        var imageUrl: URL {
            imageUploadPath.appendingPathComponent(filePath)
        }
    }
}
