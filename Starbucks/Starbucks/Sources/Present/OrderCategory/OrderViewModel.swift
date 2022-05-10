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
    var loadCategory: BehaviorRelay<Category> { get }
    var loadCategoryList: PublishRelay<Int> { get }
}

protocol OrderViewModelState {
    var loadedCategory: PublishRelay<[Menus]> { get }
}

protocol OrderViewModelBinding {
    func action() -> OrderViewModelAction
    func state() -> OrderViewModelState
}

typealias OrderViewModelProtocol = OrderViewModelBinding

class OrderViewModel: OrderViewModelAction, OrderViewModelState, OrderViewModelBinding {
    
    func action() -> OrderViewModelAction { self }

    let loadCategory = BehaviorRelay<Category>(value: .beverage)
    let loadCategoryList = PublishRelay<Int>()
    
    func state() -> OrderViewModelState { self }
    let loadedCategory = PublishRelay<[Menus]>()
    
    
    private let disposeBag = DisposeBag()
    private let categoryMenu: [Category : [Menus]] = [.beverage : BeverageMenu.allCases,
                                                      .food : FoodMenu.allCases,
                                                      .product : ProductMenu.allCases]
    
    init() {
        loadCategory
            .compactMap { self.categoryMenu[$0] }
            .bind(to: loadedCategory)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(loadCategory, loadCategoryList)
            .bind(onNext: { category, menuIndex in
                print(category, menuIndex)
            })
            .disposed(by: disposeBag)
    }
}
