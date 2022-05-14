//
//  WhatsNewListViewCell.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/14.
//

import RxSwift
import UIKit

class WhatsNewListViewCell: UITableViewCell {
    
    enum Constant {
        static let imageWidth = 100.0
        static let imageAspect = 480.0 / 720.0
    }
    
    static let identifier = "WhatsNewListViewCell"
    
    private let thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray.withAlphaComponent(0.5)
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let newsDate: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    @Inject(\.imageManager) private var imageManager: ImageManager
    private let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Init with coder is unavailable")
    }
    
    private func attribute() {
        contentView.backgroundColor = .white
    }

    private func layout() {
        contentView.addSubview(thumbnail)
        contentView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(newsDate)
        
        contentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(thumbnail).offset(20)
        }
        
        thumbnail.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(Constant.imageWidth)
            $0.height.equalTo(Constant.imageWidth * Constant.imageAspect)
        }
        
        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnail.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalTo(thumbnail)
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setDate(_ date: String) {
        newsDate.text = date
    }
    
    func setThumbnail(_ url: URL?) {
        if let url = url {
            thumbnail.isHidden = false
            imageManager.loadImage(url: url).asObservable()
                .withUnretained(self)
                .observe(on: MainScheduler.asyncInstance)
                .bind(onNext: { cell, image in
                    cell.thumbnail.image = image
                })
                .disposed(by: disposeBag)
            thumbnail.snp.updateConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.width.equalTo(Constant.imageWidth)
            }
        } else {
            thumbnail.isHidden = true
            thumbnail.snp.updateConstraints {
                $0.leading.equalToSuperview().offset(0)
                $0.width.equalTo(0)
            }
        }
    }
}
