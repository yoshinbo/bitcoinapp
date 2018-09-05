//
//  UtxoEntity.swift
//  bitcoinapp
//
//  Created by Yoshikazu Oda on 2018/09/05.
//  Copyright © 2018年 yoshinbo. All rights reserved.
//

import Foundation
import ObjectMapper

public struct UtxoEntity: Mappable {
    private(set) var address: String = ""
    private(set) var txid: String = ""
    private(set) var vout: Int = 0
    private(set) var scriptPubKey: String = ""
    private(set) var amount: Decimal = 0
    private(set) var satoshis: Int = 0
    private(set) var height: Int = 0
    private(set) var confirmations: Int = 0

    public init?(map: Map) {}

    public mutating func mapping(map: Map) {
        address <- map["address"]
        txid <- map["txid"]
        vout <- map["vout"]
        scriptPubKey <- map["scriptPubKey"]
        amount <- map["amount"]
        satoshis <- map["satoshis"]
        height <- map["height"]
        confirmations <- map["confirmations"]
    }
}
