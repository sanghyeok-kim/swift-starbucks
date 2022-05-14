//
//  WhatsNewListViewController.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/14.
//

import RxSwift
import UIKit

class WhatsNewListViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WhatsNewListViewCell.self, forCellReuseIdentifier: WhatsNewListViewCell.identifier)
        tableView.estimatedRowHeight = 50
        return tableView
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
    
    private func bind() {
        
        rx.viewDidLoad
            .bind(to: viewModel.action().loadEvents)
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .map { _ in }
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.navigationController?.isNavigationBarHidden = false
            })
            .disposed(by: disposeBag)
        
        viewModel.state().loadedEvents
            .withUnretained(self)
            .bind(onNext: { vc, events in
                vc.dataSource.updateEvents(events)
                vc.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        hidesBottomBarWhenPushed = true
        view.backgroundColor = .white
        
        tableView.dataSource = dataSource
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
