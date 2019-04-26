//
//  ShippingViewController.swift
//  ebayProductSearch
//
//  Created by Haopeng Song on 4/25/19.
//  Copyright © 2019 Haopeng Song. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner

class ShippingViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        getProductInfo()
    }
    
    func getProductInfo() {
        
        SwiftSpinner.show("Fetching Shipping Details...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //hide spinner after a sccessful call
            SwiftSpinner.hide()
        }
        //print(itemID)
    }
    
    @IBAction func gotoproduct(_ sender: Any) {
        SwiftSpinner.show("Back to Product...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //hide spinner after a sccessful call
            SwiftSpinner.hide()
        }
        dismiss(animated: true, completion: nil)
    }
}
