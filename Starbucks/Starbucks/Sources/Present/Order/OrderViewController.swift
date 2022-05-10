//
//  OrderViewController.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/09.
//

import RxAppState
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class OrderViewController: UIViewController {
    
    private let tableView = UITableView()
    private let tableViewDataSource = OrderTableViewDataSource()
    private let tableViewDe1232131legate32132213213213 = OrderTableViewDelegate()
    
    private let orderLabel: UILabel = {
        let label = UILabel()
        label.text = "Order"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let categoryView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    private let categoryButtons: [UIButton] = {
        Category.allCases.map {
            let button = UIButton()
            button.setTitle($0.name, for: .normal)
            button.setTitleColor(.systemGray, for: .normal)
            return button
        }
    }()
    
    private let viewModel: OrderViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: OrderViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        attribute()
        layout()
        
//        tableViewDe1232131legate32132213213213.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        rx.viewDidLoad
            .bind(to: viewModel.action().viewDidLoad)
            .disposed(by: disposeBag)
        
        viewModel.state().test
            .bind(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        tableViewDe1232131legate32132213213213.selectedCellIndex
            .bind(to: tableViewDataSource.receiver)
            .disposed(by: disposeBag)
        
        tableViewDataSource.sender
            .bind {
                let detailOrderView = DetailOrderViewController(title: $0)
                self.navigationController?.pushViewController(detailOrderView, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .systemBackground
        configureTableView()
    }
    
    private func layout() {
        view.addSubview(orderLabel)
        view.addSubview(categoryView)
        categoryView.addSubview(categoryStackView)
        
        view.addSubview(tableView)
        
        categoryButtons.forEach {
            categoryStackView.addArrangedSubview($0)
        }
        
        orderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        categoryView.snp.makeConstraints {
            $0.top.equalTo(orderLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(-1)
            $0.bottom.equalTo(categoryStackView)
        }
        
        categoryStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(45)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureTableView() {
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.identifier)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDe1232131legate32132213213213
    }
}

extension OrderViewController: CellSelectionDetectable {
    func didSelectCell(indexPath: IndexPath) {
        print(tableViewDataSource.mainLanguage[indexPath.row])
    }
}

enum Category: CaseIterable {
    case beverage, food, product
    
    var name: String {
        switch self {
        case .beverage:
            return "음료"
        case .food:
            return "푸드"
        case .product:
            return "상품"
        }
    }
}
