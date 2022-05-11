//
//  OrderViewModel.swift
//  Starbucks
//
//  Created by 김상혁 on 2022/05/09.
//

import Foundation
import RxRelay
import RxSwift

protocol OrderViewModelAction {
    var loadCategory: BehaviorRelay<Category.GroupType> { get }
    var loadCategoryList: PublishRelay<Int> { get }
}

protocol OrderViewModelState {
    var loadedCategory: PublishRelay<[Category.Group]> { get }
}

protocol OrderViewModelBinding {
    func action() -> OrderViewModelAction
    func state() -> OrderViewModelState
}

typealias OrderViewModelProtocol = OrderViewModelBinding

class OrderViewModel: OrderViewModelAction, OrderViewModelState, OrderViewModelBinding {
    
    func action() -> OrderViewModelAction { self }

    let loadCategory = BehaviorRelay<Category.GroupType>(value: .beverage)
    let loadCategoryList = PublishRelay<Int>()
    
    func state() -> OrderViewModelState { self }
    let loadedCategory = PublishRelay<[Category.Group]>()
    
    
    private let disposeBag = DisposeBag()
    private var categoryMenu: [Category.GroupType : [Category.Group]]?
    
    init() {
        loadCategory
            .compactMap { self.categoryMenu?[$0] }
            .bind(to: loadedCategory)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(loadCategory, loadCategoryList)
            .bind(onNext: { category, menuIndex in
                // TODO: - List Category 뷰로 연결하는 로직
            })
            .disposed(by: disposeBag)
    }
}
