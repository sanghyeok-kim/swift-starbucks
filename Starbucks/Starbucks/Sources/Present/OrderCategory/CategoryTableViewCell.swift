//
//  OrderTableViewCell.swift
//  Starbucks
//
//  Created by 김상혁 on 2022/05/10.
//

import RxSwift
import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static var identifier: String { "\(self)" }
    
    private let menuImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    private let menuNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 3
        return stackView
    }()
    
    private let mainNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let subNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        return label
    }()
    
    @Inject(\.imageManager) private var imageManager: ImageManager
    private let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        selectionStyle = .none
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        contentView.addSubview(menuImageView)
        contentView.addSubview(menuNameStackView)
        menuNameStackView.addArrangedSubview(mainNameLabel)
        menuNameStackView.addArrangedSubview(subNameLabel)
        
        menuImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        
        menuNameStackView.snp.makeConstraints {
            $0.leading.equalTo(menuImageView.snp.trailing).offset(20)
            $0.centerY.equalTo(menuImageView.snp.centerY)
        }
    }
    
    func setMenuName(text: String) {
        mainNameLabel.text = text
    }
    
    func setSubName(text: String) {
        subNameLabel.text = text
    }
    
    func setThumbnail(url: URL) {
        imageManager.loadImage(url: url).asObservable()
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { cell, image in
                cell.menuImageView.image = image
            })
            .disposed(by: disposeBag)
    }
}
