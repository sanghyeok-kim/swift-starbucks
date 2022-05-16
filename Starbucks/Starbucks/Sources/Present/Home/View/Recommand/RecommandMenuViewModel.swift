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
    var selectedProduct: PublishRelay<Int> { get }
}

protocol RecommandMenuViewModelState {
    var loadedRecommandMenu: PublishRelay<[StarbucksEntity.ProductInfo]> { get }
    var loadedRecommandImage: PublishRelay<[[StarbucksEntity.ProductImageInfo]]> { get }
    var displayTitle: PublishRelay<NSMutableAttributedString> { get }
}

protocol RecommandMenuViewModelBinding {
    func action() -> RecommandMenuViewModelAction
    func state() -> RecommandMenuViewModelState
}

typealias RecommandMenuViewModelProtocol = RecommandMenuViewModelBinding

class RecommandMenuViewModel: RecommandMenuViewModelBinding, RecommandMenuViewModelAction, RecommandMenuViewModelState {
    
    func action() -> RecommandMenuViewModelAction { self }
    
    let loadedProducts = PublishRelay<[String]>()
    let selectedProduct = PublishRelay<Int>()
    
    func state() -> RecommandMenuViewModelState { self }
    
    let loadedRecommandMenu = PublishRelay<[StarbucksEntity.ProductInfo]>()
    let loadedRecommandImage = PublishRelay<[[StarbucksEntity.ProductImageInfo]]>()
    let displayTitle = PublishRelay<NSMutableAttributedString>()
    
    @Inject(\.starbucksRepository) private var starbucksRepository: StarbucksRepository
    private let disposeBag = DisposeBag()
 
    init() {
        loadedProducts
            .withUnretained(self)
            .flatMapLatest { model, ids in
                Observable.zip( ids.map { id in
                    model.starbucksRepository.requestDetail(id).asObservable()
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
    }
}
