//
//  OrderDetailViewController.swift
//  Starbucks
//
//  Created by YEONGJIN JANG on 2022/05/10.
//

import RxSwift
import UIKit

class OrderDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()

    init() {
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
        rx.viewDidAppear
            .map { _ in }
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.navigationController?.isNavigationBarHidden = false
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
    }
    
    private func layout() {
    }
}
