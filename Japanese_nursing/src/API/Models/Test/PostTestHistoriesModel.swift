//
//  PostTestHistoriesModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/12/02.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation
import RxSwift

/**
 * テスト履歴更新
 */
public struct PostTestHistoriesModel {

    public init() {
    }

    /**
     * テスト履歴更新
     * - Parameters:
     *   - authToken: 認証トークン
     *   - correctIds: 正解した単語のID配列
     *   - mistakeIds: 間違えた単語のID配列
     * - Returns: 学習履歴Entity Observable
     */
    public func postTestHistories(authToken: String, correctIds: String, mistakeIds: String) -> Observable<PostTestHistoriesResponse.Entity> {

        return Observable.create({ observer in

            let req = PostTestHistoriesRequest(authToken: authToken, correctIds: correctIds, mistakeIds: mistakeIds)

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
