//
//  Session+RxSwift.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/14.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation
import RxSwift

/**
 * Session for using RxSwift extension
 * - Url: https://qiita.com/natmark/items/5d8cd792d5aae364842f
 */
extension Session {

    /**
     * APIKit send action on RxSwift Observable
     * - Parameters:
     *   - request: Request object as APIKit
     */
    public func rx_sendRequest<T: Request>(_ request: T) -> Observable<T.Response> {
        return Observable.create { observer in
            let task = self.send(request) { result in
                switch result {
                case .success(let response):
                    observer.on(.next(response))
                    observer.on(.completed)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }

    /**
     * APIKit send action on RxSwift Observable
     * - Parameters:
     *   - request: Request object as APIKit
     */
    public class func rx_sendRequest<T: Request>(_ request: T) -> Observable<T.Response> {
        return shared.rx_sendRequest(request)
    }

}
