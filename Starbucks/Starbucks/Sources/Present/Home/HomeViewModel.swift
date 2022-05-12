//
//  MainViewModel.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/09.
//

import Foundation
import RxRelay
import RxSwift

protocol HomeViewModelAction {
    var loadHome: PublishRelay<Void> { get }
}

protocol HomeViewModelState {
}

protocol HomeViewModelBinding {
    func action() -> HomeViewModelAction
    func state() -> HomeViewModelState
}

protocol HomeViewModelProperty {
    var whatsNewViewModel: WhatsNewViewModelProtocol { get }
    var mainEventViewModel: MainEventViewModelProtocol { get }
    var recommandMenuViewModel: RecommandMenuViewModelProtocol { get }
}

typealias HomeViewModelProtocol = HomeViewModelBinding & HomeViewModelProperty

class HomeViewModel: HomeViewModelBinding, HomeViewModelProperty, HomeViewModelAction, HomeViewModelState {
    func action() -> HomeViewModelAction { self }
    
    let loadHome = PublishRelay<Void>()
    
    func state() -> HomeViewModelState { self }
    
    let whatsNewViewModel: WhatsNewViewModelProtocol = WhatsNewViewModel()
    let mainEventViewModel: MainEventViewModelProtocol = MainEventViewModel()
    let recommandMenuViewModel: RecommandMenuViewModelProtocol = RecommandMenuViewModel()
        
    @Inject(\.starbucksRepository) private var starbucksRepository: StarbucksRepository
    
    private let disposeBag = DisposeBag()
    
    init() {
        let requestHome = action().loadHome
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.starbucksRepository.requestHome()
            }
            .share()
        
        requestHome
            .compactMap { $0.value?.yourRecommand.products }
            .bind(to: recommandMenuViewModel.action().loadedProducts)
            .disposed(by: disposeBag)
        
        requestHome
            .compactMap { $0.value?.displayName }
            .bind(to: recommandMenuViewModel.action().loadedUserName)
            .disposed(by: disposeBag)
        
        requestHome
            .compactMap { $0.value?.mainEvent }
            .bind(to: mainEventViewModel.action().loadedEvent)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                requestHome.compactMap { $0.error }
            )
            .bind(onNext: { _ in
            })
            .disposed(by: disposeBag)
    }
}
