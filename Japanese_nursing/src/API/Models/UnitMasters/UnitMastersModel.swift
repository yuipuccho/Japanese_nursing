//
//  UnitMastersModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/29.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation
import RxSwift

/**
 * 単元一覧取得
 */
public struct GetUnitMastersModel {

    public init() {
    }

    /**
     * 単元一覧取得
     * - Parameters:
     *   - authToken: 認証トークン
     * - Returns: 単元一覧取得Entity Observable
     */
    public func getUnitMasters(authToken: String) -> Observable<GetUnitMastersResponse.Entity> {

        return Observable.create({ observer in

            let req = GetUnitMastersRequest(authToken: authToken)

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
