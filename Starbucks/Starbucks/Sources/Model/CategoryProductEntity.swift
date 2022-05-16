//
//  CategoryProductEntity.swift
//  Starbucks
//
//  Created by YEONGJIN JANG on 2022/05/16.
//

import Foundation

struct CategoryProductEntity: Codable {
    let products: [Product]
}

// MARK: - Product
struct Product: Codable {
    let productCD, productNM, filePATH: String
    let imgUPLOADPATH: String

    enum CodingKeys: String, CodingKey {
        case productCD = "product_CD"
        case productNM = "product_NM"
        case filePATH = "file_PATH"
        case imgUPLOADPATH = "img_UPLOAD_PATH"
    }
}
