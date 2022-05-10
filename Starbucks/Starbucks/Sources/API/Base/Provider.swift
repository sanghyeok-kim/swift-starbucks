//
//  Provider.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/10.
//

import Alamofire
import Foundation
import RxSwift

class Provider<Target: BaseTarget> {
    private static func createRequest(_ target: Target) -> URLRequest? {
        guard let url = target.baseURL?.appendingPathComponent(target.path) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = target.method.value
        target.header?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if target.content == .urlencode {
            if let param = target.parameter {
                let formDataString = param.reduce(into: "") {
                    $0 = $0 + "\($1.key)=\($1.value)&"
                }.dropLast()

                request.httpBody = formDataString.data(using: .utf8, allowLossyConversion: true)
            }
        } else {
            if let param = target.parameter,
               let body = try? JSONSerialization.data(withJSONObject: param, options: .init()) {
                request.httpBody = body
            }
        }
        return request
    }
    
    func request(_ target: Target) {
//        Single.crea
    }
}
