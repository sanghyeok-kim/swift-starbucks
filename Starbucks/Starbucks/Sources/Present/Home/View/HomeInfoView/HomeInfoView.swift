//
//  HomeInfoView.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/12.
//

import RxRelay
import RxSwift
import UIKit

class HomeInfoView: UIView {
    
    private let infoView = UIView()
    
    private let backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "homeTopBg")
        return imageView
    }()
    
    private let gradientView: GradientView = {
        let view = GradientView()
        let colors = [
            UIColor(red: 1, green: 1, blue: 1, alpha: 1),
            UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        ]
        
        view.set(
            colors: colors,
            startPoint: CGPoint(x: 0.5, y: 1.0),
            endPoint: CGPoint(x: 0.5, y: 0)
        )
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let stickView = UIView()
    
    private let whatsNewButton: UIButton = {
        let button = UIButton()
        button.setTitle("What's New", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        return button
    }()
    
    private let bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.alpha = 0
        return view
    }()
    
    private let stickViewHeight: CGFloat
    private let disposeBag = DisposeBag()
    
    let tappedWhatsNewButton = PublishRelay<Void>()
    
    init(stickViewHeight: CGFloat) {
        self.stickViewHeight = stickViewHeight
        super.init(frame: .zero)
        bind()
        attribute()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        whatsNewButton.rx.tap
            .bind(to: tappedWhatsNewButton)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        backgroundColor = .white
    }
    
    private func layout() {
        addSubview(infoView)
        infoView.addSubview(backgroundView)
        infoView.addSubview(gradientView)
        infoView.addSubview(messageLabel)
        
        addSubview(stickView)
        stickView.addSubview(whatsNewButton)
        stickView.addSubview(bottomBar)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(stickView.snp.top)
        }
        
        messageLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
        }
        
        stickView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(stickViewHeight)
        }
        
        whatsNewButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        bottomBar.snp.makeConstraints {
            $0.top.equalTo(whatsNewButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func setMessage(_ message: String) {
        messageLabel.text = message
    }
    
    func setAlpha(_ alpha: CGFloat) {
        let rangeAlpha = alpha < 0 ? 0 : alpha
        infoView.alpha = rangeAlpha
        bottomBar.alpha = (1 - rangeAlpha) * 0.5
    }
}
