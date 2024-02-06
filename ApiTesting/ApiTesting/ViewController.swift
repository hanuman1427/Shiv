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

class ViewController: UIViewController {
    
    var array = [UserModel]()

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
    

}





