//
//  PayViewController.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/09.
//

import AVFoundation
import RxSwift
import UIKit

class PayViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = false
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
        
    private lazy var cardListViewController: CardListViewController = {
        let viewController = CardListViewController(viewModel: viewModel.cardListViewModel)
        return viewController
    }()
    
    private let tappedAddCard: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: nil)
        return button
    }()
    
    private let chargeView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let previewView = PreviewView()
    private let captureButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.layer.cornerRadius = 50
        return button
    }()
    
    private let viewModel: PayViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: PayViewModelProtocol) {
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
        rx.viewWillAppear
            .withUnretained(self)
            .bind(onNext: { vc, animated in
                vc.navigationController?.navigationBar.prefersLargeTitles = true

                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = .white
                appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

                vc.navigationController?.navigationBar.tintColor = .black
                //기본상태( 스크롤 있는 경우 아래로 이동했을 때 )
                vc.navigationController?.navigationBar.standardAppearance = appearance
                //가로화면으로 볼 때
                vc.navigationController?.navigationBar.compactAppearance = appearance
                //스크롤의 최 상단일 때
                vc.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            })
            .disposed(by: disposeBag)
        
        viewModel.state().presentChargeView
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { vc, session in
                vc.previewView.videoPreviewLayer?.session = session
            })
            .disposed(by: disposeBag)
        
        viewModel.state().isHiddenChargeView
            .withUnretained(self)
            .bind(onNext: { vc, isHidden in
                vc.navigationController?.navigationBar.isHidden = !isHidden
                vc.tabBarController?.tabBar.isHidden = !isHidden
                vc.chargeView.isHidden = isHidden
            })
            .disposed(by: disposeBag)
        
        captureButton.rx.tap
            .bind(to: viewModel.action().captureCamera)
            .disposed(by: disposeBag)
        
        tappedAddCard.rx.tap
            .bind(to: viewModel.action().tappedAddCard)
            .disposed(by: disposeBag)
        
        viewModel.state().showChargeEffect
            .bind(onNext: { amount in
                print("\(amount)원 충전 됫다오!")
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        title = "Pay"
        navigationItem.rightBarButtonItem = tappedAddCard
    }
    
    private func layout() {
        view.addSubview(scrollView)
        view.addSubview(chargeView)
        
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(cardListViewController.view)
        chargeView.addSubview(previewView)
        chargeView.addSubview(captureButton)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentStackView).offset(300)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        chargeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        previewView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        captureButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.width.height.equalTo(100)
        }
    }
}
