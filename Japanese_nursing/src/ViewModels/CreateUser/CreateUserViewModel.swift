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

    func fetch() -> Observable<CreateUserDomainModel> {

        return PostCreateUserModel().postCreateUser(isAnonymous: true, userName: "popo")
            .map { CreateUserDomainModel(entity: $0) }
    }
    
}
