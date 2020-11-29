//
//  MypageViewModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/**
 * マイページのViewModel
 */
class MypageViewModel {

    // MARK: - Properties

    private let loadingRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    var loadingDriver: Driver<Bool> {
        return loadingRelay.asDriver()
    }

    var isLoading: Bool {
        loadingRelay.value
    }

    // MARK: - Functions
    
    func fetch(authToken: String) -> Observable<TargetStatusDomainModel> {

        return TargetStatusModel().getTargetStatus(authToken: authToken)
            .do(onCompleted: {[weak self] in
                self?.loadingRelay.accept(false)
            }, onSubscribed: { [weak self] in
                self?.loadingRelay.accept(true)
            })
            .map { TargetStatusDomainModel(entity: $0) }
    }

}
