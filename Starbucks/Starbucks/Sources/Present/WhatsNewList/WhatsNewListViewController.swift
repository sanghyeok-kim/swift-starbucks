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
        static let tableHeaderViewHeight = 80.0
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
    
    private let tableHeaderView = UIView()
        
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WhatsNewListViewCell.self, forCellReuseIdentifier: WhatsNewListViewCell.identifier)
        tableView.estimatedRowHeight = 50
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
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.tableHeaderView = tableHeaderView
    }
    
    private func layout() {
        view.addSubview(navigationView)
        navigationView.addSubview(titleLabel)
        navigationView.addSubview(backButton)
        
        view.addSubview(tableView)
        tableHeaderView.addSubview(tableTitleLabel)
        
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
        
        tableHeaderView.snp.makeConstraints {
            $0.height.equalTo(Constants.tableHeaderViewHeight)
            $0.width.equalToSuperview()
        }
        
        tableTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension WhatsNewListViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var alpha: CGFloat = 0
        if scrollView.contentOffset.y < 0 {
            alpha = 0
        } else {
            alpha = scrollView.contentOffset.y / tableHeaderView.frame.height
            alpha = alpha > 1 ? 1 : alpha
        }
        
        titleLabel.alpha = alpha
    }
}
