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
    
    func requestEvent() -> Single<Swift.Result<StarbucksEntity.Promotions, APIError>> {
        provider
            .request(.requestPromotion)
            .map(StarbucksEntity.Promotions.self)
    }
    
    func requestDetail(_ id: String) -> Single<Swift.Result<StarbucksEntity.ProductDetail, APIError>> {
        provider
            .request(.requestProductInfo(id))
            .map(StarbucksEntity.ProductDetail.self)
    }
    
    func requestDetailImage(_ id: String) -> Single<Swift.Result<StarbucksEntity.ProductImage, APIError>> {
        provider
            .request(.requestProductImage(id))
            .map(StarbucksEntity.ProductImage.self)
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
    
    func requestNews() -> Single<Swift.Result<StarbucksEntity.Events, APIError>> {
        provider
            .request(.requestNews)
            .map(StarbucksEntity.Events.self)
    }
    
    func requestNotice() -> Single<Swift.Result<StarbucksEntity.Events, APIError>> {
        provider
            .request(.requestNotice)
            .map(StarbucksEntity.Events.self)
    }
}
