//
//  RecommandMenuViewModel.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/12.
//

import Foundation
import RxRelay
import RxSwift

protocol RecommandMenuViewModelAction {
    var loadedProducts: PublishRelay<[String]> { get }
    var loadedUserName: PublishRelay<String> { get }
}

protocol RecommandMenuViewModelState {
    var loadedRecommandMenu: PublishRelay<[StarbucksEntity.ProductInfo]> { get }
    var loadedRecommandImage: PublishRelay<[[StarbucksEntity.ProductImageInfo]]> { get }
    var displayTitle: PublishRelay<String> { get }
}

protocol RecommandMenuViewModelBinding {
    func action() -> RecommandMenuViewModelAction
    func state() -> RecommandMenuViewModelState
}

typealias RecommandMenuViewModelProtocol = RecommandMenuViewModelBinding

class RecommandMenuViewModel: RecommandMenuViewModelBinding, RecommandMenuViewModelAction, RecommandMenuViewModelState {
    
    func action() -> RecommandMenuViewModelAction { self }
    
    let loadedProducts = PublishRelay<[String]>()
    let loadedUserName = PublishRelay<String>()
    
    func state() -> RecommandMenuViewModelState { self }
    
    let loadedRecommandMenu = PublishRelay<[StarbucksEntity.ProductInfo]>()
    let loadedRecommandImage = PublishRelay<[[StarbucksEntity.ProductImageInfo]]>()
    let displayTitle = PublishRelay<String>()
    
    @Inject(\.starbucksRepository) private var starbucksRepository: StarbucksRepository
    private let disposeBag = DisposeBag()
 
    init() {
        loadedProducts
            .flatMapLatest { ids in
                Observable.zip( ids.map { id in
                    self.starbucksRepository.requestDetail(id).asObservable()
                        .compactMap { $0.value }
                })
            }
            .map { $0.compactMap { $0.view } }
            .bind(to: loadedRecommandMenu)
            .disposed(by: disposeBag)
        
        loadedProducts
            .flatMapLatest { ids in
                Observable.zip( ids.map { id in
                    self.starbucksRepository.requestDetailImage(id).asObservable()
                        .compactMap { $0.value }
                })
            }
            .map { $0.compactMap { $0.file }.filter { !$0.isEmpty } }
            .bind(to: loadedRecommandImage)
            .disposed(by: disposeBag)
        
        loadedUserName
            .map { "\($0)님을 위한 추천 메뉴" }
            .bind(to: displayTitle)
            .disposed(by: disposeBag)        
    }
}
