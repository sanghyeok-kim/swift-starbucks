//
//  StarbucksRepository.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/10.
//

import Foundation
import RxSwift

protocol StarbucksRepository {
    func requestHome() -> Single<Swift.Result<StarbucksEntity.Home, APIError>>
    func requestEvent() -> Single<Swift.Result<StarbucksEntity.Promotions, APIError>>
    func requestDetail(_ id: String) -> Single<Swift.Result<StarbucksEntity.ProductDetail, APIError>>
    func requestDetailImage(_ id: String) -> Single<Swift.Result<StarbucksEntity.ProductImage, APIError>>
    func requestCategory() -> Single<Swift.Result<[Category.Group], APIError>>
    func requestNews() -> Single<Swift.Result<StarbucksEntity.Events, APIError>>
    func requestNotice() -> Single<Swift.Result<StarbucksEntity.Events, APIError>>
    func requestCategoryProduct(_ id: String) -> Single<Swift.Result<CategoryProductEntity, APIError>>
}
