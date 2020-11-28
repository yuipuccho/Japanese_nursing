//
//  CreateUserModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/28.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation
import RxSwift

/**
 * ユーザ作成
 */
public struct PostCreateUserModel {

    public init() {
    }

    /**
     * ユーザ作成
     * - Parameters:
     *   - isAnonymous: 匿名ユーザかどうか
     *   - userName: ユーザ名
     * - Returns: ユーザ作成Entity Observable
     */
    public func postCreateUser(isAnonymous: Bool, userName: String) -> Observable<PostCreateUserResponse.Entity> {

        return Observable.create({ observer in

            let req = PostCreateUserRequest(isAnonymous: isAnonymous, userName: userName)

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
