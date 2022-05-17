//
//  CardListItemView.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/17.
//

import RxSwift
import UIKit

class CardListViewCell: UICollectionViewCell {
    static let identifier = "CardListItemView"
    
    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 5.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
        return view
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let cardImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .regular)
        return label
    }()
    
    private let barcodeView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black.withAlphaComponent(0.5)
        return imageView
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let cashChargeButton: UIButton = {
        let button = UIButton()
        button.setTitle("충전하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        return button
    }()
    
    @Inject(\.imageManager) private var imageManager: ImageManager
    private let disposeBag = DisposeBag()
    private var timer: Timer?
    private var tappedChargeEvent: (() -> Void)?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Init with coder is unavailable")
    }

    private func bind() {
        cashChargeButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { cell, _ in cell.tappedChargeEvent?() })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
    }
    
    private func layout() {
        contentView.addSubview(shadowView)
        contentView.addSubview(borderView)
        borderView.addSubview(cardImage)
        borderView.addSubview(nameLabel)
        borderView.addSubview(amountLabel)
        borderView.addSubview(barcodeView)
        borderView.addSubview(timerLabel)
        borderView.addSubview(cashChargeButton)
        
        shadowView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalTo(cashChargeButton).offset(30)
        }
        
        borderView.snp.makeConstraints {
            $0.edges.equalTo(shadowView)
        }
        
        cardImage.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(cardImage.snp.width).multipliedBy(0.63)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(cardImage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        amountLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        barcodeView.snp.makeConstraints {
            $0.top.equalTo(amountLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(barcodeView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        cashChargeButton.snp.makeConstraints {
            $0.top.equalTo(timerLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setName(_ name: String) {
        nameLabel.text = name
    }
    
    func setAmount(_ amount: Int) {
        amountLabel.text = "\(amount)원"
    }
    
    func setThumbnail(url: URL) {
        imageManager.loadImage(url: url).asObservable()
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { cell, image in
                cell.cardImage.image = image
            })
            .disposed(by: disposeBag)
    }
    
    func startTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        let format = DateFormatter()
        format.dateFormat = "mm:ss"
        
        let endTimer = Date().addingTimeInterval(600)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            let diffTime = endTimer - Date().timeIntervalSince1970
            if diffTime.timeIntervalSince1970 < 0 {
                timer.invalidate()
                self?.timer = nil
                return
            }
            
            let timeText = format.string(from: diffTime)
            self?.timerLabel.attributedText = NSMutableAttributedString()
                .addStrings([
                    NSAttributedString.create("바코드 유효시간 "),
                    NSAttributedString.create(timeText, options: [.foreground(color: .starbuckGreen)])
                ])
        }
    }
    
    func registChargeEvent(_ event: @escaping () -> Void) {
        tappedChargeEvent = event
    }
}
