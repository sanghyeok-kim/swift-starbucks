//
//  DetailOrderViewController.swift
//  Starbucks
//
//  Created by 김상혁 on 2022/05/10.
//

import RxAppState
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class OrderListViewController: UIViewController {

    let tableView = UITableView()
    let tableViewHandler = OrderListTableViewDelegate()
    let viewModel: ListViewModelProtocol
    var tableViewDatasource: OrderListTableViewDataSource?
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: ListViewModelProtocol) {
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
            .bind(to: viewModel.action().loadList)
            .disposed(by: disposeBag)
        
        tableViewHandler.selectedCellIndex
            .bind(to: viewModel.action().loadDetail)
            .disposed(by: disposeBag)
    
        viewModel.state().loadedList
            .withUnretained(self)
            .subscribe(onNext: { model, list in
                model.updateTableViewDatasource(list: list)
                model.categoryLabel.text = list.first?.productCategory
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.shadowImage = UIImage()
        configureTableView()
    }
    
    private func layout() {
        view.addSubview(tableView)
        view.addSubview(categoryLabel)
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(20)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureTableView() {
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.dataSource = tableViewDatasource
        tableView.delegate = tableViewHandler
        tableView.reloadData()
    }
}

extension OrderListViewController {
    private func updateTableViewDatasource(list: [Product]) {
        self.tableViewDatasource = OrderListTableViewDataSource(list: list)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.dataSource = self?.tableViewDatasource
            self?.tableView.reloadData()
        }
    }
}
