//
//  SuggestionMenuView.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/11.
//

import RxSwift
import UIKit

enum RecommandMenuType {
    case myMenu, thisTime
}

class RecommandMenuViewController: UIViewController {
    enum Constants {
        static let cellSize = CGSize(width: 130, height: 180)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .black.withAlphaComponent(0.1)
        return label
    }()
    
    private let menuCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = true
        collectionView.register(RecommandMenuCellView.self, forCellWithReuseIdentifier: RecommandMenuCellView.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let viewModel: RecommandMenuViewModelProtocol
    private let disposeBag = DisposeBag()
    private let dataSource: RecommandMenuDataSource
    
    init(type: RecommandMenuType, viewModel: RecommandMenuViewModelProtocol) {
        self.viewModel = viewModel
        self.dataSource = RecommandMenuDataSource(type: type)
        super.init(nibName: nil, bundle: nil)
        
        bind()
        attribute()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.state().loadedRecommandMenu
            .withUnretained(self)
            .bind(onNext: { vc, products in
                vc.dataSource.updateProducts(products)
                vc.menuCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.state().loadedRecommandImage
            .withUnretained(self)
            .bind(onNext: { vc, images in
                vc.dataSource.updateProductImages(images)
                vc.menuCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.state().displayTitle
            .withUnretained(self)
            .bind(onNext: { vc, title in
                vc.titleLabel.backgroundColor = .white
                vc.titleLabel.attributedText = title
            })
            .disposed(by: disposeBag)
    }

    private func attribute() {
        menuCollectionView.dataSource = dataSource
        menuCollectionView.delegate = self
        menuCollectionView.reloadData()
    }
    
    private func layout() {
        view.addSubview(titleLabel)
        view.addSubview(menuCollectionView)
        
        view.snp.makeConstraints {
            $0.bottom.equalTo(menuCollectionView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
        }

        menuCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.cellSize.height)
        }
    }
}

extension RecommandMenuViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        Constants.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.action().selectedProduct.accept(indexPath.item)
    }
}
