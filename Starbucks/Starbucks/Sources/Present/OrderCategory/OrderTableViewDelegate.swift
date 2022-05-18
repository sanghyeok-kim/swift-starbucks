//
//  OrderTableViewDelegate.swift
//  Starbucks
//
//  Created by 김상혁 on 2022/05/10.
//

import RxRelay
import RxSwift
import UIKit

protocol CellSelectionDetectable: AnyObject {
    func didSelectCell(indexPath: IndexPath)
}

class OrderTableViewDelegate: NSObject, UITableViewDelegate {
    
    let selectedCellIndex = PublishSubject<Int>()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCellIndex
            .onNext(indexPath.row)
    }
}
