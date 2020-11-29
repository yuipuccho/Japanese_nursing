//
//  TestSettingsViewModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/29.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/**
 * テスト設定画面のViewModel
 */
class TestSettingsViewModel {

    // MARK: - Properties

    private let loadingRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    var loadingDriver: Driver<Bool> {
        return loadingRelay.asDriver()
    }

    var isLoading: Bool {
        loadingRelay.value
    }

    var units: [UnitListDomainModel] = []

    // MARK: - Functions

    func fetch(authToken: String) -> Observable<TestStatusDomainModel> {

        return TestStatusModel().getTestStatus(authToken: authToken)
            .do(onCompleted: {[weak self] in
                self?.loadingRelay.accept(false)
            }, onSubscribed: { [weak self] in
                self?.loadingRelay.accept(true)
            })
            .map { TestStatusDomainModel(entity: $0) }
    }

}
