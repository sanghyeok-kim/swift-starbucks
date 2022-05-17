//
//  OrderListViewModel.swift
//  Starbucks
//
//  Created by YEONGJIN JANG on 2022/05/17.
//

import Foundation
import RxRelay
import RxSwift

protocol ListViewModelAction {
    var loadDetail: PublishRelay<Int> { get }
}
protocol ListViewModelState {
    // TODO: - Entity Type 구체화되면 17 라인 변경
    var loadedDetail: PublishRelay<Void> { get }
    var selectedProduct: PublishRelay<String> { get }
}

protocol ListViewModelBinding {
    func action() -> ListViewModelAction
    func state() -> ListViewModelState
}

typealias ListViewModelProtocol = ListViewModelBinding

class OrderListViewModel: ListViewModelAction, ListViewModelState, ListViewModelBinding {
    let list: [Product]
    
    @Inject(\.starbucksRepository) private var starbucksRepository: StarbucksRepository
    private let disposeBag = DisposeBag()
    
    func action() -> ListViewModelAction { self }
    
    let loadDetail = PublishRelay<Int>()
    
    func state() -> ListViewModelState { self }
    
    let loadedDetail = PublishRelay<Void>()
    let selectedProduct = PublishRelay<String>()
    
    init(list: [Product]) {
        self.list = list
//        Observable.just(list)
//            .first()
//            .compactMap { $0?.first?.productCategory }
//            .bind(to: selectedProduct)
//            .disposed(by: disposeBag)
    }
}
