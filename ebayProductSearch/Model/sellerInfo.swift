//
//  sellerInfo.swift
//  ebayProductSearch
//
//  Created by Haopeng Song on 4/25/19.
//  Copyright © 2019 Haopeng Song. All rights reserved.
//

import Foundation
import UIKit

class SellerInfo {
    var feedbackScore: String = ""
    var popularity: String = ""
    var feedbackRatingStar: String = ""
    var topRated: String = ""
    var storeName: String = ""
    var storeUrl: String = ""
    var userID: String = ""
    
    init(feedbackScore: String, popularity: String, feedbackRatingStar: String, topRated: String, storeName: String, storeUrl: String, userID: String) {
        self.feedbackScore = feedbackScore
        self.popularity = popularity
        self.feedbackRatingStar = feedbackRatingStar
        self.topRated = topRated
        self.storeName = storeName
        self.storeUrl = storeUrl
        self.userID = userID
    }
}
