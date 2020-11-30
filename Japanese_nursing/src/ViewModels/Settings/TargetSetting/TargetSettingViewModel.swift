//
//  TargetSettingViewModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/**
 * 目標設定画面のViewModel
 */
class TargetSettingViewModel {

    func fetch(authToken: String, targetLearningCount: Int?, targetTestingCount: Int?) -> Observable<Void> {

        return UpdateTargetModel().putTargets(authToken: authToken, targetLearningCount: targetLearningCount, targetTestingCount: targetTestingCount)
            .do(onError: {
                log.error($0.descriptionOfType)
            })
            .map { _ in () }
    }

}
