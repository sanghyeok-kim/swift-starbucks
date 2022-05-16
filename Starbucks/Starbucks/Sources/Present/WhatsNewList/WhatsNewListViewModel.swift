//
//  WhatsNewListViewModel.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/14.
//

import Foundation
import RxRelay
import RxSwift

protocol WhatsNewListViewAction {
    var loadEvents: PublishRelay<Void> { get }
}

protocol WhatsNewListViewState {
    var loadedEvents: PublishRelay<[StarbucksEntity.Event]> { get }
}

protocol WhatsNewListViewBinding {
    func action() -> WhatsNewListViewAction
    func state() -> WhatsNewListViewState
}

typealias WhatsNewListViewProtocol = WhatsNewListViewBinding

class WhatsNewListViewModel: WhatsNewListViewProtocol, WhatsNewListViewAction, WhatsNewListViewState {
    func action() -> WhatsNewListViewAction { self }
    
    let loadEvents = PublishRelay<Void>()
    
    func state() -> WhatsNewListViewState { self }
    
    let loadedEvents = PublishRelay<[StarbucksEntity.Event]>()
    
    @Inject(\.starbucksRepository) private var starbucksRepository: StarbucksRepository
    private let disposeBag = DisposeBag()
    
    private let events: [StarbucksEntity.Event] = []
    
    init() {
        loadEvents
            .withUnretained(self)
            .flatMapLatest { model, _ in
                Observable.merge(
                    model.starbucksRepository.requestNews().asObservable().compactMap { $0.value?.list },
                    model.starbucksRepository.requestNotice().asObservable().compactMap { $0.value?.list }
                )
            }
            .scan(self.events, accumulator: +)
            .map { $0.sorted(by: { lhs, rhs in lhs.startDate > rhs.startDate }) }
            .bind(to: loadedEvents)
            .disposed(by: disposeBag)
    }
}
