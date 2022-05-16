//
//  WhatsNewViewModel.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/12.
//

import Foundation
import RxRelay
import RxSwift

protocol WhatsNewViewModelAction {
    var loadEvent: PublishRelay<Void> { get }
    var selectedEvent: PublishRelay<Int> { get }
    var tappedSeeAllButton: PublishRelay<Void> { get }
}

protocol WhatsNewViewModelState {
    var loadedEvent: PublishRelay<[StarbucksEntity.Promotion]> { get }
}

protocol WhatsNewViewModelBinding {
    func action() -> WhatsNewViewModelAction
    func state() -> WhatsNewViewModelState
}

typealias WhatsNewViewModelProtocol = WhatsNewViewModelBinding

class WhatsNewViewModel: WhatsNewViewModelBinding, WhatsNewViewModelAction, WhatsNewViewModelState {
    
    func action() -> WhatsNewViewModelAction { self }
    
    let loadEvent = PublishRelay<Void>()
    let selectedEvent = PublishRelay<Int>()
    let tappedSeeAllButton = PublishRelay<Void>()
    
    func state() -> WhatsNewViewModelState { self }
    
    let loadedEvent = PublishRelay<[StarbucksEntity.Promotion]>()

    @Inject(\.starbucksRepository) private var starbucksRepository: StarbucksRepository
    private let disposeBag = DisposeBag()
    
    init() {
        let requestEvent = action().loadEvent
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.starbucksRepository.requestEvent()
            }
            .share()

        requestEvent
            .compactMap { $0.value?.list }
            .bind(to: loadedEvent)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                requestEvent.compactMap { $0.error }
            )
            .bind(onNext: { _ in
            })
            .disposed(by: disposeBag)
    }
}
