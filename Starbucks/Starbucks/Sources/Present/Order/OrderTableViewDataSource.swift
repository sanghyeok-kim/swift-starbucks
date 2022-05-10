//
//  OrderTableViewDataSource.swift
//  Starbucks
//
//  Created by 김상혁 on 2022/05/10.
//

import UIKit

class OrderTableViewDataSource: NSObject, UITableViewDataSource {
    
    let mainLanguage = ["콜드브루", "블론드", "에스프레소"]
    let subLanguage = ["Cold Brew", "Blonde Coffe", "Young-Jin"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mainLanguage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
                as? OrderTableViewCell else {
                    return UITableViewCell()
                }
        
        cell.setMenuName(text: mainLanguage[indexPath.row])
        cell.setSubName(text: subLanguage[indexPath.row])
        return cell
    }
}
