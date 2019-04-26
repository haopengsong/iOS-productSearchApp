//
//  MainTabBarController.swift
//  ebayProductSearch
//
//  Created by Haopeng Song on 4/25/19.
//  Copyright © 2019 Haopeng Song. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    var itemid : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(itemid)
        
        guard let viewControllers = viewControllers else {
            return
        }
        
        for viewController in viewControllers {
            if let infoNavController = viewController as? InfoNavigationController {
                
                if let infoviewController = infoNavController.viewControllers.first as? InforViewController {
                    infoviewController.itemID = self.itemid
                }
            }
        }
    }
}
