//
//  UnitListViewModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/29.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/**
 * 単元一覧のViewModel
 */
class UnitListViewModel {

    func fetch(authToken: String) -> Observable<[UnitMastersDomainModel]> {

        return GetUnitMastersModel().getUnitMasters(authToken: authToken)
//            .map { UnitMastersDomainModel(entity: $0.unit_masters) }
            .map { units in
                return units.unit_masters.map(UnitMastersDomainModel.init)
            }
    }

}
