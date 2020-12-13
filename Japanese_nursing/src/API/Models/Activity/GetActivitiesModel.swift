//
//  GetActivitiesModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation
import RxSwift

/**
 * アクティビティ取得
 */
public struct GetActivitiesModel {

    public init() {
    }

    /**
     * アクティビティ取得
     * - Parameters:
     *   - authToken: 認証トークン
     * - Returns: アクティビティ取得Entity Observable
     */
    public func getActivities(authToken: String) -> Observable<GetActivitiesResponse.Entity> {

        return Observable.create({ observer in

            let req = GetActivitiesRequest(authToken: authToken)

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
