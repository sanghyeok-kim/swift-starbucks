//
//  OrderTableViewDelegate.swift
//  Starbucks
//
//  Created by 김상혁 on 2022/05/10.
//

import UIKit
import RxSwift
import RxRelay

protocol CellSelectionDetectable: AnyObject {
    func didSelectCell(indexPath: IndexPath)
}

class OrderTableViewDelegate: NSObject, UITableViewDelegate {
    
//    weak var delegate: CellSelectionDetectable?
    
    let selectedCellIndex = PublishSubject<Int>()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCellIndex
            .onNext(indexPath.row)
        //delegate가 indexPath를 발행해줌
        //dataSource가 indexPath를 받아야함
        //dataSource가 VC에게 indexPath에 있는 cell의 정보를 발행해줌
        //VC가 그 정보를 받아서 NavigationVC를 Push
        
//        print(indexPath.row)
//        delegate?.didSelectCell(indexPath: indexPath)
    }
}
