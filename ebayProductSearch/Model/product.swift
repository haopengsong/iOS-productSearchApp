//
//  product.swift
//  ebayProductSearch
//
//  Created by Haopeng Song on 4/25/19.
//  Copyright © 2019 Haopeng Song. All rights reserved.
//

import Foundation
import UIKit

class Product {
    
    var image: UIImage
    var title: String = ""
    var price: String = ""
    var shipping: String = ""
    var zipcode: String = ""
    var condition: String = ""
    var id: String = ""
    var shippingInfo = ShippingInfo(cost: "", location: "", handling: "", expediated: "", oneDay: "", returnAccept: "")
    var sellerInfo = SellerInfo(feedbackScore: "", popularity: "", feedbackRatingStar: "", topRated: "", storeName: "", storeUrl: "", userID: "")
    var seller : String = ""
    var inlist: String = ""
    
    
    init(image: UIImage, title: String, price: String, shipping: String, zipcode: String, condition: String,  id: String, shippingInfo: ShippingInfo, sellerInfo: SellerInfo, seller: String, inlist : String) {
        self.image = image
        self.title = title
        self.price = price
        self.shipping = shipping
        self.zipcode = zipcode
        self.condition = condition
        self.id = id
        self.shippingInfo = shippingInfo
        self.sellerInfo = sellerInfo
        self.seller = seller
        self.inlist = inlist
    }
    
}
