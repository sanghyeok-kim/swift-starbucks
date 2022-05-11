//
//  CategoryEntity.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/11.
//

import Foundation

struct CategoryEntity {}

extension CategoryEntity {
    
    struct Category: Codable {
        let beverageMenu: [Group]
        let foodMenu: [Group]
        let productMenu: [Group]
    }
    
    struct Group: Codable {
        let groupId: String
        let title: String
        let subTitle: String
        let imagePath: String
    }
}
