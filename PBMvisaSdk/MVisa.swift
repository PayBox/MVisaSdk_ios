//
//  MVisa.swift
//  PBMvisaSdk
//
//  Created by Arman on 10.12.2018.
//  Copyright © 2018 Arman. All rights reserved.
//

import Foundation
public struct MVisa {
    public var currencyCode: String
    public var mVisaMerchantId: String
    public var merchantName: String
    public var amount: Float
    init(currencyCode: String, mVisaMerchantId: String, merchantName: String, amount: Float) {
        self.currencyCode = currencyCode
        self.mVisaMerchantId = mVisaMerchantId
        self.merchantName = merchantName
        self.amount = amount
    }
    
}
