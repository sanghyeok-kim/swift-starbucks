//
//  OrderTableViewDelegate.swift
//  Starbucks
//
//  Created by 김상혁 on 2022/05/10.
//

import UIKit

class OrderTableViewDelegate: NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}
