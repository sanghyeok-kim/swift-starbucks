//
//  CardListViewDataSource.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/17.
//

import Foundation
import RxSwift
import UIKit

class CardListViewDataSource: NSObject, UICollectionViewDataSource {
    private var cards: [StarbucksEntity.Card] = []
    let tappedCashCharge = PublishSubject<Int>()
    
    func updateCards(_ cards: [StarbucksEntity.Card]) {
        self.cards = cards
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardListViewCell.identifier, for: indexPath) as? CardListViewCell else {
            return UICollectionViewCell()
        }
        
        let card = cards[indexPath.item]
        cell.setName(card.name)
        cell.setAmount(card.amount)
        cell.setThumbnail(url: card.cardImageUrl)
        cell.startTimer()
        cell.registChargeEvent { [weak self] in
            self?.tappedCashCharge.onNext(indexPath.item)
        }
        return cell
    }
}
