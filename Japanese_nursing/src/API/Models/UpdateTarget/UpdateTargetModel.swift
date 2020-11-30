//
//  UpdateTargetModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation
import RxSwift

/**
 * 目標更新
 */
public struct UpdateTargetModel {

    public init() {
    }

    /**
     * 目標更新
     * - Parameters:
     *   - authToken: 認証トークン
     *   - targetLearningCount: 目標学習数
     *   - targetTestingCount: 目標テスト数
     * - Returns: ユーザ作成Entity Observable
     */
    public func putTargets(authToken: String, targetLearningCount: Int?, targetTestingCount: Int?) -> Observable<PutTargetsResponse.Entity> {

        return Observable.create({ observer in

            let req = PutTargetsRequest(authToken: authToken, targetLearningCount: targetLearningCount, targetTestingCount: targetTestingCount)

            let task = Session.send(req) {
                switch $0 {
                case .success(let response):
                    guard let entity = response.object else {
                        observer.on(.error(APIError.entityNotExist))
                        return
                    }
                    observer.on(.next(entity))
                    observer.on(.completed)
                case .failure(let error):
                    observer.on(.error(error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        })
    }

}
