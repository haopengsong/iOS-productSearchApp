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
import SwiftyJSON
import Toast_Swift

protocol canReceive {
    func dataReceived(data: userInput)
}

class productViewController: UIViewController {
    
    //@IBOutlet weak var wishListButton: UIButton!
    @IBOutlet weak var productTableView: UITableView!
    
    var rowSelected = 0
    
    var delegate : canReceive?
    var userInputData = userInput()
    
    var productDict: [String : Product] = [:]
    var productDictRowToCell: [Int : Product] = [:]
    
    var productWishList :  [String : Product] = [:]
    
    let alert = UIAlertController(title: "No Results!", message: "Failed to fetch search results", preferredStyle: .alert)
    
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Results"
        
        productTableView.delegate = self
        productTableView.dataSource = self

        //get data from call api
        getProducts()
        
        // Do any additional setup after loading the view.
        
    }
    
    
   
    
    func createProductArray(data: JSON)  {
        //no results handling
//        print(data["findItemsAdvancedResponse"].exists())
//        print(data["findItemsAdvancedResponse"][0]["ack"][0].stringValue)
//        print(data["findItemsAdvancedResponse"][0]["searchResult"][0]["@count"].stringValue)
        self.products.removeAll()
        self.productDict.removeAll()
        self.productDictRowToCell.removeAll()
    
        if data["findItemsAdvancedResponse"].exists() == false ||
            data["findItemsAdvancedResponse"][0]["ack"][0].stringValue != "Success" ||   data["findItemsAdvancedResponse"][0]["searchResult"][0]["@count"].stringValue == "0" {
            self.showAlerts()
            return
        }
        let productArray: JSON = data["findItemsAdvancedResponse"][0]["searchResult"][0]["item"]
        for (key , subJSON) : (String, JSON) in productArray {
            //image
            //print(subJSON)
            let imageURL = URL(string: subJSON["galleryURL"][0].stringValue)
            let imageData = try? Data(contentsOf: imageURL!)
            
            //title
            let title = subJSON["title"][0].stringValue
            
            //price
            //print(subJSON["sellingStatus"][0]["currentPrice"][0]["__value__"])
            let price = subJSON["sellingStatus"][0]["currentPrice"][0]["__value__"].stringValue
            
            //shipping
            var shippingOption = ""
            if subJSON["shippingInfo"][0]["shippingServiceCost"][0]["__value__"] == "0.0" {
                shippingOption = "Free Shipping"
                //shippinginfo cost
            } else {
                shippingOption = "$" + subJSON["shippingInfo"][0]["shippingServiceCost"][0]["__value__"].stringValue
                //shippinginfo cost
            }
            
            //condition
            var condition = ""
            let conditionid = subJSON["condition"][0]["conditionId"][0].intValue
            if conditionid == 1000 {
                condition = "NEW"
            } else if conditionid == 2000 || conditionid == 2500 {
                condition = "REFURBISHED"
            } else if conditionid >= 3000 && conditionid <= 6000 {
                condition = "USED"
            } else {
                condition = "NA"
            }
            
            let shippingLocation = subJSON["shippingInfo"][0]["shipToLocations"][0].stringValue
            let handling = subJSON["shippingInfo"][0]["handlingTime"][0].intValue > 1 ?   subJSON["shippingInfo"][0]["handlingTime"][0].stringValue + " Days" : subJSON["shippingInfo"][0]["handlingTime"][0].stringValue + " Day"
            
            let expediated = subJSON["shippingInfo"][0]["expeditedShipping"][0].stringValue
            let oneDay = subJSON["shippingInfo"][0]["oneDayShippingAvailable"][0].stringValue
            
            //return
            let returnAccept = subJSON["returnsAccepted"][0].stringValue
            
            //zip
            let zip = subJSON["postalCode"][0].stringValue
            
            //seller
            let seller = subJSON["sellerInfo"][0]["sellerUserName"][0].stringValue
            let feedbackScore = subJSON["sellerInfo"][0]["feedbackScore"][0].stringValue
            let popularity = subJSON["sellerInfo"][0]["positiveFeedbackPercent"][0].stringValue
            let feedbackRatingStar = subJSON["sellerInfo"][0]["feedbackRatingStar"][0].stringValue
            let topRated = subJSON["sellerInfo"][0]["topRatedSeller"][0].stringValue
            let userID = subJSON["sellerInfo"][0]["sellerUserName"][0].stringValue
            
            //item id
            let itemid = subJSON["itemId"][0].stringValue
            
            let inlist = "wishListEmpty"
            let shippingInfo = ShippingInfo(cost: shippingOption, location: shippingLocation, handling: handling, expediated: expediated, oneDay: oneDay, returnAccept: returnAccept)
            let sellerInfo = SellerInfo(feedbackScore: feedbackScore, popularity: popularity, feedbackRatingStar: feedbackRatingStar, topRated: topRated, storeName: "", storeUrl: "", userID: userID)
            let oneProduct = Product(image: UIImage(data: imageData!)!, title: title, price: price, shipping: shippingOption, zipcode: zip, condition : condition  ,id: itemid, shippingInfo: shippingInfo, sellerInfo: sellerInfo, seller: seller, inlist: inlist)
            
            self.products.append(oneProduct)
            self.productDict[itemid] = oneProduct
            self.productDictRowToCell[Int(key)!] = oneProduct
            
        }
        print("finished loading products")
       
    }
    
    func showAlerts() {
        self.alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(self.alert, animated: true)
    }
    
    func getProducts() {
        //start searching
        SwiftSpinner.show("Searching...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //hide spinner after a sccessful call
            SwiftSpinner.hide()
        }
        let findingURL = self.getFindingServiceURL(data: self.userInputData)
        Alamofire.request(findingURL, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let findingResult: JSON = JSON(response.result.value!)
                //print(findingResult)
                //load products from JSON
                //self.showAlerts()
                self.createProductArray(data: findingResult)
                self.productTableView.reloadData()
            }
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
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension productViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as! productCellTableViewCell
        
        cell.setProduct(product: product)
        
        cell.wishListButton.addTarget(self, action: #selector(wishListPressed(sender:)), for: .touchUpInside)
        cell.wishListButton.tag = Int(product.id)!
        return cell

    }
    
    @objc func wishListPressed(sender: UIButton) {
        print(sender.tag)
        if (sender.currentImage?.isEqual(UIImage(named: "wishListEmpty")))! {
            sender.setImage(UIImage(named: "wishListFilled"), for: .normal)
            
            if productWishList["\(sender.tag)"] == nil {
                self.view.makeToast( self.productDict["\(sender.tag)"]!.title + " was added to the wishList")
                productWishList["\(sender.tag)"] = self.productDict["\(sender.tag)"]
            }
            
        } else {
            sender.setImage(UIImage(named: "wishListEmpty"), for: .normal)
            if productWishList["\(sender.tag)"] != nil {
                self.view.makeToast( self.productDict["\(sender.tag)"]!.title + " was removed from the wishList")
                productWishList.removeValue(forKey: "\(sender.tag)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(products.count)
        return products.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("go to tab view")
        self.rowSelected = indexPath.row
        performSegue(withIdentifier: "goToTabView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTabView" {
            let thirdVC = segue.destination as! MainTabBarController
            
            thirdVC.itemid = self.productDictRowToCell[self.rowSelected]!.id
        }
    }
}
