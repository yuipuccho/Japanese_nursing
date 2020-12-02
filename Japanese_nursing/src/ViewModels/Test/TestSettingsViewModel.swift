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

    /// テスト履歴を更新する
    func postTestHistories() -> Observable<Void> {

        let correctIds = arrayToString(array: ApplicationConfigData.correctIdsArray)
        let mistakeIds = arrayToString(array: ApplicationConfigData.mistakeIdsArray)

        return PostTestHistoriesModel().postTestHistories(authToken: ApplicationConfigData.authToken,
                                                          correctIds: correctIds,
                                                          mistakeIds: mistakeIds)
            .do(onError: {
                log.error($0.descriptionOfType)
            })
            .map { _ in () }
    }

    /// 配列を文字列に変換する(テスト履歴のPostで使用)
    private func arrayToString(array: [String]) -> String {
        var str = ""
        for i in array {
            str = str + "," + i
        }
        return String(str.dropFirst(1))
    }

}
