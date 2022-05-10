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
}
