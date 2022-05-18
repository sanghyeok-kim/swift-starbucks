//
//  WhatsNewListViewController.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/14.
//

import RxSwift
import UIKit

class WhatsNewListViewController: UIViewController {
    enum Constants {
        static let navigationHeight = 50.0
    }
    
    private let navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What's New"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.alpha = 0
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.imageView?.tintColor = .black
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = false
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private let scrollContentView = UIView()
    
    private let tableView: IntrinsicTableView = {
        let tableView = IntrinsicTableView()
        tableView.register(WhatsNewListViewCell.self, forCellReuseIdentifier: WhatsNewListViewCell.identifier)
        tableView.estimatedRowHeight = 50
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private let tableTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "What's New"
        label.font = .systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private let viewModel: WhatsNewListViewProtocol
    private let disposeBag = DisposeBag()
    private let dataSource = WhatsNewListDataSource()
    
    init(viewModel: WhatsNewListViewProtocol) {
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
    
    deinit {
        Log.info("Deinit WhatsNewListViewController")
    }
    
    private func bind() {
        rx.viewDidLoad
            .bind(to: viewModel.action().loadEvents)
            .disposed(by: disposeBag)
        
        viewModel.state().updateEvents
            .bind(onNext: dataSource.updateEvents)
            .disposed(by: disposeBag)
        
        viewModel.state().reloadEvents
            .bind(onNext: tableView.reloadData)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        scrollView.delegate = self
        tableView.dataSource = dataSource
    }
    
    private func layout() {
        view.addSubview(navigationView)
        navigationView.addSubview(titleLabel)
        navigationView.addSubview(backButton)
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        
        scrollContentView.addSubview(tableTitleLabel)
        scrollContentView.addSubview(tableView)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.navigationHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(navigationView.snp.height)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(scrollContentView)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tableView)
        }
        
        tableTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(tableTitleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

extension WhatsNewListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var alpha: CGFloat = 0
        if scrollView.contentOffset.y < 0 {
            alpha = 0
        } else {
            alpha = scrollView.contentOffset.y / titleLabel.frame.size.height
            alpha = alpha > 1 ? 1 : alpha
        }
        
        titleLabel.alpha = alpha
    }
}
