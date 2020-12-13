//
//  TestViewModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/12/02.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/**
 * テスト画面のViewModel
 */
class TestViewModel {

    // MARK: - Properties

    private let loadingRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    var loadingDriver: Driver<Bool> {
        return loadingRelay.asDriver()
    }

    var isLoading: Bool {
        loadingRelay.value
    }

    var testWords: [TestWordsDomainModel] = []

    // MARK: - Functions

    /// テスト状況の取得
    func fetch(questionRange: Int, limit: Int) -> Observable<[TestWordsDomainModel]> {

        return GetTestWordsModel().getTestWords(authToken: ApplicationConfigData.authToken, questionRange: questionRange, limit: limit)
            .do(onCompleted: {[weak self] in
                self?.loadingRelay.accept(false)
            }, onSubscribed: { [weak self] in
                self?.loadingRelay.accept(true)
            })
            .map { testWords in
                return testWords.tests.map(TestWordsDomainModel.init)
            }
            .do(onNext: { [weak self] in
                guard let _self = self else {
                    return
                }
                _self.testWords.append(contentsOf: $0)
            })
    }

}
