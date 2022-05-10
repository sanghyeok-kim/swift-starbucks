//
//  OrderTableViewDataSource.swift
//  Starbucks
//
//  Created by 김상혁 on 2022/05/10.
//

import UIKit
import RxSwift
import RxRelay

struct Menu {
    var mainLanguageName: String
    var subLanguageName: String
}

class OrderTableViewDataSource: NSObject, UITableViewDataSource {
    
    let mainLanguage = ["콜드브루", "블론드", "에스프레소"]
    let subLanguage = ["Cold Brew", "Blonde Coffe", "Young-Jin"]
    
    let receiver = PublishRelay<Int>()
    let sender = PublishRelay<String>()
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        
        receiver
            .compactMap { [weak self] in
                self?.mainLanguage[$0]
            }
            .bind(to: sender)
            .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = mainLanguage.count
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
                as? OrderTableViewCell else {
                    return UITableViewCell()
                }
        
        return configure(cell: cell, index: indexPath.row)
    }
    
    private func configure(cell: OrderTableViewCell, index: Int) -> UITableViewCell {
        setSelectedBackgroundView(of: cell)
        cell.setMenuName(text: mainLanguage[index])
        cell.setSubName(text: subLanguage[index])
        return cell
    }
    
    private func setSelectedBackgroundView(of cell: UITableViewCell) {
        let view = UIView()
        view.backgroundColor = .systemBackground
        cell.selectedBackgroundView = view
    }
}
