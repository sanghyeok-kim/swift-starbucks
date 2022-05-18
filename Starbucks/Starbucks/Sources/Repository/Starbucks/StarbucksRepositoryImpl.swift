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
                  let data = try? Data(contentsOf: url) else {
                observer(.success(.failure(.unowned)))
                return Disposables.create { }
            }
            
            let response = Response(statusCode: 200, data: data)
            do {
                let category = try response.map(Category.self)
                observer(.success(.success(category.groups)))
            } catch {
                observer(.success(.failure(APIError.objectMapping(error: error, response: response))))
            }
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

extension StarbucksRepositoryImpl {
    func requestCategoryProduct(_ id: String) -> Single<Swift.Result<CategoryProductEntity, APIError>> {
        provider
            .request(.requestCategoryProduct(id))
            .map(CategoryProductEntity.self)
    }
}
