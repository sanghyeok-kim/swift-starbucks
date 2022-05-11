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
    case requestDetail(_ id: String)
}

extension StarbucksTarget {
    
    var baseURL: URL? {
        switch self {
        case .requestHome:
            return URL(string: "https://api.codesquad.kr/starbuckst")
        case .requestEvent:
            return URL(string: "https://www.starbucks.co.kr")
        case .requestDetail:
            return URL(string: "https://www.starbucks.co.kr/menu/productViewAjax.do")
        }
    }
    
    var path: String? {
        switch self {
        case .requestHome, .requestDetail:
            return nil
        case .requestEvent:
            return "/whats_new/getIngList.do"
        }
    }
    
    var parameter: [String: Any]? {
        switch self {
        case .requestHome:
            return nil
        case .requestEvent:
            return ["MENU_CD": "all"]
        case .requestDetail(let id):
            return ["product_cd": id]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestHome:
            return .get
        case .requestEvent, .requestDetail:
            return .post
        }
    }
    
    var content: HTTPContentType {
        switch self {
        case .requestHome:
            return .json
        case .requestEvent, .requestDetail:
            return .urlencode
        }
    }
}
