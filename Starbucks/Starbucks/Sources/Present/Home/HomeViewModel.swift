//
//  MainViewModel.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/09.
//

import Foundation
import RxRelay

protocol HomeViewModelAction {
    var loadHomeData: PublishRelay<Void> { get }
}

protocol HomeViewModelState {
}

protocol HomeViewModelBinding {
    func action() -> HomeViewModelAction
    func state() -> HomeViewModelState
}

typealias HomeViewModelProtocol = HomeViewModelBinding

class HomeViewModel: HomeViewModelBinding, HomeViewModelAction, HomeViewModelState {
    func action() -> HomeViewModelAction { self }
    
    let loadHomeData = PublishRelay<Void>()
    
    func state() -> HomeViewModelState { self }
    
    init() {
    }
}
