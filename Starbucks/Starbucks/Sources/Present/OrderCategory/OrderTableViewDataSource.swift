//
//  OrderTableViewDataSource.swift
//  Starbucks
//
//  Created by 김상혁 on 2022/05/10.
//

import UIKit
import RxRelay
import RxSwift

class OrderTableViewDataSource: NSObject, UITableViewDataSource {
    
    private let menus: [Menus]
    
    init(menus: [Menus]) {
        self.menus = menus
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath)
                as? CategoryTableViewCell else {
                    return UITableViewCell()
                }
        cell.setMenuName(text: menus[indexPath.row].name)
        cell.setSubName(text: menus[indexPath.row].name)
        return cell
    }
}
