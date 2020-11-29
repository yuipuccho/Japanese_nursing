//
//  TargetStatusModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation
import RxSwift

/**
 * 目標達成状況取得
 */
public struct TargetStatusModel {

    public init() {
    }

    /**
     * 目標達成状況取得
     * - Parameters:
     *   - authToken: 認証トークン
     * - Returns: 目標達成状況取得Entity Observable
     */
    public func getTargetStatus(authToken: String) -> Observable<GetTargetStatusResponse.Entity> {

        return Observable.create({ observer in

            let req = GetTargetStatusRequest(authToken: authToken)

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
