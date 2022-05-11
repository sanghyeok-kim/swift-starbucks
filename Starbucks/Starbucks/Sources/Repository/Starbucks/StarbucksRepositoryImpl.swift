//
//  StarbucksRepositoryImpl.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/10.
//

import Foundation
import RxSwift

class StarbucksRepositoryImpl: NetworkRepository<StarbucksTarget>, StarbucksRepository {
    func requestHome() -> Single<Result<StarbucksEntity.Home, APIError>> {
        provider
            .request(.requestHome)
            .map(StarbucksEntity.Home.self)
    }
    
    func requestEvent() -> Single<Swift.Result<StarbucksEntity.HomeEvent, APIError>> {
        provider
            .request(.requestEvent)
            .map(StarbucksEntity.HomeEvent.self)
    }
    
    func requestCategory() -> Single<Swift.Result<[Category.Group], APIError>> {
        Single.create { observer in
            guard let url = Bundle.main.url(forResource: "Category", withExtension: "json"),
                  let data = try? Data(contentsOf: url),
                  let category = try? JSONDecoder().decode(Category.self, from: data) else {
                
                let response = Response(statusCode: -999, data: Data())
                let error = APIError.jsonMapping(response: response)
                observer(.success(.failure(error)))
                return Disposables.create { }
            }
            
            observer(.success(.success(category.groups)))
            return Disposables.create { }
        }
    }
}
