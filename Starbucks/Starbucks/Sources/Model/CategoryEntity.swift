//
//  CategoryEntity.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/11.
//

import Foundation

struct Category: Codable {
    let groups: [Group]
}

extension Category {
    
    enum GroupType: String, Codable, CaseIterable {
        case beverage = "BEVERAGE"
        case food = "FOOD"
        case product = "PRODUCT"
        
        var name: String {
            switch self {
            case .beverage:
                return "음료"
            case .food:
                return "푸드"
            case .product:
                return "상품"
            }
        }
        
        var index: Int {
            switch self {
            case .beverage:
                return 0
            case .food:
                return 1
            case .product:
                return 2
            }
        }
        
        static func indexToCase(_ index: Int) -> GroupType? {
            switch index {
            case 0:
                return .beverage
            case 1:
                return .food
            case 2:
                return .product
            default:
                return nil
            }
        }
    }
    
    struct Group: Codable {
        let category: Category.GroupType
        let groupId: String
        let title: String
        let subTitle: String
        let imagePath: URL
    }
}
