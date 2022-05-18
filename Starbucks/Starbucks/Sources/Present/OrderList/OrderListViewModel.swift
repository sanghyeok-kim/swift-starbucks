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
    var loadList: PublishRelay<Void> { get }
}
protocol ListViewModelState {
    // TODO: - Entity Type 구체화되면 loadedDetail 타입 변경
    var loadedDetail: PublishRelay<Void> { get }
    var loadedList: PublishRelay<[Product]> { get }
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
    let loadList = PublishRelay<Void>()
    
    func state() -> ListViewModelState { self }
    
    let loadedDetail = PublishRelay<Void>()
    let loadedList = PublishRelay<[Product]>()
    
    init(list: [Product]) {
        self.list = list
        
        action().loadList
            .withUnretained(self)
            .compactMap { model, _ in
                model.list
            }
            .bind(to: loadedList)
            .disposed(by: disposeBag)
        
        let requestDetailList = action().loadDetail
            .withUnretained(self)
            .map { model, index in
                model.list[index].productCode
            }
            .withUnretained(self)
            .flatMapLatest { model, target in
                model.starbucksRepository.requestDetail(target).asObservable()
            }
            .share()

        requestDetailList
            .bind(onNext: {
                print($0.value?.view)
            })
            .disposed(by: disposeBag)
    }
}
