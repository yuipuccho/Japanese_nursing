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

    var activities: [ActivitiesDomainModel] = []

    var activityCountArray: [Int] = []

    var dateArray: [String] = []

    // MARK: - Functions

    /// 目標達成状況取得
    func fetchTargetStatus(authToken: String) -> Observable<TargetStatusDomainModel> {

        return TargetStatusModel().getTargetStatus(authToken: authToken)
            .do(onCompleted: {[weak self] in
                self?.loadingRelay.accept(false)
            }, onSubscribed: { [weak self] in
                self?.loadingRelay.accept(true)
            })
            .map { TargetStatusDomainModel(entity: $0) }
    }

    /// アクティビティ取得
    func fetchActivities(authToken: String) -> Observable<[ActivitiesDomainModel]> {

        return GetActivitiesModel().getActivities(authToken: authToken)
            .do(onCompleted: {[weak self] in
                self?.loadingRelay.accept(false)
            }, onSubscribed: { [weak self] in
                self?.loadingRelay.accept(true)
            })
            .map { activity in
                return activity.activities.map(ActivitiesDomainModel.init)
            }
            .do(onNext: { [unowned self] in
                // 初期化
                activities = []
                activityCountArray = []
                dateArray = []
                activities.append(contentsOf: $0)
                addActivity(activities: activities)
            })
    }

    /// アクティビティを配列に追加
    private func addActivity(activities: [ActivitiesDomainModel]) {
        for i in activities {
            // アクティビティ数
            let count = i.learnedCount + i.testedCount
            activityCountArray.insert(count, at: 0)

            // 日付
            let d = i.date.toString("MM/dd")
            dateArray.insert(d, at: 0)
        }
    }

}
