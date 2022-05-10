//
//  CategoryMenu.swift
//  Starbucks
//
//  Created by YEONGJIN JANG on 2022/05/10.
//

import Foundation

protocol Menus {
    var name: String { get }
}

enum BeverageMenu: Menus, CaseIterable {
    case coldBrew, espresso, frappuccino, gucci
    
    var name: String {
        switch self {
        case .coldBrew:
            return "콜드브루"
        case .espresso:
            return "에스프레소"
        case .frappuccino:
            return "프라푸치노"
        case .gucci:
            return "구찌탕"
        }
    }
}

enum FoodMenu: Menus, CaseIterable {
    case bread, cake, sandwich
    
    var name: String {
        switch self {
        case .bread:
            return "빵"
        case .cake:
            return "케이크"
        case .sandwich:
            return "샌드위치"
        }
    }
}

enum ProductMenu: Menus, CaseIterable {
    case mug, glass, tumbler
    
    var name: String {
        switch self {
        case .mug:
            return "머그컵"
        case .glass:
            return "유리잔"
        case .tumbler:
            return "텀블러"
        }
    }
}

enum Category: CaseIterable {
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
