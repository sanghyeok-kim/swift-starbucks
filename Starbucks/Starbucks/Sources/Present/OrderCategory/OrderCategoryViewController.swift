//
//  OrderCategoryViewController.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/09.
//

import RxAppState
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class OrderCategoryViewController: UIViewController {
    
    private let tableView = UITableView()
    private var tableViewDataSource: OrderTableViewDataSource?
    private let tableViewHandler = OrderTableViewDelegate()
    
    private let orderLabel: UILabel = {
        let label = UILabel()
        label.text = "Order"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let backBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        barButtonItem.tintColor = .systemGray
        return barButtonItem
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
        Category.GroupType.allCases.map {
            let button = UIButton()
            button.setTitle($0.name, for: .normal)
            button.setTitleColor(.black, for: .selected)
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
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        rx.viewDidLoad
            .bind(to: viewModel.action().loadCategory)
            .disposed(by: disposeBag)
        
        viewModel.state().loadedCategory
            .bind(onNext: { menu in
                self.updateDatasource(menu: menu)
            })
            .disposed(by: disposeBag)
        
        tableViewHandler.selectedCellIndex
            .bind(to: viewModel.action().tapMenu)
            .disposed(by: disposeBag)
        
        viewModel.state().selectedCategory
            .map { $0.index }
            .bind(onNext: { selectIndex in
                self.categoryButtons.enumerated().forEach { index, button in
                    button.isSelected = index == selectIndex
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.state().loadedList
            .withUnretained(self)
            .subscribe(onNext: { model, list in
                let viewModel = OrderListViewModel(list: list)
                let orderListVC = OrderListViewController(viewModel: viewModel)
                model.navigationItem.backBarButtonItem = model.backBarButtonItem
                model.navigationController?.pushViewController(orderListVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        categoryButtons.enumerated().forEach { index, button in
            button.rx.tap
                .compactMap { _ in
                    Category.GroupType.indexToCase(index)
                }
                .bind(to: viewModel.action().tappedCategory)
                .disposed(by: disposeBag)
        }
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
            $0.leading.equalToSuperview().offset(30)
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
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.delegate = tableViewHandler
    }
}

extension OrderCategoryViewController {
    private func updateDatasource(menu: [Category.Group]) {
        self.tableViewDataSource = OrderTableViewDataSource(menus: menu)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.dataSource = self?.tableViewDataSource
            self?.tableView.reloadData()
        }
    }
}
