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
        
        var imageUrl: URL {
            imageUploadPath.appendingPathComponent(thumbnail)
        }
    }
}

extension StarbucksEntity {
    struct Promotions: Decodable {
        let list: [Promotion]
    }
    
    struct Promotion: Decodable {
        let title: String
        let imageUploadPath: URL
        let thumbnail: String
        
        enum CodingKeys: String, CodingKey {
            case title
            case imageUploadPath = "img_UPLOAD_PATH"
            case thumbnail = "mob_THUM"
        }
        
        var imageUrl: URL {
            imageUploadPath.appendingPathComponent("/upload/promotion/" + thumbnail)
        }
    }
}

extension StarbucksEntity {
    struct Events: Decodable {
        let list: [Event]
    }
    
    struct Event: Decodable {
        let title: String
        let newsDate: String
        let thumbnail: String
        let startDate: String
        
        enum CodingKeys: String, CodingKey {
            case title
            case newsDate = "news_dt"
            case thumbnail = "img_nm"
            case startDate = "start_dt"
        }
        
        var thumbnailUrl: URL? {
            URL(string: "https://image.istarbucks.co.kr/upload/news/\(thumbnail)")
        }
    }
}

extension StarbucksEntity {
    struct ProductDetail: Decodable {
        let view: ProductInfo?
    }
    
    struct ProductInfo: Decodable {
        let productName: String
        let productEnglishName: String
        let productCode: String
        let recommendDescription: String
        let hotAvailable: String
        let kilocalorie: String
        let fat: String
        let sturatedFat: String
        let transFat: String
        let cholesterol: String
        let sugars: String
        let protein: String
        let caffeine: String
        let allergy: String
        
        enum CodingKeys: String, CodingKey {
            case productName = "product_NM"
            case productEnglishName = "product_ENGNM"
            case productCode = "product_CD"
            case recommendDescription = "recommend"
            case hotAvailable = "hot_YN"
            case kilocalorie = "kcal"
            case fat
            case sturatedFat = "sat_FAT"
            case transFat = "trans_FAT"
            case cholesterol
            case sugars
            case protein
            case caffeine
            case allergy
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

extension StarbucksEntity {
    struct CardList: Codable {
        let cards: [Card]
    }
    
    struct Card: Codable {
        let id: String
        let name: String
        let cardImageUrl: URL
        private(set) var amount: Int
        
        init(name: String, cardImageUrl: URL, amount: Int) {
            self.id = UUID().uuidString
            self.name = name
            self.cardImageUrl = cardImageUrl
            self.amount = amount
        }
        
        mutating func addAmount(_ amount: Int) {
            self.amount += amount
        }
    }
}
