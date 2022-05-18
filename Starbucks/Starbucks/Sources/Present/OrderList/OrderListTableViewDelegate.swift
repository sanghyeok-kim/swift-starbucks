//
//  OrderListTableViewDelegate.swift
//  Starbucks
//
//  Created by YEONGJIN JANG on 2022/05/17.
//

import Foundation
import RxRelay
import RxSwift

class OrderListTableViewDelegate: NSObject, UITableViewDelegate {
    
    let selectedCellIndex = PublishSubject<Int>()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndex
            .onNext(indexPath.row)
    }
}
