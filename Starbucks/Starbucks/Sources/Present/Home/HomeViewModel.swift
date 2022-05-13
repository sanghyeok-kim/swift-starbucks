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
    var titleMessage: PublishRelay<String> { get }
    var presentProductDetailView: PublishRelay<String> { get }
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
    
    let titleMessage = PublishRelay<String>()
    let presentProductDetailView = PublishRelay<String>()
    
    let whatsNewViewModel: WhatsNewViewModelProtocol = WhatsNewViewModel()
    let mainEventViewModel: MainEventViewModelProtocol = MainEventViewModel()
    let recommandMenuViewModel: RecommandMenuViewModelProtocol = RecommandMenuViewModel()
        
    @Inject(\.starbucksRepository) private var starbucksRepository: StarbucksRepository
    
    private let disposeBag = DisposeBag()
    private var homeData: StarbucksEntity.Home?
    
    init() {
        let requestHome = action().loadHome
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.starbucksRepository.requestHome()
            }
            .share()
        
        requestHome
            .compactMap { $0.value }
            .withUnretained(self)
            .bind(onNext: { model, homeData in
                model.homeData = homeData
            })
            .disposed(by: disposeBag)
        
        requestHome
            .compactMap { $0.value?.yourRecommand.products }
            .bind(to: recommandMenuViewModel.action().loadedProducts)
            .disposed(by: disposeBag)
        
        requestHome
            .compactMap { $0.value?.displayName }
            .withUnretained(self)
            .bind(onNext: { model, name in
                model.titleMessage.accept("\(name)님\n오늘 하루도 고생 많으셨어요!")
                model.recommandMenuViewModel.action().loadedUserName.accept(name)
            })
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
        
        recommandMenuViewModel.action().selectedProduct
            .withUnretained(self)
            .compactMap { model, index in model.homeData?.yourRecommand.products?[index] }
            .bind(to: presentProductDetailView)
            .disposed(by: disposeBag)
        
        mainEventViewModel.action().tappedEvent
            .bind(onNext: {
                //TODO: Tapped Main Event
            })
            .disposed(by: disposeBag)
    }
}
