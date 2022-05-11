//
//  SuggestionMenuView.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/11.
//

import UIKit

class SuggestionMenuView: UIView {
    enum Constants {
        static let cellSize = CGSize(width: 130, height: 160)
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
        collectionView.register(SuggestionMenuCellView.self, forCellWithReuseIdentifier: SuggestionMenuCellView.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var dataSource: SuggestionMenuDataSource?
    
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
    
    func updateDataSource(products: [StarbucksEntity.ProductDetail]) {
        self.dataSource = SuggestionMenuDataSource(products: products)
        DispatchQueue.main.async {
            self.menuCollectionView.dataSource = self.dataSource
            self.menuCollectionView.reloadData()
        }
    }
}

extension SuggestionMenuView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        Constants.cellSize
    }
}
