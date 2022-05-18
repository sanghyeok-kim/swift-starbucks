//
//  StarbucksTarget.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/10.
//

import Foundation

enum StarbucksTarget: BaseTarget {
    case requestHome
    case requestPromotion
    case requestNews
    case requestNotice
    case requestProductInfo(_ id: String)
    case requestProductImage(_ id: String)
    case requestCategoryProduct(_ id: String)
}

extension StarbucksTarget {
    
    var baseURL: URL? {
        switch self {
        case .requestHome:
            return URL(string: "https://api.codesquad.kr/starbuckst")
        case .requestPromotion, .requestProductInfo, .requestProductImage, .requestNews, .requestNotice, .requestCategoryProduct:
            return URL(string: "https://www.starbucks.co.kr")
        }
    }
    
    var path: String? {
        switch self {
        case .requestHome:
            return nil
        case .requestPromotion:
            return "/whats_new/getIngList.do"
        case .requestProductInfo:
            return "/menu/productViewAjax.do"
        case .requestProductImage:
            return "/menu/productFileAjax.do"
        case .requestNews:
            return "/whats_new/newsListAjax.do"
        case .requestNotice:
            return "/whats_new/noticeListAjax.do"
        case .requestCategoryProduct(let id):
            return "/upload/json/menu/\(id).js"
        }
    }
    
    var parameter: [String: Any]? {
        switch self {
        case .requestHome, .requestNews, .requestNotice, .requestCategoryProduct:
            return nil
        case .requestPromotion:
            return ["MENU_CD": "all"]
        case .requestProductInfo(let id):
            return ["product_cd": id]
        case .requestProductImage(let id):
            return ["PRODUCT_CD": id]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestHome, .requestNews, .requestNotice, .requestCategoryProduct:
            return .get
        case .requestPromotion, .requestProductInfo, .requestProductImage :
            return .post
        }
    }
    
    var content: HTTPContentType {
        switch self {
        case .requestHome:
            return .json
        case .requestPromotion, .requestProductImage, .requestNews, .requestProductInfo, .requestNotice, .requestCategoryProduct:
            return .urlencode
        }
    }
}
