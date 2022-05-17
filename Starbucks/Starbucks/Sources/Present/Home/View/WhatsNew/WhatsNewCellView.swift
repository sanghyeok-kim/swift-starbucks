//
//  WhatsNewCellView.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/12.
//

import RxSwift
import UIKit

class WhatsNewCellView: UICollectionViewCell {
    static let identifier = "WhatsNewCellView"
    
    private let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .brown
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black
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
        addSubview(titleLabel)
        
        let cellSize = frame.size
        let imageAspect = 480.0 / 720.0
        
        thumbnailView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(cellSize.width * imageAspect)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setThumbnail(url: URL) {
        imageManager.loadImage(url: url).asObservable()
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { cell, image in
                cell.thumbnailView.image = image
            })
            .disposed(by: disposeBag)
    }
}
