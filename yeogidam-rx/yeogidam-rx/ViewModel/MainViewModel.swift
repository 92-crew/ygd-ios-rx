//
//  MainViewModel.swift
//  yeogidam-rx
//
//  Created by 이강욱 on 2023/01/08.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    let disposeBag = DisposeBag()
    var isFavoriteMode: BehaviorRelay<Bool> = .init(value: false)
    var smokingAreaRelay = PublishRelay<[Location]>()
    var apiManager = APIManager.shared
    func requestSmokingAreas() {
        apiManager.requestSmokingAreas()
            .subscribe(onNext: { locations in
            self.smokingAreaRelay.accept(locations)
        }).disposed(by: disposeBag)
    }
}
