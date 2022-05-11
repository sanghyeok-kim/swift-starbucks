//
//  SuggestionMenuDataSource.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/11.
//

import Foundation
import UIKit

class RecommandMenuDataSource: NSObject, UICollectionViewDataSource {
    
    private let products: [StarbucksEntity.ProductDatailData]
    
    init(products: [StarbucksEntity.ProductDatailData]) {
        self.products = products
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommandMenuCellView.identifier, for: indexPath) as? RecommandMenuCellView else {
            return UICollectionViewCell()
        }
        
        let product = products[indexPath.item]
        
        cell.setName(product.productName)
        return cell
    }
}
