//
//  MainViewModel.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/09.
//

import Foundation
import RxRelay
import RxSwift

protocol HomeViewModelAction {
    var loadHome: PublishRelay<Void> { get }
    var loadEvent: PublishRelay<Void> { get }
}

protocol HomeViewModelState {
    var loadEvent: PublishRelay<Void> { get }
}

protocol HomeViewModelBinding {
    func action() -> HomeViewModelAction
    func state() -> HomeViewModelState
}

typealias HomeViewModelProtocol = HomeViewModelBinding

class HomeViewModel: HomeViewModelBinding, HomeViewModelAction, HomeViewModelState {
    func action() -> HomeViewModelAction { self }
    
    let loadHome = PublishRelay<Void>()
    let loadEvent = PublishRelay<Void>()
    
    func state() -> HomeViewModelState { self }
    
    private var starbucksRepository = StarbucksRepositoryImpl()
    
    private let disposeBag = DisposeBag()
    
    init() {
        let requestHome = action().loadHome
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.starbucksRepository.requestHome()
            }
            .share()
            
        requestHome
            .compactMap { $0.value }
            .bind(onNext: {
            })
            .disposed(by: disposeBag)
        
        let requestEvent = action().loadEvent
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.starbucksRepository.requestEvent()
            }
            .share()
        
        requestEvent
            .compactMap { $0.value }
            .bind(onNext: {
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                requestHome.compactMap { $0.error },
                requestEvent.compactMap { $0.error })
            .bind(onNext: {
            })
            .disposed(by: disposeBag)
    }
}
