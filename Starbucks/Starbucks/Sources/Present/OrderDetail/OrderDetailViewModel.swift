//
//  OrderDetailViewModel.swift
//  Starbucks
//
//  Created by 김상혁 on 2022/05/18.
//

import Foundation
import RxRelay
import RxSwift

protocol OrderDetailViewModelAction {
}

protocol OrderDetailViewModelState {
}

protocol OrderDetailViewModelBinding {
    func action() -> OrderDetailViewModelAction
    func state() -> OrderDetailViewModelState
}

typealias OrderDetailViewModelProtocol = OrderDetailViewModelBinding

class OrderDetailViewModel: OrderDetailViewModelAction, OrderDetailViewModelState, OrderDetailViewModelBinding {
    
    @Inject(\.starbucksRepository) private var starbucksRepository: StarbucksRepository
    private let disposeBag = DisposeBag()
    
    func action() -> OrderDetailViewModelAction { self }
    
    func state() -> OrderDetailViewModelState { self }

    init(productCode: String) {
        
    }
}
