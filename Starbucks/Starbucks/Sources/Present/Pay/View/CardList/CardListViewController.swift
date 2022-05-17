//
//  CardListViewController.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/17.
//

import RxSwift
import UIKit

class CardListViewController: UIViewController {
    
    private let cardCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = true
        collectionView.register(CardListViewCell.self, forCellWithReuseIdentifier: CardListViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private let viewModel: CardListViewModelProtocol
    private let disposeBag = DisposeBag()
    private let dataSource = CardListViewDataSource()
    
    init(viewModel: CardListViewModelProtocol) {
        self.viewModel = viewModel
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
        
        rx.viewDidLoad
            .bind(to: viewModel.action().loadCardList)
            .disposed(by: disposeBag)
        
        viewModel.state().updateCardList
            .compactMap { $0 }
            .bind(onNext: dataSource.updateCards)
            .disposed(by: disposeBag)
        
        viewModel.state().reloadCardList
            .bind(onNext: cardCollectionView.reloadData)
            .disposed(by: disposeBag)
        
        dataSource.tappedCashCharge
            .bind(to: viewModel.action().tappedCashCharge)
            .disposed(by: disposeBag)
        
        viewModel.state().reloadCard
            .map { [IndexPath(item: $0, section: 0)] }
            .bind(onNext: cardCollectionView.reloadItems)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = dataSource
        cardCollectionView.reloadData()
    }
    
    private func layout() {
        view.addSubview(cardCollectionView)
        
        view.snp.makeConstraints {
            $0.height.equalTo(500)
        }
        
        cardCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension CardListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        view.frame.size
    }
}
