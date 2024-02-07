//
//  postMethodVC.swift
//  ApiTesting
//
//  Created by hiren ghoniya on 07/02/24.
//

import UIKit
import Alamofire

class postMethodVC: UIViewController {

    var dataArray = [Data]()
    var failedCount = 0
    var convertype = ""
    var extesion = ""
    var converExt = ""
    var segmentIndex = 0
    var url = [URL]()
    var filename = ""
    var fileType = ""
    
    var header = ""
    var isSubscribe = false
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var pathForFile = ""
    var dataForFile: Data? = nil
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func upload_File(data: [Data])  {
        
//        let parameters: [String : Any] = [
//            "file" : data
//        ]
//        
//        AFWrapper.PostMultiPartdata(params: parameters as [String : AnyObject], apikey: Constants.UPLODAD_FILE, completion: { (json) in
//            
//            if(json is NSArray){
//                let dict = json as! NSArray
//                self.callAPI(apikey: Constants.GET_CONVERTER, array: dict)
//            }
//            else{
//                
//                self.dismiss(animated: true) {
//                    Utils().user_Convert_Status(convert_type: self.header, convert_status: "0")
//                    Utils().showAlert("Conversion failed.Please try with other file(s).")
//                }
//            }
//        }, failure: { (error) in
//            print(error)
//        })
    }
    
    func callAPI(apikey: String, array: NSArray)  {
                
        let json: [String: Any] = ["files":array,"outputFileType":"\(self.extesion)","dpi":144,"imageQuality":0.75,"conversionMode":"block"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: Constants.BASE_URL + apikey)! //PUT Your URL
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                self.dismiss(animated: true) {
//                    Utils().user_Convert_Status(convert_type: self.header, convert_status: "0")
                   Utils().showAlert("Conversion failed.Please try with other file(s).")
                }
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON) //Code after Successfull POST Request
                let jobId = responseJSON["jobId"] as? String
                
//                DispatchQueue.main.async {
//                    self.lblLoading.text = "Downloading..."
//                    let download_url = Constants.DOWNLOAL_URL + jobId!
//                    let url = URL(string: Constants.BASE_URL + download_url)
//                    self.extesion = self.extesion.replacingOccurrences(of: ".", with: "")
//                    FileDownloader.loadFileSync(url: url!, extention: self.extesion, completion: { (path, error) in
//                        print("PDF File downloaded to : \(path!)")
//                        let pathArray = path?.components(separatedBy: "/")
//                        DispatchQueue.main.async {
//                            if((Constants.USERDEFAULTS.value(forKey: "isShowAds")) == nil){
//                                self.viewLoader.isHidden = true
//                                self.pathForFile = pathArray!.last!
//                                self.dataForFile = FileManager.default.contents(atPath: path!)
//                                self.showPopupforReward()
//                            }
//                            else{
//                                let data = FileManager.default.contents(atPath: path!)
//                                self.saveDataFile(filePath: pathArray!.last!, data: data)
//                            }
//                        }
//                    })
//                }
            }
        }

        task.resume()
    }

}
    
  


