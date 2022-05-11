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
    
    enum GroupType: Codable, CaseIterable {
        case beverage, food, product
        
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
    }
    
    struct Group: Codable {
        let category: Category.GroupType
        let groupId: String
        let title: String
        let subTitle: String
        let imagePath: String
    }
}

