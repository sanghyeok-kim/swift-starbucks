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
        return stackView
    }()
    
    private let recommandMenuView: RecommandMenuView = {
        let recommandMenuView = RecommandMenuView(frame: .zero)
        return recommandMenuView
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
        
        rx.viewDidLoad
            .bind(to: viewModel.action().loadEvent)
            .disposed(by: disposeBag)
        
        viewModel.state().loadedRecommandMenu
            .withUnretained(self)
            .bind(onNext: { vc, details in
                vc.recommandMenuView.updateDataSource(details)
            })
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(recommandMenuView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentStackView)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
}
