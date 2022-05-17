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
    var presentWhatsNewListView: PublishRelay<Void> { get }
}

protocol HomeViewModelBinding {
    func action() -> HomeViewModelAction
    func state() -> HomeViewModelState
}

protocol HomeViewModelProperty {
    var whatsNewViewModel: WhatsNewViewModelProtocol { get }
    var mainEventViewModel: MainEventViewModelProtocol { get }
    var recommandMenuViewModel: RecommandMenuViewModelProtocol { get }
    var timeRecommandMenuViewModel: RecommandMenuViewModelProtocol { get }
}

typealias HomeViewModelProtocol = HomeViewModelBinding & HomeViewModelProperty

class HomeViewModel: HomeViewModelBinding, HomeViewModelProperty, HomeViewModelAction, HomeViewModelState {
    func action() -> HomeViewModelAction { self }
    
    let loadHome = PublishRelay<Void>()
    
    func state() -> HomeViewModelState { self }
    
    let titleMessage = PublishRelay<String>()
    let presentProductDetailView = PublishRelay<String>()
    let presentWhatsNewListView = PublishRelay<Void>()
    
    let whatsNewViewModel: WhatsNewViewModelProtocol = WhatsNewViewModel()
    let mainEventViewModel: MainEventViewModelProtocol = MainEventViewModel()
    let recommandMenuViewModel: RecommandMenuViewModelProtocol = RecommandMenuViewModel()
    let timeRecommandMenuViewModel: RecommandMenuViewModelProtocol = RecommandMenuViewModel()
    
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
            .map { "\($0)님\n오늘 하루도 고생 많으셨어요!" }
            .bind(to: titleMessage)
            .disposed(by: disposeBag)
        
        requestHome
            .compactMap { $0.value?.displayName }
            .map { NSMutableAttributedString().addStrings([
                .create($0, options: [.foreground(color: .brown1)]),
                .create("님을 위한 추천 메뉴")
            ])
            }
            .bind(to: recommandMenuViewModel.state().displayTitle)
            .disposed(by: disposeBag)
        
        requestHome
            .map { _ in NSMutableAttributedString(string: "이 시간대 추천 메뉴") }
            .bind(to: timeRecommandMenuViewModel.state().displayTitle)
            .disposed(by: disposeBag)
        
        requestHome
            .compactMap { $0.value?.nowRecommand.products }
            .bind(to: timeRecommandMenuViewModel.action().loadedProducts)
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
        
        Observable
            .merge(
                recommandMenuViewModel.action().selectedProduct.asObservable(),
                timeRecommandMenuViewModel.action().selectedProduct.asObservable()
            )
            .withUnretained(self)
            .compactMap { model, index in model.homeData?.yourRecommand.products?[index] }
            .bind(to: presentProductDetailView)
            .disposed(by: disposeBag)
        
        whatsNewViewModel.action().tappedSeeAllButton
            .bind(to: presentWhatsNewListView)
            .disposed(by: disposeBag)
    }
}
