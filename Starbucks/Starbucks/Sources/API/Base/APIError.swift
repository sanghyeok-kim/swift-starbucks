//
//  APIError.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/10.
//

import Foundation

enum APIError: Error {
    case custom(message: String, debugMessage: String)
    case jsonMapping(response: Response)
    case objectMapping(error: Error, response: Response)
    case underlying(error: Swift.Error, response: Response?)
    case unowned
}

extension APIError {
    var statusCode: Int {
        switch self {
        case .jsonMapping(let response),
             .objectMapping(_, let response):
            return response.statusCode
        case .underlying(_, let response):
            return response?.statusCode ?? -9999
        case .custom, .unowned:
            return -9999
        }
    }
}
