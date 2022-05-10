//
//  DetailOrderViewController.swift
//  Starbucks
//
//  Created by 김상혁 on 2022/05/10.
//

import UIKit

class OrderListViewController: UIViewController {

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
    }
    
    private func attribute() {
        view.backgroundColor = .systemBackground
    }
}
