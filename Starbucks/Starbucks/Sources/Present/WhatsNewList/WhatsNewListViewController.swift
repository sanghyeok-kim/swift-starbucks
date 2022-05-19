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
    
    deinit {
        Log.info("Deinit WhatsNewListViewController")
    }
    
    private func bind() {
        rx.viewDidLoad
            .bind(to: viewModel.action().loadEvents)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.navigationController?.navigationBar.prefersLargeTitles = true

                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = .white
                appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

                vc.navigationController?.navigationBar.tintColor = .black
                //기본상태( 스크롤 있는 경우 아래로 이동했을 때 )
                vc.navigationController?.navigationBar.standardAppearance = appearance
                //가로화면으로 볼 때
                vc.navigationController?.navigationBar.compactAppearance = appearance
                //스크롤의 최 상단일 때
                vc.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            })
            .disposed(by: disposeBag)
        
        viewModel.state().updateEvents
            .bind(onNext: dataSource.updateEvents)
            .disposed(by: disposeBag)
        
        viewModel.state().reloadEvents
            .bind(onNext: tableView.reloadData)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        title = "What's New"
        view.backgroundColor = .white
        tableView.dataSource = dataSource
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
