//
//  OrderViewModel.swift
//  Starbucks
//
//  Created by 김상혁 on 2022/05/09.
//

import Foundation
import RxRelay
import RxSwift

protocol OrderViewModelAction {
    var loadCategory: PublishRelay<Void> { get }
    var tappedCategory: PublishRelay<Category.GroupType> { get }
    var tappedMenu: PublishRelay<Int> { get }
    var loadCategoryProducts: PublishRelay<String> { get }
    
}

protocol OrderViewModelState {
    var loadedCategory: PublishRelay<[Category.Group]> { get }
    var selectedCategory: PublishRelay<Category.GroupType> { get }
    var selectedMenu: PublishRelay<Category.Group> { get }
}

protocol OrderViewModelBinding {
    func action() -> OrderViewModelAction
    func state() -> OrderViewModelState
}

typealias OrderViewModelProtocol = OrderViewModelBinding

class OrderViewModel: OrderViewModelAction, OrderViewModelState, OrderViewModelBinding {
    
    func action() -> OrderViewModelAction { self }
    
    let loadCategory = PublishRelay<Void>()
    let tappedCategory = PublishRelay<Category.GroupType>()
    let tappedMenu = PublishRelay<Int>()
    let loadCategoryProducts = PublishRelay<String>()
    
    func state() -> OrderViewModelState { self }
    
    let loadedCategory = PublishRelay<[Category.Group]>()
    let selectedCategory = PublishRelay<Category.GroupType>()
    let selectedMenu = PublishRelay<Category.Group>()
    
    @Inject(\.starbucksRepository) private var starbucksRepository: StarbucksRepository
    
    private let disposeBag = DisposeBag()
    private var categoryMenu = Category.GroupType.allCases.reduce(into: [Category.GroupType: [Category.Group]]()) {
        $0[$1] = []
    }
    
    init() {
        
        // MARK: Repository에서 카테고리 Json 파일을 로드
        let requestCategory = action().loadCategory
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.starbucksRepository.requestCategory()
            }
            .share()
        
        //로드가 성공하면 여기 로직
        requestCategory
            .compactMap { result in result.value }        //값이 있는지 확인
            .map { groups in
                groups.reduce(into: self.categoryMenu) { category, group in
                    category[group.category]?.append(group)
                }
            } //값이 있으면 Array -> dic로 변환
            .withUnretained(self)           //weak self를 생략하기 위한 오퍼레이터
            .do { model, groups in model.categoryMenu = groups }    //모델의 dic에 값을 넣어주고
            .map { _ in .beverage }         //처음 보여질 테이블은 beverage이므로 값을 넘겨줌
            .bind(to: tappedCategory)       //tappedCategory 퍼블리시 실행
            .disposed(by: disposeBag)
        
        //로드가 실패하면 여기 로직
        Observable
            .merge(
                requestCategory.compactMap { $0.error }
            )
            .bind(onNext: {
                //TODO: error 처리
            })
            .disposed(by: disposeBag)
        
        action().tappedCategory             //카테고리 응답 오면 시작
            .withUnretained(self)
            .do { model, type in model.selectedCategory.accept(type) }      //선택한 카테고리 이벤트 알림
            .compactMap { model, type in model.categoryMenu[type] }         //선택한 카테고리 데이터 반환
            .bind(to: loadedCategory)                   //선택한 카테고리 데이터 전달
            .disposed(by: disposeBag)
        
        action().tappedMenu
            .withLatestFrom(tappedCategory) { [weak self] in
                self?.categoryMenu[$1]?[$0]
            }
            .compactMap { $0?.groupId }
            .bind(to: loadCategoryProducts)
            .disposed(by: disposeBag)
        
        // TODO: 아래 string 을 받는 Observable 을 이용하는 방법을 참조하자.
        let requestCategoryProduct = action().loadCategoryProducts
            .share()
//        loadedProducts
//            .withUnretained(self)
//            .flatMapLatest { model, ids in
//                Observable.zip( ids.map { id in
//                    model.starbucksRepository.requestDetail(id).asObservable()
//                        .compactMap { $0.value }
//                })
//            }
//            .map { $0.compactMap { $0.view } }
//            .bind(to: loadedRecommandMenu)
//            .disposed(by: disposeBag)
    }
}
