//
//  APIError.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/10.
//

import Foundation

enum APIError: Error {
case custom(message: String, debugMessage: String)
}
