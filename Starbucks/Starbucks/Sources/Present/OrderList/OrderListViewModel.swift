//
//  OrderListViewModel.swift
//  Starbucks
//
//  Created by YEONGJIN JANG on 2022/05/17.
//

import Foundation
import RxRelay
import RxSwift

protocol OrderListViewModelAction {
    var loadDetail: PublishRelay<Int> { get }
    var loadList: PublishRelay<Void> { get }
    var updateTitle: PublishRelay<Void> { get }
}

protocol OrderListViewModelState {
    var loadedDetail: PublishRelay<StarbucksEntity.ProductDetail> { get }
    var loadedDetailImage: PublishRelay<URL> { get }
    var updatedList: PublishRelay<[Product]> { get }
    var reloadedList: PublishRelay<Void> { get }
    var updatedTitle: PublishRelay<String> { get }
}

protocol OrderListViewModelBinding {
    func action() -> OrderListViewModelAction
    func state() -> OrderListViewModelState
}

typealias OrderListViewModelProtocol = OrderListViewModelBinding

class OrderListViewModel: OrderListViewModelAction, OrderListViewModelState, OrderListViewModelBinding {
    
    @Inject(\.starbucksRepository) private var starbucksRepository: StarbucksRepository
    private let disposeBag = DisposeBag()
    
    func action() -> OrderListViewModelAction { self }
    
    let loadDetail = PublishRelay<Int>()
    let loadList = PublishRelay<Void>()
    let updateTitle = PublishRelay<Void>()
    
    func state() -> OrderListViewModelState { self }
    
    var loadedDetail = PublishRelay<StarbucksEntity.ProductDetail>()
    var loadedDetailImage = PublishRelay<URL>()
    let updatedList = PublishRelay<[Product]>()
    let reloadedList = PublishRelay<Void>()
    let updatedTitle = PublishRelay<String>()
    
    init(subCategory: String, title: String) {
        
        action().updateTitle
            .map { title }
            .bind(to: state().updatedTitle)
            .disposed(by: disposeBag)
        
        let requestProducts = action().loadList
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.starbucksRepository.requestCategoryProduct(subCategory).asObservable()
            }
            .share()
            
        requestProducts
            .compactMap { $0.value?.products }
            .withUnretained(self)
            .do { model, products in
                model.updatedList.accept(products)
            }
            .map { _ in }
            .bind(to: reloadedList)
            .disposed(by: disposeBag)
    }
}
