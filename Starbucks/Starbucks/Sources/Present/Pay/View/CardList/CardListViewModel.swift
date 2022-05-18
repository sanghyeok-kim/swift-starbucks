//
//  CardListViewModel.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/17.
//

import Foundation
import RxRelay
import RxSwift

protocol CardListViewModelAction {
    var loadCardList: PublishRelay<Void> { get }
    var tappedAddCard: PublishRelay<Void> { get }
    var tappedCashCharge: PublishRelay<Int> { get }
    var chargedCash: PublishRelay<Int> { get }
}

protocol CardListViewModelState {
    var updateCardList: PublishRelay<[StarbucksEntity.Card]?> { get }
    var reloadCardList: PublishRelay<Void> { get }
    var reloadCard: PublishRelay<Int> { get }
}

protocol CardListViewModelBinding {
    func action() -> CardListViewModelAction
    func state() -> CardListViewModelState
}

typealias CardListViewModelProtocol = CardListViewModelBinding

class CardListViewModel: CardListViewModelBinding, CardListViewModelAction, CardListViewModelState {
    
    func action() -> CardListViewModelAction { self }
    
    let loadCardList = PublishRelay<Void>()
    let tappedAddCard = PublishRelay<Void>()
    let tappedCashCharge = PublishRelay<Int>()
    let chargedCash = PublishRelay<Int>()
    
    func state() -> CardListViewModelState { self }
    
    let updateCardList = PublishRelay<[StarbucksEntity.Card]?>()
    let reloadCardList = PublishRelay<Void>()
    let reloadCard = PublishRelay<Int>()
    
    @Inject(\.userStore) private var userStore: UserStore
    private let disposeBag = DisposeBag()
    private var cardList: [StarbucksEntity.Card] = []
    
    init() {
        loadCardList
            .withUnretained(self)
            .compactMap { model, _ in model.userStore.cardList }
            .withUnretained(self)
            .do { model, cardList in
                model.cardList = cardList
                model.updateCardList.accept(cardList)
            }
            .map { _ in }
            .bind(to: reloadCardList)
            .disposed(by: disposeBag)

        tappedAddCard
            .compactMap { _ -> StarbucksEntity.Card? in
                guard let imageUrl = URL(string: "https://image.istarbucks.co.kr/cardImg/20200818/007633_WEB.png") else {
                    return nil
                }
                return StarbucksEntity.Card(name: "카드5", cardImageUrl: imageUrl, amount: 10000)
            }
            .withUnretained(self)
            .do { model, newCard in
                var cardList = model.cardList
                cardList.append(newCard)
                model.cardList = cardList
                model.userStore.cardList = cardList
                model.updateCardList.accept(cardList)
            }
            .map { model, _ in model.cardList.count - 1 }
            .bind(to: reloadCard)
            .disposed(by: disposeBag)
        
        chargedCash
            .withLatestFrom(tappedCashCharge) { ($0, $1) }
            .withUnretained(self)
            .do { model, result in
                let (amount, index) = result
                model.cardList[index].addAmount(amount)
                model.userStore.cardList = model.cardList
                model.updateCardList.accept(model.cardList)
            }
            .map { $1.1 }
            .bind(to: reloadCard)
            .disposed(by: disposeBag)
    }
}
