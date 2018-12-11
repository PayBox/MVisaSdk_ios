//
//  PBMVisaDelegate.swift
//  PBMvisaSdk
//
//  Created by Arman on 07.12.2018.
//  Copyright © 2018 Arman. All rights reserved.
//

import Foundation
import PayBoxSdk

public protocol PBMVisaDelegate {
    func onQrDetected(mVisa: MVisa?, cards: [Card]?)
    func onQrError(error: ErrorResponse)
    func onQrPayment(response: Response)
}





