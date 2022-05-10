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
    var viewDidLoad: PublishRelay<Void> { get }
}

protocol OrderViewModelState {
    var test: PublishRelay<String> { get }
}

protocol OrderViewModelBinding {
    func action() -> OrderViewModelAction
    func state() -> OrderViewModelState
}

typealias OrderViewModelProtocol = OrderViewModelBinding

class OrderViewModel: OrderViewModelAction, OrderViewModelState, OrderViewModelBinding {
    
    func action() -> OrderViewModelAction { self }
    
    let viewDidLoad = PublishRelay<Void>()
    
    func state() -> OrderViewModelState { self }
    
    let test = PublishRelay<String>()
    
    let disposeBag = DisposeBag()
    
    init() {
        viewDidLoad
            .map { "map test" }
            .bind(to: test)
            .disposed(by: disposeBag)
        
        viewDidLoad
            .map { "gucci test" }
            .bind(to: test)
            .disposed(by: disposeBag)
    }
}
