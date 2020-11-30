//
//  UpdateUserModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation
import RxSwift

/**
 * ユーザ情報更新
 */
public struct UpdateUserModel {

    public init() {
    }

    /**
     * ユーザ情報更新
     * - Parameters:
     *   - authToken: 認証トークン
     *   - userName: ユーザ名
     * - Returns: ユーザ情報更新Entity Observable
     */
    public func putUser(authToken: String, userName: String) -> Observable<PutUserResponse.Entity> {

        return Observable.create({ observer in

            let req = PutUserRequest(authToken: authToken, userName: userName)

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
