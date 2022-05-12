//
//  MainViewController.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/09.
//

import RxAppState
import RxSwift
import UIKit

class HomeViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = false
        scrollView.showsHorizontalScrollIndicator = true
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40
        return stackView
    }()
    
    private lazy var recommandMenuViewController: RecommandMenuViewController = {
        let recommandMenuView = RecommandMenuViewController(viewModel: self.viewModel.recommandMenuViewModel)
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
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
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
    }
    
    private func layout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(recommandMenuViewController.view)
        contentStackView.addArrangedSubview(mainEventViewController.view)
        contentStackView.addArrangedSubview(whatsNewViewController.view)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentStackView).offset(50)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
}
