//
//  MainViewController.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/09.
//

import RxAppState
import RxSwift
import SnapKit
import UIKit

class HomeViewController: UIViewController {
    enum Constants {
        static let stickyViewHeight = 50.0
        static let homeInfoViewHeight = 250.0
        static let bottomOffset = 100.0
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = false
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = false
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40
        return stackView
    }()
    
    private let homeInfoView: HomeInfoView = {
        let view = HomeInfoView(stickViewHeight: Constants.stickyViewHeight)
        return view
    }()
    
    private lazy var myRecommandMenuViewController: RecommandMenuViewController = {
        let recommandMenuView = RecommandMenuViewController(type: .myMenu, viewModel: self.viewModel.recommandMenuViewModel)
        return recommandMenuView
    }()
    
    private lazy var timeRecommandMenuViewController: RecommandMenuViewController = {
        let recommandMenuView = RecommandMenuViewController(type: .thisTime, viewModel: self.viewModel.timeRecommandMenuViewModel)
        return recommandMenuView
    }()
    
    private lazy var mainEventViewController: MainEventViewController = {
        let viewController = MainEventViewController(viewModel: viewModel.mainEventViewModel)
        return viewController
    }()
    
    private lazy var whatsNewViewController: WhatsNewViewController = {
        let viewController = WhatsNewViewController(viewModel: viewModel.whatsNewViewModel)
        return viewController
    }()
    
    private let viewModel: HomeViewModelProtocol
    private let disposeBag = DisposeBag()
    private var topSafeArea: CGFloat = 0
    
    init(viewModel: HomeViewModelProtocol) {
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
            .bind(to: viewModel.action().loadHome)
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .map { _ in }
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.navigationController?.isNavigationBarHidden = true
            })
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                let window = UIApplication.shared.windows[0]
                vc.topSafeArea = window.safeAreaInsets.top
            })
            .disposed(by: disposeBag)
        
        viewModel.state().titleMessage
            .withUnretained(self)
            .bind(onNext: { vc, message in
                vc.homeInfoView.setMessage(message)
            })
            .disposed(by: disposeBag)
        
        viewModel.state().presentProductDetailView
            .withUnretained(self)
            .bind(onNext: { vc, product in
                //TODO: Present Detail View
                let viewController = OrderDetailViewController()
                viewController.modalPresentationStyle = .fullScreen
                vc.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        scrollView.delegate = self
    }
    
    private func layout() {
        view.addSubview(scrollView)
        view.addSubview(homeInfoView)
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(myRecommandMenuViewController.view)
        contentStackView.addArrangedSubview(mainEventViewController.view)
        contentStackView.addArrangedSubview(whatsNewViewController.view)
        contentStackView.addArrangedSubview(timeRecommandMenuViewController.view)
        
        contentStackView.setCustomSpacing(Constants.stickyViewHeight, after: homeInfoView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentStackView).offset(Constants.bottomOffset)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.homeInfoViewHeight)
            $0.leading.trailing.equalToSuperview()
        }
        
        homeInfoView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.homeInfoViewHeight)
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = 0.0
        
        let limiteScrollValue = Constants.homeInfoViewHeight - Constants.stickyViewHeight - topSafeArea
        homeInfoView.setAlpha(1.0 - scrollView.contentOffset.y / limiteScrollValue)
        
        if scrollView.contentOffset.y < limiteScrollValue {
            offset = (scrollView.contentOffset.y * -1)
        } else {
            offset = topSafeArea - Constants.homeInfoViewHeight + Constants.stickyViewHeight
        }
        
        homeInfoView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(offset)
        }
    }
}
