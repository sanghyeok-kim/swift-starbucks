//
//  OrderDetailViewController.swift
//  Starbucks
//
//  Created by YEONGJIN JANG on 2022/05/10.
//

import RxSwift
import SnapKit
import UIKit

enum Constant {
    static let titleSize: CGFloat = 32
    static let productDetailInfoSize: CGFloat = 16
    static let kiloCaloriesSize: CGFloat = 17
}

class OrderDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: OrderDetailViewModelProtocol
    
    // MARK: 바탕부
    private let contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    private let backgroundScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    // MARK: 상단부
    private let productImage: UIImageView  = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "pencil")
        imageView.image = image
        return imageView
    }()
    
    // MARK: 중단
    private let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()
    
    private let productName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.titleSize, weight: .bold)
        label.text = "나이트로 바닐라 크림"
        return label
    }()
    
    private let productEnglishName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.productDetailInfoSize, weight: .light)
        label.text = "Nitro Vanila Cream"
        return label
    }()
    
    private let content: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.productDetailInfoSize, weight: .regular)
        label.text = """
                진하고 깊은 풍미의 나이트로
                바닐라 크림을 즐겨보세요
                """
        return label
    }()
    
    private let price: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.titleSize, weight: .bold)
        label.text = "5900원"
        return label
    }()
    
    private let descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: 상세 영양 정보표
    private let caloriesNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.productDetailInfoSize, weight: .light)
        label.text = "칼로리"
        return label
    }()
    
    private let caloriesDecimalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.kiloCaloriesSize, weight: .light)
        label.text = "150kcal"
        return label
    }()
    
    private let caloriesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .red
        return stackView
    }()
    
    private let carbohydrateNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.productDetailInfoSize, weight: .light)
        label.text = "탄수화물"
        return label
    }()
    
    private let carbohydrateDecimalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.kiloCaloriesSize, weight: .light)
        label.text = "20g"
        return label
    }()
    
    private let carbohydrateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .yellow
        return stackView
    }()
    
    private let nutritionStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    init(viewModel: OrderDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        attribute()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        rx.viewDidAppear
            .map { _ in }
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.navigationController?.isNavigationBarHidden = false
                vc.tabBarController?.tabBar.isHidden = true
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        
        view.addSubview(backgroundScrollView)
        backgroundScrollView.addSubview(contentView)
        contentView.addArrangedSubview(productImage)
        contentView.addArrangedSubview(descriptionStackView)
        contentView.addArrangedSubview(nutritionStackView)
        descriptionStackView.addArrangedSubview(productName)
        descriptionStackView.addArrangedSubview(productEnglishName)
        descriptionStackView.addArrangedSubview(content)
        descriptionStackView.addArrangedSubview(price)
        
        nutritionStackView.addArrangedSubview(caloriesStackView)
        nutritionStackView.addArrangedSubview(carbohydrateStackView)
        
        caloriesStackView.addArrangedSubview(caloriesNameLabel)
        caloriesStackView.addArrangedSubview(caloriesDecimalLabel)
        carbohydrateStackView.addArrangedSubview(carbohydrateNameLabel)
        carbohydrateStackView.addArrangedSubview(carbohydrateDecimalLabel)
        
        backgroundScrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.top.bottom.equalTo(backgroundScrollView)
            $0.leading.trailing.equalTo(backgroundScrollView).inset(20)
            $0.width.equalTo(backgroundScrollView)
        }

        productImage.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(contentView)
            $0.height.equalTo(300)
        }

        descriptionStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView)
        }
        
        nutritionStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView)
        }
    }
}
