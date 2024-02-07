//
//  ViewController.swift
//  ApiTesting
//
//  Created by hiren ghoniya on 06/02/24.


//https://www.json4swift.com/
//https://app.quicktype.io/

import UIKit
import Foundation
import Alamofire
import CoreData


class ViewController: UIViewController {
    
    var array = [UserModel]()
    
    //    var arrPipValue = [PipValue]
    //    var pipvalueData = PipValueData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        ShowURLSessionData()
        
        //        ShowAlemofireData()
        
        directAlemofire()
    }
    
    //MARK: - without using afwreapper
    func directAlemofire() {
        AF.request("https://jsonplaceholder.typicode.com/todos").response { data in
            if let data = data.data {
                do {
                    // Decode JSON data into your model
                    let welcome = try JSONDecoder().decode([UserModel].self, from: data)
                    
                    self.array.append(contentsOf: welcome)
                    print(self.array)
                    
                    // Update UI on the main thread if needed
                    DispatchQueue.main.async {
                        // Update UI elements here
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }
    }
    
    //MARK: - datashowing with Alemofire
    func ShowAlemofireData() {
        // URL to fetch data from
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
            return
        }
        AFWrapper.GetMethod(params:[:], apikey: "\(url)") { (json) in
            let dict = json as! NSDictionary
            
            DispatchQueue.main.async {
                var rate = dict["rate"] as? Double
            }
            print(dict)
        } failure: { error in
            print(error.localizedDescription)
        }
        
        
    }
    
    // MARK: - DataShowing with URLSession
    func ShowURLSessionData() {
        // URL to fetch data from
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
            return
        }
        
        // Create a URLSession data task
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle response
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                // Decode JSON data into your model
                let welcome = try JSONDecoder().decode([UserModel].self, from: data)
                
                self.array.append(contentsOf: welcome)
                print(self.array)
                
                // Update UI on the main thread if needed
                DispatchQueue.main.async {
                    // Update UI elements here
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    //MARK: - for  save in to coredata
    
    //    func addPipValue(PipValueName: String) {
    //        pipvalueData.pipName = PipValueName
    //        pipvalueData.date = Date()
    //        pipvalueData.pipArray = self.array.mutableCopy() as! NSArray
    //        pipvalueData.timestamp = "\(Date().currentTimeMillis())"
    //        pipvalueData.noOfPips = IsNoOFPips
    //        let adddpip = PIPValueData().SavePipValue(context: self.context, PipV: pipvalueData)
    //        if adddpip {
    //            print("yess")
    //            Utils().showToast(context: self, msg: "Saved!")
    //        }
    //        else {
    //            print("Noooo")
    //        }
    //    }
    
    // MARK: -  for fetch coredata
    
    //    func FetchPipValueData() {
    //        PIPValueData().fetchPipValue(context: self.context) { arrpipvalue in
    //            self.arrpipvalue = arrpipvalue
    //            self.tbl_save.reloadData()
    //        }
    //    }
    
    // MARK: -    for delete from coredata
    
    //    func DeletePipValue(Product: PipValue ,tag: Int) {
    //        let del = PIPValueData().deletePipValue(context: self.context, selectedProduct: Product)
    //        if del {
    //            self.FetchPipValueData()
    //        } else {
    //            print("Noooo")
    //        }
    //    }
    
    // MARK: -  setup collection
    
//    func setupcololection() {
//        DispatchQueue.main.async {
//            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//            layout.minimumLineSpacing = 0
//            layout.minimumInteritemSpacing = 0
//            layout.scrollDirection = .horizontal
//            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            let width: CGFloat = self.Coll_onboard.bounds.width
//            let  height: CGFloat = self.Coll_onboard.bounds.height
//            let size = CGSize(width: width, height: height)
//            layout.itemSize = size
//            
//            self.Coll_onboard.collectionViewLayout = layout
//            self.Coll_onboard.reloadData()
//        }
//    }
    
    
    
    // MARK: -  best get method api
    
//    func CurrencyPair(from: String ,to: String) {
//        
//        if Utils().isConnectedToNetwork() == false {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                Utils().showAlert("Please check your internet connection and try again.")
////                self.lbl_CurrencyPair_Details.isHidden = true
////                self.txtfild_CurrencyPair.text = ""
//                Utils().HideLoader()
//            }
//            return
//        }
//        
//        AFWrapper.GetMethod(params: [:], apikey: "\(Constants.BASE_URL)\(from)&to=\(to)") { (json) in
//            
//            let dict = json as! NSDictionary
//            DispatchQueue.main.async {
//                
//                var rate = dict["rate"] as? Double
//                rate = ((self.Fractional*rate!).rounded() / self.Fractional)
//                //                let pow = dict["mins"] as? Int
//                self.lbl_CurrencyPair_Details.isHidden = false
//                self.lbl_TradeSize_Details.isHidden = false
//                
//                if self.ISIndexFromPair == 4 {
//                    self.lblAcCurrency_Detail.isHidden = false
//                }
//                
//                
//                if self.IsFromAcCurrency == self.IsFromPair1 || self.IsFromAcCurrency == self.IsFromPair2 {
//                    self.lblAcCurrency_Detail.isHidden = true
//                } else {
//                    self.lblAcCurrency_Detail.isHidden = false
//                }
//                
//                self.lbl_CurrencyPair_Details.text = "\(from)/\(to):\(rate!)"
//                
//            }
//            print(dict)
//        } failure: { error in
//            print(error.localizedDescription)
//        }
//    }

    
}





