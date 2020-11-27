//
//  CreateUserViewModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/22.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/**
 * ユーザ作成のViewModel
 */
class CreateUserViewModel {

    func fetch(isAnonymous: Bool, userName: String) -> Observable<CreateUserDomainModel> {

        return PostCreateUserModel().postCreateUser(isAnonymous: isAnonymous, userName: userName)
            .map { CreateUserDomainModel(entity: $0.body) }
            .do {
                // UserDefaultsに保存する
                ApplicationConfigData.userID = $0.id
                ApplicationConfigData.authToken = $0.authToken
                ApplicationConfigData.role = $0.role
                ApplicationConfigData.userName = $0.userName
                ApplicationConfigData.email = $0.email
            }
    }
    
}
