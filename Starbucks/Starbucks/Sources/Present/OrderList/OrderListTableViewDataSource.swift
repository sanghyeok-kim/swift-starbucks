//
//  OrderListTableViewDataSource.swift
//  Starbucks
//
//  Created by 김상혁 on 2022/05/10.
//

import UIKit
import RxSwift
import RxRelay

class OrderListTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var list: [Product] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath)
                as? CategoryTableViewCell else {
                    return UITableViewCell()
                }
        let indexCell = list[indexPath.row]
        cell.setMenuName(text: indexCell.productName)
//        cell.setSubName(text: <#T##String#>)
        cell.setThumbnail(url: indexCell.completeUrl)
        return cell
    }
}
