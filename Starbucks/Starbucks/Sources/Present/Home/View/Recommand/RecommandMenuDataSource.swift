//
//  SuggestionMenuDataSource.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/11.
//

import Foundation
import UIKit

class RecommandMenuDataSource: NSObject, UICollectionViewDataSource {
    
    private var products: [StarbucksEntity.ProductInfo] = []
    private var productimages: [[StarbucksEntity.ProductImageInfo]] = []
    
    func updateProducts(_ products: [StarbucksEntity.ProductInfo]) {
        self.products = products
    }
    
    func updateProductImages(_ images: [[StarbucksEntity.ProductImageInfo]]) {
        self.productimages = images
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommandMenuCellView.identifier, for: indexPath) as? RecommandMenuCellView else {
            return UICollectionViewCell()
        }
        
        let index = indexPath.item
        let product = products[index]
        let image = index >= productimages.count ? nil : productimages[index].first
        
        cell.setName(product.productName)
        cell.setThumbnail(image?.imageUrl)
        return cell
    }
}
