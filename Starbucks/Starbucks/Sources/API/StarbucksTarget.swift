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
}

extension StarbucksTarget {
    
    var baseURL: URL? {
        switch self {
        case .requestHome:
            return URL(string: "https://api.codesquad.kr/starbuckst")
        case .requestEvent:
            return URL(string: "https://www.starbucks.co.kr")
        }
    }
    
    var path: String? {
        switch self {
        case .requestHome:
            return nil
        case .requestEvent:
            return "/whats_new/getIngList.do"
        }
    }
    
    var parameter: [String : Any]?  {
        switch self {
        case .requestHome:
            return nil
        case .requestEvent:
            return ["MENU_CD":"all"]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestHome:
            return .get
        case .requestEvent:
            return .post
        }
    }
    
    var content: HTTPContentType {
        switch self {
        case .requestHome:
            return .json
        case .requestEvent:
            return .urlencode
        }
    }
}
