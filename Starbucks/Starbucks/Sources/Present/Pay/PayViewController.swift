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
    
    private let titleView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Pay"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
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
        rx.viewDidAppear
            .map { _ in }
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                let titleColor: UIColor = .black.withAlphaComponent(0)
                vc.title = "Pay"
                vc.navigationController?.navigationBar.barTintColor = .white
                vc.navigationController?.navigationBar.isTranslucent = false
                vc.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: titleColor]
                vc.navigationItem.rightBarButtonItem = vc.tappedAddCard
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
        scrollView.delegate = self
    }
    
    private func layout() {
        view.addSubview(scrollView)
        view.addSubview(chargeView)
        
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleView)
        contentStackView.addArrangedSubview(cardListViewController.view)
        titleView.addSubview(titleLabel)
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
        
        titleView.snp.makeConstraints {
            $0.height.equalTo(titleLabel)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
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

extension PayViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var alpha: CGFloat = 0
        if scrollView.contentOffset.y < 0 {
            alpha = 0
        } else {
            alpha = scrollView.contentOffset.y / titleLabel.frame.size.height
            alpha = alpha > 1 ? 1 : alpha
        }
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black.withAlphaComponent(alpha)]
    }
}
