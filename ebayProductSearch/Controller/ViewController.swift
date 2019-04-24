//
//  ViewController.swift
//  ebayProductSearch
//
//  Created by Haopeng Song on 4/17/19.
//  Copyright © 2019 Haopeng Song. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import McPicker

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //? -> optional
    //! -> always has a value
    //constants
    let ipAPI = "http://ip-api.com/json"
    let pickerData: [[String]] = [["All", "Art", "Baby", "Books", "Clothing, Shoes & Accessories", "Computers/Tablets & Networking", "Health & Beauty", "Music", "Video Games & Consoles"]]

    @IBOutlet weak var wishList: UISegmentedControl!
    @IBOutlet weak var searchView: UISegmentedControl!
    @IBOutlet weak var categoryTextField: McTextField!
    
    @IBOutlet weak var keyWord: UITextField!
    @IBOutlet weak var distanceMiles: UITextField!
    
    @IBOutlet weak var zipcodeField: UITextField!
    @IBOutlet weak var tbZipcode: UITableView!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    var zipcode: String = ""
    
    //userInput
    var userInputs = userInput()
    
    //buttons status
    var conditionButton = ButtonStatusModel()
    
    //autocomplete data list
    var zipList: [String] = []
    var tempzipList: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Product Search"
        //rounded button
        searchButton.layer.cornerRadius = 5.0
        searchButton.layer.masksToBounds = true
        
        clearButton.layer.cornerRadius = 5.0
        clearButton.layer.masksToBounds = true
        
        //load user input with button selection
        //userinput
        self.userInputs.buttonStatus = conditionButton
        
        //render UI
        self.getLocationZIPCODE()
        self.getCategory();
        
        //autocomplete
        zipList.append("test1")
        zipList.append("test2")
        zipList.append("test3")
        
        for str in zipList {
            tempzipList.append(str)
        }
        
        tbZipcode.delegate = self
        tbZipcode.dataSource = self
        
        zipcodeField.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
    }
    
    //search table elements
    @objc func searchRecords(_ textField: UITextField) {
        
    }
    
    //UItableViewDatasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zipList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "zipcode")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "zipcode")
        }
        cell?.textLabel?.text = zipList[indexPath.row]
        return cell!
    }
    
    @IBAction func searchFunc(_ sender: Any) {
        
    }
    
    @IBAction func clearFunc(_ sender: Any) {
        
    }
    
    //hide/show zipcode input field
    @IBAction func zipcodeInputField(_ sender: UISwitch) {
        if sender.isOn {
            zipcodeField.isHidden = false
        } else {
            zipcodeField.isHidden = true
        }
    }
    
    //Networking
    
    //JSON Parsing
    
    //UI Update
    
    //getLocationZIPCODE
    func getLocationZIPCODE() {
        Alamofire.request(ipAPI, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let locationJSON: JSON = JSON(response.result.value!)
                //userinput : zipcode from current location
                self.userInputs.zipcode = locationJSON["zip"].stringValue
                print("successfully got location data : " + locationJSON["zip"].stringValue)
            }
        }
    }
    
    //getCategory
    func getCategory() {
        let mcPicker = McPicker(data: pickerData)
        mcPicker.backgroundColor = .gray
        mcPicker.backgroundColorAlpha = 0.25
        categoryTextField.inputViewMcPicker = mcPicker
        categoryTextField.doneHandler = { [weak categoryTextField] (selections) in
            categoryTextField?.text = selections[0]!
        }
        categoryTextField.selectionChangedHandler = { [weak categoryTextField] (selections, componentThatChanged) in
            categoryTextField?.text = selections[componentThatChanged]!
            if let text: String = categoryTextField?.text {
                print("selection : " + text)
                //userinput : category selection
                self.userInputs.category = text
            }
        }
        categoryTextField.textFieldWillBeginEditingHandler = { [weak categoryTextField] (selections) in
            if categoryTextField?.text == "" {
                categoryTextField?.text = selections[0]
            }
        }
    }
    
    //Condition button pressed
    
    @IBAction func conditionButtonPressed(_ sender: UIButton) {
        print(sender.tag)
        if sender.tag == 0 {
            if (sender.currentImage?.isEqual(UIImage(named: "checked")))! {
                sender.setImage(UIImage(named: "unchecked"), for: .normal)
                conditionButton.newChecked = 1
            } else {
                sender.setImage(UIImage(named: "checked"), for: .normal)
                conditionButton.newChecked = 0
            }
        } else if sender.tag == 1 {
            if (sender.currentImage?.isEqual(UIImage(named: "checked")))! {
                sender.setImage(UIImage(named: "unchecked"), for: .normal)
                conditionButton.usedChecked = 1
            } else {
                sender.setImage(UIImage(named: "checked"), for: .normal)
                conditionButton.usedChecked = 0
            }
        } else if sender.tag == 2 {
            if (sender.currentImage?.isEqual(UIImage(named: "checked")))! {
                sender.setImage(UIImage(named: "unchecked"), for: .normal)
                conditionButton.unspecChecked = 1
            } else {
                sender.setImage(UIImage(named: "checked"), for: .normal)
                conditionButton.usedChecked = 0
            }
        }
    }
    
    //shipping button pressed
    @IBAction func shippingButtonPressed(_ sender: UIButton) {
        print(sender.tag)
        if sender.tag == 3 {
            if (sender.currentImage?.isEqual(UIImage(named: "checked")))! {
                sender.setImage(UIImage(named: "unchecked"), for: .normal)
                conditionButton.pickupChecked = 1
            } else {
                sender.setImage(UIImage(named: "checked"), for: .normal)
                conditionButton.pickupChecked = 0
            }
        } else if sender.tag == 4 {
            if (sender.currentImage?.isEqual(UIImage(named: "checked")))! {
                sender.setImage(UIImage(named: "unchecked"), for: .normal)
                conditionButton.freeShipping = 1
            } else {
                sender.setImage(UIImage(named: "checked"), for: .normal)
                conditionButton.freeShipping = 0
            }
        }
    }
    
    
    
    //Write didFailWithError
    
    //Change City Delegate
    
    //Write PrepareForSegue
    
    
}

