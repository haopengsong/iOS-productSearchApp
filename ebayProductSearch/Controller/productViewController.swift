//
//  productViewController.swift
//  ebayProductSearch
//
//  Created by Haopeng Song on 4/24/19.
//  Copyright © 2019 Haopeng Song. All rights reserved.
//

import UIKit
import SwiftSpinner
import Alamofire

protocol canReceive {
    func dataReceived(data: userInput)
}

class productViewController: UIViewController {
    
    var delegate : canReceive?
    var userInputData = userInput()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Results"
        
 
        //get data from call api
        getProducts()

        // Do any additional setup after loading the view.
        
    }
    
    func getProducts() {
        //start searching
        SwiftSpinner.show("Searching...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //hide spinner after a sccessful call
            var findingURL = self.getFindingServiceURL(data: self.userInputData)
            //Alamofire.request()
            SwiftSpinner.hide()
        }
    }
    
    func getFindingServiceURL(data: userInput) -> String {
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
