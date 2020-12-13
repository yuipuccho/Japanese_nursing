//
//  JsonMappable.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/28.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

protocol JsonMappable {

    init?(json: Json)
}

extension JsonMappable {

    init?(anyJson: Any?) {
        guard let anyJ = anyJson as? Json else { return nil }
        self.init(json: anyJ)
    }
}

extension JsonMappable {

    static func mapping(_ json: [Json]) -> [Self] {
        return json.compactMap { Self.init(json: $0) }
    }
}
