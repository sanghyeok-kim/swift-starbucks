//
//  MainEventViewModel.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/12.
//

import Foundation
import RxRelay
import RxSwift

protocol MainEventViewModelAction {
    var loadedEvent: PublishRelay<StarbucksEntity.MainEvent> { get }
    var tappedEvent: PublishRelay<Void> { get }
}

protocol MainEventViewModelState {
    var loadedMainEventImage: PublishRelay<URL> { get }
}

protocol MainEventViewModelBinding {
    func action() -> MainEventViewModelAction
    func state() -> MainEventViewModelState
}

typealias MainEventViewModelProtocol = MainEventViewModelBinding

class MainEventViewModel: MainEventViewModelBinding, MainEventViewModelAction, MainEventViewModelState {
    func action() -> MainEventViewModelAction { self }
    
    var loadedEvent = PublishRelay<StarbucksEntity.MainEvent>()
    var tappedEvent = PublishRelay<Void>()
    
    func state() -> MainEventViewModelState { self }
    
    let loadedMainEventImage = PublishRelay<URL>()
    
    @Inject(\.starbucksRepository) private var starbucksRepository: StarbucksRepository
    private let disposeBag = DisposeBag()
    
    init() {
        loadedEvent
            .map { $0.imageUrl }
            .bind(to: loadedMainEventImage)
            .disposed(by: disposeBag)
    }
}
