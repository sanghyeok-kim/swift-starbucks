//
//  SuggestionMenuCellView.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/11.
//

import RxSwift
import UIKit

class RecommandMenuCellView: UICollectionViewCell {
    static let identifier = "RecommandMenuCellView"
    
    private let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .brown
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = RecommandMenuViewController.Constants.cellSize.width / 2
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    @Inject(\.imageManager) private var imageManager: ImageManager
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Init with coder is unavailable")
    }

    private func layout() {
        addSubview(thumbnailView)
        addSubview(nameLabel)
        
        thumbnailView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(snp.width)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailView.snp.bottom).offset(13)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func setName(_ name: NSMutableAttributedString) {
        nameLabel.backgroundColor = .white
        nameLabel.attributedText = name
    }
    
    func setThumbnail(_ imageUrl: URL?) {
        guard let url = imageUrl else {
            return
        }
        
        imageManager.loadImage(url: url).asObservable()
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { cell, image in
                cell.thumbnailView.image = image
            })
            .disposed(by: disposeBag)
    }
    
    func emptyCell() {
        thumbnailView.backgroundColor = .black.withAlphaComponent(0.1)
    }
}
