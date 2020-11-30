//
//  UserNameSettingViewModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/**
 * ユーザ名設定画面のViewModel
 */
class UserNameSettingViewModel {

    func fetch(authToken: String, userName: String) -> Observable<Void> {

        return UpdateUserModel().putUser(authToken: authToken, userName: userName)
            .do(onError: {
                log.error($0.descriptionOfType)
            })
            .map { _ in () }
    }

}
