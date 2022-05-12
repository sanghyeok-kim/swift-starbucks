//
//  StarbucksTarget.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/10.
//

import Foundation

enum StarbucksTarget: BaseTarget {
    case requestHome
    case requestEvent
    case requestProductInfo(_ id: String)
    case requestProductImage(_ id: String)
}

extension StarbucksTarget {
    
    var baseURL: URL? {
        switch self {
        case .requestHome:
            return URL(string: "https://api.codesquad.kr/starbuckst")
        case .requestEvent, .requestProductInfo, .requestProductImage:
            return URL(string: "https://www.starbucks.co.kr")
        }
    }
    
    var path: String? {
        switch self {
        case .requestHome:
            return nil
        case .requestEvent:
            return "/whats_new/getIngList.do"
        case .requestProductInfo:
            return "/menu/productViewAjax.do"
        case .requestProductImage:
            return "/menu/productFileAjax.do"
        }
    }
    
    var parameter: [String: Any]? {
        switch self {
        case .requestHome:
            return nil
        case .requestEvent:
            return ["MENU_CD": "all"]
        case .requestProductInfo(let id):
            return ["product_cd": id]
        case .requestProductImage(let id):
            return ["PRODUCT_CD": id]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestHome:
            return .get
        case .requestEvent, .requestProductInfo, .requestProductImage:
            return .post
        }
    }
    
    var content: HTTPContentType {
        switch self {
        case .requestHome:
            return .json
        case .requestEvent, .requestProductInfo, .requestProductImage:
            return .urlencode
        }
    }
}
