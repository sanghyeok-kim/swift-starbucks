//
//  MainEventView.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/12.
//

import RxSwift
import UIKit

class MainEventViewController: UIViewController {
    
    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black.withAlphaComponent(0.5)
        return imageView
    }()
    
    private let eventButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    @Inject(\.imageManager) private var imageManager: ImageManager
    private let viewModel: MainEventViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: MainEventViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bind()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.state().loadedMainEventImage
            .withUnretained(self)
            .flatMapLatest { $0.imageManager.loadImage(url: $1).asObservable() }
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind(onNext: { vc, image in
                let size = vc.eventImageView.frame.size
                let aspect = (size.width / image.size.width)
                
                vc.eventImageView.image = image
                vc.eventImageView.snp.makeConstraints {
                    $0.height.equalTo(image.size.height * aspect)
                }
            })
            .disposed(by: disposeBag)
        
        eventButton.rx.tap
            .bind(to: viewModel.action().tappedEvent)
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        view.addSubview(eventImageView)
        view.addSubview(eventButton)
        
        view.snp.makeConstraints {
            $0.bottom.equalTo(eventImageView)
        }
        
        eventImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        eventButton.snp.makeConstraints {
            $0.edges.equalTo(eventImageView)
        }
    }
}
