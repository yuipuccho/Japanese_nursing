//
//  PostLearningHistoriesModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/12/01.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation
import RxSwift

/**
 * 学習履歴更新
 */
public struct PostLearningHistoriesModel {

    public init() {
    }

    /**
     * 学習履歴更新
     * - Parameters:
     *   - authToken: 認証トークン
     *   - rememberIds: 覚えた単語のID配列
     *   - notRememberIds: 覚えていない単語のID配列
     * - Returns: 学習履歴Entity Observable
     */
    public func postLearningHistories(authToken: String, rememberIds: String, notRememberIds: String) -> Observable<PostLearningHistoriesResponse.Entity> {

        return Observable.create({ observer in

            let req = PostLearningHistoriesRequest(authToken: authToken, rememberIds: rememberIds, notRememberIds: notRememberIds)

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
