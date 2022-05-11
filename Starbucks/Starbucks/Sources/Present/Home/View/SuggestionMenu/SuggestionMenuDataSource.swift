//
//  SuggestionMenuDataSource.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/11.
//

import Foundation
import UIKit

class SuggestionMenuDataSource: NSObject, UICollectionViewDataSource {
    
    private let products: [StarbucksEntity.ProductDetail]
    
    init(products: [StarbucksEntity.ProductDetail]) {
        self.products = products
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionMenuCellView.identifier, for: indexPath) as? SuggestionMenuCellView else {
            return UICollectionViewCell()
        }
        return cell
    }
}
