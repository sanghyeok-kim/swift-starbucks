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
    
    private let orderLabel: UILabel = {
        let label = UILabel()
        label.text = "Order"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("asd", for: .normal)
        return button
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
            .bind(to: viewModel.action().viewDidLoad)
            .disposed(by: disposeBag)
        
        viewModel.state().test
            .bind(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        button.rx.tap
            .bind(to: viewModel.action().viewDidLoad)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .systemBackground
    }
    
    private func layout() {
        view.addSubview(orderLabel)
        view.addSubview(button)
        
        orderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        button.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.top.equalTo(orderLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
    }
}
