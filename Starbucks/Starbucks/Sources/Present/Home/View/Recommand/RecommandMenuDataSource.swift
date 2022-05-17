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
    private let type: RecommandMenuType
    
    init(type: RecommandMenuType) {
        self.type = type
        super.init()
    }
    
    func updateProducts(_ products: [StarbucksEntity.ProductInfo]) {
        self.products = products
    }
    
    func updateProductImages(_ images: [[StarbucksEntity.ProductImageInfo]]) {
        self.productimages = images
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.isEmpty ? 3 : products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommandMenuCellView.identifier, for: indexPath) as? RecommandMenuCellView else {
            return UICollectionViewCell()
        }
        let index = indexPath.item
        
        if index >= products.count {
            cell.emptyCell()
            return cell
        }
        
        let product = products[index]
        let image = index >= productimages.count ? nil : productimages[index].first
        
        var attributedStrings: [NSAttributedString] = []
        if type == .thisTime {
            let indexText: NSAttributedString = .create("\(index + 1) ", options: [.font(.systemFont(ofSize: 20, weight: .bold))])
            attributedStrings.append(indexText)
        }
        attributedStrings.append(.create(product.productName))
        
        let name = NSMutableAttributedString().addStrings(attributedStrings)
        cell.setName(name)
        cell.setThumbnail(image?.imageUrl)
        return cell
    }
}
