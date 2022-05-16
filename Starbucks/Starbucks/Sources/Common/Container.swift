//
//  Container.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/11.
//

import Foundation

class Container {
    static var shared = Container()
    
    private init() { }
    
    lazy var starbucksRepository: StarbucksRepository = StarbucksRepositoryImpl()
    
    lazy var imageManager = ImageManager()
}
