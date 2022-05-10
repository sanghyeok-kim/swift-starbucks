//
//  RootWindow.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/09.
//

import RxSwift
import UIKit

class RootWindow: UIWindow {
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        overrideUserInterfaceStyle = .light
        rootViewController = StarbucksViewController()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
