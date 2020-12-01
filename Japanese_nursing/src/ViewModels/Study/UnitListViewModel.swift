//
//  UnitListViewModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/29.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/**
 * 単元一覧のViewModel
 */
class UnitListViewModel {

    // MARK: - Properties

    private let loadingRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    private let unitsRelay: BehaviorRelay<[UnitListSectionDomainModel]> = BehaviorRelay(value: [])

    var loadingDriver: Driver<Bool> {
        return loadingRelay.asDriver()
    }

    var unitsObservable: Observable<[UnitListSectionDomainModel]> {
        unitsRelay.asObservable()
    }

    var isLoading: Bool {
        loadingRelay.value
    }

    var units: [UnitListDomainModel] = []

    // MARK: - Functions

    func fetch(authToken: String) -> Observable<[UnitListDomainModel]> {

        return GetUnitMastersModel().getUnitMasters(authToken: authToken)
            .do(onCompleted: {[weak self] in
                self?.loadingRelay.accept(false)
            }, onSubscribed: { [weak self] in
                self?.loadingRelay.accept(true)
            })
            .map { units in
                return units.unit_masters.map(UnitListDomainModel.init)
            }
            .do(onNext: { [weak self] in
                guard let _self = self else {
                    return
                }
                _self.units = []
                _self.unitsRelay.accept([])
                _self.units.append(contentsOf: $0)
                let sections = UnitListSectionDomainModel(items: _self.units)
                _self.unitsRelay.accept([sections])
            })
    }

    /// 学習履歴を更新する
    func postLearningHistories() -> Observable<Void> {

        let rememberIds = arrayToString(array: ApplicationConfigData.rememberIdsArray)
        let notRememberIds = arrayToString(array: ApplicationConfigData.notRememberIdsArray)

        return PostLearningHistoriesModel().putUser(authToken: ApplicationConfigData.authToken, rememberIds: rememberIds, notRememberIds: notRememberIds)
            .do(onError: {
                log.error($0.descriptionOfType)
            })
            .map { _ in () }
    }

    /// 配列を文字列に変換する(学習履歴のPostで使用)
    private func arrayToString(array: [String]) -> String {
        var str = ""
        for i in array {
            str = str + "," + i
        }
        return String(str.dropFirst(1))
    }

}
