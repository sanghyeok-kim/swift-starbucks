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
    func requestEvent() -> Single<Swift.Result<StarbucksEntity.HomeEvent, APIError>>
    func requestCategory() -> Single<Swift.Result<[Category.Group], APIError>>
}
