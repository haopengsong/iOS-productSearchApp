//
//  shippingInfo.swift
//  ebayProductSearch
//
//  Created by Haopeng Song on 4/25/19.
//  Copyright © 2019 Haopeng Song. All rights reserved.
//

import Foundation
import UIKit

class ShippingInfo {
    var cost: String = ""
    var location: String = ""
    var handling: String = ""
    var expediated: String = ""
    var oneDay: String = ""
    var returnAccept: String = ""
    
    init(cost: String, location: String, handling: String, expediated: String, oneDay: String, returnAccept: String) {
        self.cost = cost
        self.location = location
        self.handling = handling
        self.expediated = expediated
        self.oneDay = oneDay
        self.returnAccept = returnAccept
    }
}
