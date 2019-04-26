//
//  productCellTableViewCell.swift
//  ebayProductSearch
//
//  Created by Haopeng Song on 4/25/19.
//  Copyright © 2019 Haopeng Song. All rights reserved.
//

import UIKit

class productCellTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productShipping: UILabel!
    @IBOutlet weak var productZipcode: UILabel!
    @IBOutlet weak var productCondition: UILabel!
    @IBOutlet weak var wishListButton: UIButton!
    
    
    func setProduct(product : Product) {
        productImageView.image = product.image
        productTitle.text = product.title
        productPrice.text = "$" + product.price
        productShipping.text = product.shipping
        productZipcode.text = product.zipcode
        productCondition.text = product.condition
    }

}
