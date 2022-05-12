//
//  SuggestionMenuView.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/11.
//

import UIKit

class RecommandMenuView: UIView {
    enum Constants {
        static let cellSize = CGSize(width: 130, height: 180)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "싱하 님을 위한 추천 메뉴"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let menuCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        flowLayout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = true
        collectionView.register(RecommandMenuCellView.self, forCellWithReuseIdentifier: RecommandMenuCellView.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let dataSource = RecommandMenuDataSource()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func attribute() {
        menuCollectionView.dataSource = dataSource
        menuCollectionView.delegate = self
        menuCollectionView.reloadData()
    }
    
    private func layout() {
        addSubview(titleLabel)
        addSubview(menuCollectionView)
        
        snp.makeConstraints {
            $0.bottom.equalTo(menuCollectionView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.trailing.equalToSuperview()
        }

        menuCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.cellSize.height)
        }
    }
    
    func updateDataSource(_ products: [StarbucksEntity.ProductInfo]) {
        self.dataSource.updateProducts(products)
        DispatchQueue.main.async {
            self.menuCollectionView.reloadData()
        }
    }
    
    func updateDataSource( _ images: [[StarbucksEntity.ProductImageInfo]]) {
        self.dataSource.updateProductImages(images)
        DispatchQueue.main.async {
            self.menuCollectionView.reloadData()
        }
    }
}

extension RecommandMenuView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        Constants.cellSize
    }
}
