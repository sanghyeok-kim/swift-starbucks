//
//  OrderTableViewDataSource.swift
//  Starbucks
//
//  Created by 김상혁 on 2022/05/10.
//

import RxRelay
import RxSwift
import UIKit

class OrderTableViewDataSource: NSObject, UITableViewDataSource {
    
    private let menus: [Category.Group]
    
    init(menus: [Category.Group]) {
        self.menus = menus
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath)
                as? CategoryTableViewCell else {
                    return UITableViewCell()
                }
        cell.setMenuName(text: menus[indexPath.row].title)
        cell.setSubName(text: menus[indexPath.row].subTitle)
        cell.setThumbnail(url: menus[indexPath.row].imagePath)
        return cell
    }
}
