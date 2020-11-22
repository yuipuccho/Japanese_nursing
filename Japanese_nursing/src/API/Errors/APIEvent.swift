//
//  APIEvent.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/14.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import RxSwift

/**
 * API層のイベント監視用struct
 */
public struct APIEvent {

    /// イベント
    public enum Event: Int {
        /// ポイント不足時またはいいね不足時のエラーコード(error_code=8)
        /// ポイントまたはいいね不足時のエラーコード(error_code=8)
        case lackOfPointsOrLikes = 8
        /// 正常
        case normal = 200
        /// メンテナンス中
        case maintenance = 503
    }
    /// イベント用Subject
    private static let eventSubject = PublishSubject<Event>()

    /// 公開用Observable
    public static let eventObservable: Observable<Event> = eventSubject.asObservable()

    static func eventStream(event: Event) {
        eventSubject.onNext(event)
    }

}
