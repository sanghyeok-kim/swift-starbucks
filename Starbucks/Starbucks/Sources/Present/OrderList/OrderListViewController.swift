//
//  DetailOrderViewController.swift
//  Starbucks
//
//  Created by 김상혁 on 2022/05/10.
//

import UIKit
import RxSwift
import SnapKit

class OrderListViewController: UIViewController {

    let tableView = UITableView()
    let tableViewDatasource = OrderListTableViewDataSource()
    let tableViewHandler = OrderListTableViewDelegate()
    let viewModel: ListViewModelProtocol
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: ListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        attribute()
        // TODO: VM 에서 list 의 첫번째 값을 categoryLabel.text 에 저장
        layout()
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        tableViewHandler.selectedCellIndex
            .subscribe(onNext: {
                print($0)
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
