//
//  PhotoInfoController.swift
//  ebayProductSearch
//
//  Created by Haopeng Song on 4/25/19.
//  Copyright © 2019 Haopeng Song. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner

class PhotoInfoController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        getProductInfo()
    }
    
    func getProductInfo() {
        
        SwiftSpinner.show("Fetching Photos...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //hide spinner after a sccessful call
            SwiftSpinner.hide()
        }
        //print(itemID)
    }
    
    
    @IBAction func goBackToProductDetails(_ sender: Any) {
        
    }
}
