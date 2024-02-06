//
//  AFWrepper.swift
//  OfferTreat
//
//  Created by Redspark on 15/05/18.
//  Copyright © 2018 Redspark. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class AFWrapper: NSObject{
    
    class func PostMethod (params: [String : AnyObject], apikey: String, completion: @escaping (Any) -> Void, failure:@escaping (Error) -> Void){
        if Utils().isConnectedToNetwork() == false{
            Utils().showAlert("Please check your internet connection and try again.")
            Utils().HideLoader()
            return
        }
        
        let strURL = apikey
        let url = URL(string: strURL)
        
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        manager.session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        manager.session.configuration.urlCache = nil
        manager.request(url!, method: .post, parameters: params)
            .responseJSON
        {
            response in
            switch (response.result)
            {
            case .success (let JSON):
                let jsonResponse = JSON as! NSDictionary
                // print(jsonResponse)
                completion(jsonResponse)
                Utils().HideLoader()
            case .failure(let error):
                Utils().HideLoader()
                Utils().showAlert("Please check your internet connection and try again.")
                failure(error)
                break
            }
        }
    }
    
    class func GetMethod (params: [String : AnyObject], apikey: String, completion: @escaping (Any) -> Void, failure:@escaping (Error) -> Void) {
        if Utils().isConnectedToNetwork() == false {
            Utils().showAlert("Please check your internet connection and try again.")
            Utils().HideLoader()
            return
        }
        
        let strURL = apikey
        let url = URL(string: strURL)
        
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        manager.request(url!, method: .get, parameters: params)
            .responseJSON
        {
            response in
            
            switch (response.result)
            {
            case .success (let JSON):
                let jsonResponse = JSON as! NSDictionary
                // print(jsonResponse)
                completion(jsonResponse)
            case .failure(let error):
                failure(error)
                break
            }
        }
    }
    
}
