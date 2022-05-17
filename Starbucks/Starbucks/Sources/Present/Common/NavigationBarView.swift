//
//  NavigationBarView.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/17.
//

import UIKit

class NavigationBarView: UIView {
    
    private let navigationView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.alpha = 0
        return label
    }()
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        attribute()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Init with coder is unavailable")
    }
    
    private func attribute() {
        backgroundColor = .white
    }
    
    private func layout() {
        let topSafeAreaInset = UIApplication.shared.windows[0].safeAreaInsets.top
        
        addSubview(navigationView)
        navigationView.addSubview(titleLabel)
        
        navigationView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(topSafeAreaInset)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(topSafeAreaInset)
        }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setAlpha(_ alpha: CGFloat) {
        titleLabel.alpha = alpha
    }
}
