//
//  WhatsNewViewController.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/12.
//

import RxSwift
import UIKit

class WhatsNewViewController: UIViewController {
    enum Constants {
        static let cellSize = CGSize(width: 220, height: 200)
    }
    
    private let headerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What's New"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let seeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("See all", for: .normal)
        button.setTitleColor(.starbuckGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        return button
    }()
    
    private let eventCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = true
        collectionView.register(WhatsNewCellView.self, forCellWithReuseIdentifier: WhatsNewCellView.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let viewModel: WhatsNewViewModelProtocol
    private let disposeBag = DisposeBag()
    private let dataSource = WhatsNewDataSource()
    
    init(viewModel: WhatsNewViewModelProtocol) {
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
            .bind(to: viewModel.action().loadEvent)
            .disposed(by: disposeBag)
        
        viewModel.state().updateEvents
            .bind(onNext: dataSource.updateEvents)
            .disposed(by: disposeBag)
        
        viewModel.state().reloadEvents
            .bind(onNext: eventCollectionView.reloadData)
            .disposed(by: disposeBag)
        
        seeAllButton.rx.tap
            .bind(to: viewModel.action().tappedSeeAllButton)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        eventCollectionView.dataSource = dataSource
        eventCollectionView.delegate = self
        eventCollectionView.reloadData()
    }
    
    private func layout() {
        view.addSubview(titleLabel)
        view.addSubview(eventCollectionView)
        view.addSubview(seeAllButton)
        
        view.snp.makeConstraints {
            $0.bottom.equalTo(eventCollectionView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview()
        }
        
        seeAllButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(titleLabel)
        }
        
        eventCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.cellSize.height)
        }
    }
}

extension WhatsNewViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        Constants.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.action().selectedEvent.accept(indexPath.item)
    }
}
