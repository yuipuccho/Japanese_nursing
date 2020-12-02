//
//  GetTestWordsModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/12/02.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation
import RxSwift

/**
 * テスト単語取得
 */
public struct GetTestWordsModel {

    public init() {
    }

    /**
     * テスト単語取得
     * - Parameters:
     *   - authToken: 認証トークン
     *   - questionRange: 出題範囲
     *   - limit: 出題数
     * - Returns: テスト単語Entity Observable
     */
    public func getTestWords(authToken: String, questionRange: Int, limit: Int) -> Observable<GetTestWordsResponse.Entity> {

        return Observable.create({ observer in

            let req = GetTestWordsRequest(authToken: authToken, questionRange: questionRange, limit: limit)

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
