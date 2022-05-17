//
//  PayViewModel.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/15.
//

import AVFoundation
import RxRelay
import RxSwift

protocol PayViewModelAction {
    var tappedAddCard: PublishRelay<Void> { get }
    var startCamera: PublishRelay<Void> { get }
    var captureCamera: PublishRelay<Void> { get }
}

protocol PayViewModelState {
    var presentChargeView: PublishRelay<AVCaptureSession> { get }
    var isHiddenChargeView: PublishRelay<Bool> { get }
    var showChargeEffect: PublishRelay<Int> { get }
}

protocol PayViewModelBinding {
    func action() -> PayViewModelAction
    func state() -> PayViewModelState
}

protocol PayViewModelProperty {
    var cardListViewModel: CardListViewModelProtocol { get }
}

typealias PayViewModelProtocol = PayViewModelBinding & PayViewModelProperty

class PayViewModel: PayViewModelBinding, PayViewModelProperty, PayViewModelAction, PayViewModelState {
    func action() -> PayViewModelAction { self }
    
    let tappedAddCard = PublishRelay<Void>()
    let startCamera = PublishRelay<Void>()
    let captureCamera = PublishRelay<Void>()
    
    func state() -> PayViewModelState { self }
    
    let presentChargeView = PublishRelay<AVCaptureSession>()
    let isHiddenChargeView = PublishRelay<Bool>()
    let showChargeEffect = PublishRelay<Int>()
    
    let cardListViewModel: CardListViewModelProtocol = CardListViewModel()
    
    @Inject(\.cameraRepository) private var cameraReposition: CameraRepository
    private let disposeBag = DisposeBag()
    private let koreaCashMlModel = KoreaCash()
    
    init() {
        tappedAddCard
            .bind(to: cardListViewModel.action().tappedAddCard)
            .disposed(by: disposeBag)
        
        let requestCamera = cardListViewModel.action().tappedCashCharge
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.cameraReposition.startCamera(config: CameraSession.Config(), delegate: nil)
            }
            .compactMap { $0.value }
            .share()
        
        requestCamera
            .map { _ in false }
            .bind(to: isHiddenChargeView)
            .disposed(by: disposeBag)
        
        requestCamera
            .bind(to: presentChargeView)
            .disposed(by: disposeBag)

        let mlResult = captureCamera
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.cameraReposition.captureBuffer()
            }
            .withUnretained(self)
            .do { model, _ in
                model.cameraReposition.stopCamera()
            }
            .compactMap { model, buffer -> Int? in
                guard let buffer = buffer.value,
                    let cvBuffer = CMSampleBufferGetImageBuffer(buffer),
                      let mlPrediction = try? model.koreaCashMlModel.prediction(image: cvBuffer) else {
                    return nil
                }
                return Int(mlPrediction.classLabel)
            }
            .share()
        
        mlResult
            .bind(to: cardListViewModel.action().chargedCash)
            .disposed(by: disposeBag)
        
        mlResult
            .withUnretained(self)
            .do { model, _ in
                model.isHiddenChargeView.accept(true)
            }
            .map { $0.1 }
            .bind(to: showChargeEffect)
            .disposed(by: disposeBag)
    }
}
