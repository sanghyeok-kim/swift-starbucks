//
//  UserStore.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/17.
//

import Foundation

class UserStore {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    @UserDefault(key: UserDefault.Key.cardList) private var cardListData: Data?
    
    var cardList: [StarbucksEntity.Card] {
        get {
            getValue([StarbucksEntity.Card].self, data: self.cardListData) ?? []
        } set {
            guard let data = try? encoder.encode(newValue) else {
                return
            }
            self.cardListData = data
        }
    }
    
    private func getValue<T: Decodable>(_ type: T.Type, data: Data?) -> T? {
        guard let data = data,
            let value = try? decoder.decode(T.self, from: data) else {
            return nil
        }
        
        return value
    }
}
