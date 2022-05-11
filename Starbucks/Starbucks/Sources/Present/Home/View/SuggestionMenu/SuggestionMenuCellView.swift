//
//  SuggestionMenuCellView.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/11.
//

import UIKit

class SuggestionMenuCellView: UICollectionViewCell {
    static let identifier = "SuggestionMenuCellView"
    
    private let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mockImage")
        imageView.backgroundColor = .brown
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = SuggestionMenuView.Constants.cellSize.width / 2
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "클래식 스콘"
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
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
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
