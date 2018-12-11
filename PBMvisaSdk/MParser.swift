//
//  MParser.swift
//  PBMvisaSdk
//
//  Created by Arman on 06.12.2018.
//  Copyright © 2018 Arman. All rights reserved.
//

import Foundation

open class MParser {
    
    public static let MVISA_AMOUNT_TAG = "54"
    public static let MVISA_MERCHANT_ID_TAG = "02"
    public static let MVISA_MERCHANT_NAME_TAG = "59"
    public static let MVISA_CURRENCY_CODE_TAG = "53"
    
    public static func decode(code: String) -> [String: String]? {
        var mvd = [String: String]()
        
            let tag = NSMutableString()
            let valLength = NSMutableString()
            let value = NSMutableString()
            var length = 0
            
            for index in 0...code.count-1 {
                if tag.length == 2 {
                    if valLength.length<2 {
                        valLength.append(String(Array(code)[index]))
                    } else {
                        if valLength.length == 2 {
                            if length == 0 {
                                length = Int(valLength.intValue)
                            }
                            if length != 0 {
                                value.append(String(Array(code)[index]))
                                length-=1
                                if length == 0 {
                                    mvd.updateValue(value as String, forKey: tag as String)
                                    tag.setString("")
                                    valLength.setString("")
                                    value.setString("")
                                }
                            }
                        }
                    }
                } else {
                    tag.append(String(Array(code)[index]))
                }
            }
       
        return mvd
    }
    
    public static func currencyBy(code: String) -> String?{
        guard let currency = Iso4217Code.init(rawValue: code) else {
            return nil
        }
        return "\(currency)"
    }
    
    enum Iso4217Code: String {
        case EUR = "978"
        case USD = "840"
        case AED = "784"
        case KGS = "417"
        case RUB = "643"
        case UZS = "860"
        case KZT = "398"
        case THB = "764"
        case CNY = "156"
        case TRY = "949"
        case UAH = "980"
        case BYN = "933"
        case HKD = "344"
        case ILS = "376"
        case GBP = "826"
    }
}
