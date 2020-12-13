//
//  LearningUnitViewModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/**
 * 学習画面のViewModel
 */
class LearningUnitViewModel {

    // MARK: - Properties

    private let loadingRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    var loadingDriver: Driver<Bool> {
        return loadingRelay.asDriver()
    }

    var isLoading: Bool {
        loadingRelay.value
    }

    var allWords: [WordMastersDomainModel] = []
    var rememberWords: [WordMastersDomainModel] = []
    var notRememberWords: [WordMastersDomainModel] = []

    // MARK: - Functions

    func fetch(authToken: String, unitMasterId: Int) -> Observable<[WordMastersDomainModel]> {

        return GetWordMastersModel().getWordMasters(authToken: authToken, unitMasterId: unitMasterId)
            .do(onCompleted: {[weak self] in
                self?.loadingRelay.accept(false)
            }, onSubscribed: { [weak self] in
                self?.loadingRelay.accept(true)
            })
            .map { words in
                return words.word_masters.map(WordMastersDomainModel.init)
            }
            .do(onNext: { [weak self] in
                guard let _self = self else {
                    return
                }
                _self.allWords.append(contentsOf: $0)
                _self.rememberWords = _self.allWords.filter{ $0.isLearned }
                _self.notRememberWords = _self.allWords.filter{ !$0.isLearned }
            })
    }

}
