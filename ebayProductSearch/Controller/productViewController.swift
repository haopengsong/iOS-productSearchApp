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

class productViewController: UITableViewController {
    
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
            Alamofire.request(findingURL, method: .get).responseJSON {
                response in
                if response.result.isSuccess {
                    
                }
            }
            SwiftSpinner.hide()
        }
    }
    
    func getFindingServiceURL(data: userInput) -> String {
        var findingURL = "http://571webhw7nodejs-env.myyyz4mkdb.us-west-2.elasticbeanstalk.com/api/finding?"
        findingURL += "keywords=" + data.keyword + "&"
        if data.category != "" {
            findingURL += "categoryId=" + data.category + "&"
        } else {
            findingURL += "categoryId=" + "None" + "&"
        }
        findingURL += "buyerPostalCode=" + data.zipcode + "&"
        
        //condition
        if data.buttonStatus.newChecked == 0 && data.buttonStatus.usedChecked == 0 && data.buttonStatus.unspecChecked == 0 {
            findingURL += "condition[new]=NoCondition&"
        } else {
            if data.buttonStatus.newChecked == 1 {
                findingURL += "condition[new]=true&"
            } else {
                findingURL += "condition[new]=false"
            }
            
            if data.buttonStatus.usedChecked == 1 {
                findingURL += "condition[used]=true&"
            } else {
                findingURL += "condition[used]=false&"
            }
            
            if data.buttonStatus.unspecChecked == 1 {
                findingURL += "condition[unspecified]=true&"
            } else {
                findingURL += "condition[unspecified]=false&"
            }
        }
        
        //shipping
        if data.buttonStatus.freeShipping == 0 && data.buttonStatus.pickupChecked == 0 {
            findingURL += "shipping[freeshipping]=NoShippingOption&"
        } else {
            if data.buttonStatus.freeShipping == 1 {
                findingURL += "shipping[freeshipping]=true&"
            } else {
                findingURL += "shipping[freeshipping]=false&"
            }
            
            if data.buttonStatus.pickupChecked == 1 {
                findingURL += "shipping[localpickup]=true&"
            } else {
                findingURL += "shipping[localpickup]=false&"
            }
        }
        
        //distance
        if data.distance == "" {
            findingURL += "distance=10"
        } else {
            if data.distance != "" {
                findingURL += "distance=" + data.distance
            } else {
                findingURL += "distance=10"
            }
        }
        print("findingURL: " + findingURL)
        return findingURL
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
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
