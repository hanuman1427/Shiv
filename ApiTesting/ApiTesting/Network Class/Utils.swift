//
//  Utils.swift
//  SwiftDemo
//
//  Created by Redspark on 19/12/17.
//  Copyright © 2017 Redspark. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import EventKit
import StoreKit
import QuickLook

class Utils: NSObject {
        
    func isConnectedToNetwork() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    func showAlert(_ message: String){
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            }))
        
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController!.present(alert, animated: true, completion: nil)
        
    }
    
    func showDialouge(_ title: String,_ message: String, view: UIViewController){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
        view.present(alert, animated: true, completion: nil)
    }
    
    func showAlertControllerWith(title:String, message:String?, onVc:UIViewController , style: UIAlertController.Style = .alert, buttons:[String], completion:((Bool,Int)->Void)?) -> Void {

         let alertController = UIAlertController.init(title: title, message: message, preferredStyle: style)
         for (index,title) in buttons.enumerated() {
             let action = UIAlertAction.init(title: title, style: UIAlertAction.Style.default) { (action) in
                 completion?(true,index)
             }
             alertController.addAction(action)
         }

         onVc.present(alertController, animated: true, completion: nil)
     }

    func ShowLoader(text: String){

         self.HideLoader()
         let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
         let backgroundView = UIView()
         let backView = UIView()
         backgroundView.frame = CGRect.init(x: 0, y: 0, width: window!.bounds.width, height: window!.bounds.height)
         backView.frame = CGRect.init(x: 0, y: 0, width: 80, height: 80)
         backView.layer.cornerRadius = 10
         backView.layer.masksToBounds = true
         backView.center = window!.center
         backView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
         backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.05)
         backgroundView.tag = 475647

         var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
         activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
         activityIndicator.center = window!.center
         activityIndicator.hidesWhenStopped = true
         activityIndicator.style = .large
         activityIndicator.color = .white
         activityIndicator.startAnimating()
         backgroundView.addSubview(backView)
         backgroundView.addSubview(activityIndicator)
         let label = UILabel()
         label.frame = CGRect.init(x: 5, y: backView.frame.origin.y + 5, width: backView.bounds.width - 10, height: 10)
         label.center = CGPoint(x: window!.bounds.width / 2, y: window!.bounds.height / 2 + 25)
         label.text = text
         label.textAlignment = .center
         label.font = UIFont.systemFont(ofSize: 9)
         label.textColor = .white
         backgroundView.addSubview(label)
         window?.addSubview(backgroundView)
    }

    func HideLoader(){
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if let background = window?.viewWithTag(475647){
            background.removeFromSuperview()
        }

    }

    func resizeImage(image: UIImage) -> UIImage{
        
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = 800.0
        let maxWidth: Float = 800.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 1.0
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!) ?? UIImage()
    }
    
    func height(forText text: String?, font: UIFont?, withinWidth width: CGFloat) -> CGSize {
        
        let constraint = CGSize(width: width, height: 20000.0)
        var size: CGSize
        var boundingBox: CGSize? = nil
        if let aFont = font {
            boundingBox = text?.boundingRect(with: constraint, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: aFont], context: nil).size
        }
        size = CGSize(width: ceil((boundingBox?.width)!), height: ceil((boundingBox?.height)!))
        return size
    }
    
    func ConvertDate(date: Date) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        let resultString = inputFormatter.string(from: date)
        return resultString
    }
    
    func ConvertStringToDate1(stringDate: String) -> String {
        
        let dateFormatterUK = DateFormatter()
        dateFormatterUK.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatterUK.date(from: stringDate)!
        dateFormatterUK.dateFormat = "dd MMM yyyy hh:mm a"
        let resultString = dateFormatterUK.string(from: date)
        return resultString
    }
    
    func ConvertStringToDate(stringDate: String) -> Date {
        
        let dateFormatterUK = DateFormatter()
        dateFormatterUK.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatterUK.date(from: stringDate)!
        return date
    }
    
//    func setupHome() {
//        
//        DispatchQueue.main.async {
//            
//            guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
//                return
//            }
//
//            let rootViewController = Constants.storyBoard.instantiateViewController(withIdentifier: "Map_VC") as? Map_VC
//
//            let navigationController = UINavigationController(rootViewController: rootViewController!)
//            navigationController.isNavigationBarHidden = true
//            window.rootViewController = navigationController
//            window.makeKeyAndVisible()
//
//            let options: UIView.AnimationOptions = .transitionCrossDissolve
//            UIView.transition(with: window, duration: 0.3, options: options, animations: {}, completion:
//            { completed in
//                // maybe do something on completion here
//            })
//        }
//    }
//    
//    func setupRegister() {
//        
//        DispatchQueue.main.async {
//            
//            guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
//                return
//            }
//
//            let rootViewController = Constants.storyBoard.instantiateViewController(withIdentifier: "Home_Page") as? Home_Page
//
//            let navigationController = UINavigationController(rootViewController: rootViewController!)
//            navigationController.isNavigationBarHidden = true
//            window.rootViewController = navigationController
//            window.makeKeyAndVisible()
//
//            let options: UIView.AnimationOptions = .transitionCrossDissolve
//            UIView.transition(with: window, duration: 0.3, options: options, animations: {}, completion:
//            { completed in
//                // maybe do something on completion here
//            })
//        }
//    }

    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func getPastTime(for date : Date) -> String {

        var secondsAgo = Int(Date().timeIntervalSince(date))
        if secondsAgo < 0 {
            secondsAgo = secondsAgo * (-1)
        }

        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day

        if secondsAgo < minute  {
            if secondsAgo < 2{
                return "just now"
            }else{
                return "\(secondsAgo) secs"
            }
        } else if secondsAgo < hour {
            let min = secondsAgo/minute
            if min == 1{
                return "\(min) min"
            }else{
                return "\(min) mins"
            }
        } else if secondsAgo < day {
            let hr = secondsAgo/hour
            if hr == 1{
                return "\(hr) hr"
            } else {
                return "\(hr) hrs"
            }
        } else if secondsAgo < week {
            let day = secondsAgo/day
            if day == 1{
                return "Yesterday"
            }else{
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/mm/yyyy"
              //  formatter.locale = Locale(identifier: "en_US")
                let strDate: String = formatter.string(from: date)
                return strDate
            }
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/mm/yyyy"
          //  formatter.locale = Locale(identifier: "en_US")
            let strDate: String = formatter.string(from: date)
            return strDate
        }
    }
    
    func getAllCountry() -> [String] {
        
        var countries: [String] = []
        for code in NSLocale.isoCountryCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        return countries
        
    }
    
    func getLabelsInView(view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UILabel {
                results += [labelView]
            } else {
                results += getLabelsInView(view: subview)
            }
        }
        return results
    }
    
    func getButtonsInView(view: UIView) -> [UIButton] {
        var results = [UIButton]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UIButton {
                results += [labelView]
            } else {
                results += getButtonsInView(view: subview)
            }
        }
        return results
    }
    
    func getTextfieldsInView(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UITextField {
                results += [labelView]
            } else {
                results += getTextfieldsInView(view: subview)
            }
        }
        return results
    }
    
    func getTextviewInView(view: UIView) -> [UITextView] {
        var results = [UITextView]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UITextView {
                results += [labelView]
            } else {
                results += getTextviewInView(view: subview)
            }
        }
        return results
    }
        
    func giveRating()  {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            var RateUsCount : Int = 0
            if(Constants.USERDEFAULTS.value(forKey: "isRate") != nil){
                RateUsCount = Constants.USERDEFAULTS.value(forKey: "isRate") as! Int
                RateUsCount += 1
                Constants.USERDEFAULTS.set(RateUsCount, forKey: "isRate")
            }
            else {
                Constants.USERDEFAULTS.set(RateUsCount, forKey: "isRate")
            }
            
            if(RateUsCount > 3){
                Constants.USERDEFAULTS.removeObject(forKey: "isRate")
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    func showToast(context ctx: UIViewController, msg: String) {

        let toast = UILabel(frame:
                                CGRect(x:  ctx.view.frame.size.width / 2 - 50, y: ctx.view.bounds.height - 120,
                   width: 100, height: 40))
        toast.backgroundColor = UIColor.black
        toast.textColor = UIColor.white
        toast.textAlignment = .center
        //toast.center = ctx.view.center
        toast.numberOfLines = 1
        toast.font = UIFont.systemFont(ofSize: 20)
        toast.layer.cornerRadius = 12
        toast.clipsToBounds  =  true

        toast.text = msg

        ctx.view.addSubview(toast)

        UIView.animate(withDuration: 0.5, delay: 0.5,
            options: .curveEaseOut, animations: {
            toast.alpha = 0.5
            }, completion: {(isCompleted) in
                toast.removeFromSuperview()
        })
    }
}

class CountryCodes {
    
    struct CountryWithCode {
        var countryCode: String
        var countryName: String
        var dialCode: String
        var currencyCode: String
    }
    
    private static let countryDictionary = ["AF":"93", "AL":"355", "DZ":"213","AS":"1", "AD":"376", "AO":"244", "AI":"1","AG":"1","AR":"54","AM":"374","AW":"297","AU":"61","AT":"43","AZ":"994","BS":"1","BH":"973","BD":"880","BB":"1","BY":"375","BE":"32","BZ":"501","BJ":"229","BM":"1","BT":"975","BA":"387","BW":"267","BR":"55","IO":"246","BG":"359","BF":"226","BI":"257","KH":"855","CM":"237","CA":"1","CV":"238","KY":"345","CF":"236","TD":"235","CL":"56","CN":"86","CX":"61","CO":"57","KM":"269","CG":"242","CK":"682","CR":"506","HR":"385","CU":"53","CY":"537","CZ":"420","DK":"45","DJ":"253","DM":"1","DO":"1","EC":"593","EG":"20","SV":"503","GQ":"240","ER":"291","EE":"372","ET":"251","FO":"298","FJ":"679","FI":"358","FR":"33","GF":"594","PF":"689","GA":"241","GM":"220","GE":"995","DE":"49","GH":"233","GI":"350","GR":"30","GL":"299","GD":"1","GP":"590","GU":"1","GT":"502","GN":"224","GW":"245","GY":"595","HT":"509","HN":"504","HU":"36","IS":"354","IN":"91","ID":"62","IQ":"964","IE":"353","IL":"972","IT":"39","JM":"1","JP":"81","JO":"962","KZ":"77","KE":"254","KI":"686","KW":"965","KG":"996","LV":"371","LB":"961","LS":"266","LR":"231","LI":"423","LT":"370","LU":"352","MG":"261","MW":"265","MY":"60","MV":"960","ML":"223","MT":"356","MH":"692","MQ":"596","MR":"222","MU":"230","YT":"262","MX":"52","MC":"377","MN":"976","ME":"382","MS":"1","MA":"212","MM":"95","NA":"264","NR":"674","NP":"977","NL":"31","AN":"599","NC":"687","NZ":"64","NI":"505","NE":"227","NG":"234","NU":"683","NF":"672","MP":"1","NO":"47","OM":"968","PK":"92","PW":"680","PA":"507","PG":"675","PY":"595","PE":"51","PH":"63","PL":"48","PT":"351","PR":"1","QA":"974","RO":"40","RW":"250","WS":"685","SM":"378","SA":"966","SN":"221","RS":"381","SC":"248","SL":"232","SG":"65","SK":"421","SI":"386","SB":"677","ZA":"27","GS":"500","ES":"34","LK":"94","SD":"249","SR":"597","SZ":"268","SE":"46","CH":"41","TJ":"992","TH":"66","TG":"228","TK":"690","TO":"676","TT":"1","TN":"216","TR":"90","TM":"993","TC":"1","TV":"688","UG":"256","UA":"380","AE":"971","GB":"44","US":"1", "UY":"598","UZ":"998", "VU":"678", "WF":"681","YE":"967","ZM":"260","ZW":"263","BO":"591","BN":"673","CC":"61","CD":"243","CI":"225","FK":"500","GG":"44","VA":"379","HK":"852","IR":"98","IM":"44","JE":"44","KP":"850","KR":"82","LA":"856","LY":"218","MO":"853","MK":"389","FM":"691","MD":"373","MZ":"258","PS":"970","PN":"872","RE":"262","RU":"7","BL":"590","SH":"290","KN":"1","LC":"1","MF":"590","PM":"508","VC":"1","ST":"239","SO":"252","SJ":"47","SY":"963","TW":"886","TZ":"255","TL":"670","VE":"58","VN":"84","VG":"284","VI":"340"]

    static func values() -> [CountryWithCode] {
        var countriesWithCode = [CountryWithCode]()
        
        let countryCodes = countryDictionary.keys
        for countryCode in countryCodes {
            let countryName = Locale.current.localizedString(forRegionCode: countryCode) ?? "N/A"
            let dialCode = countryDictionary[countryCode] ?? "N/A"
            let currencyCode = Locale.currency[countryCode]?.code
            let countryValue = CountryWithCode(countryCode: countryCode,
                                               countryName: countryName,
                                               dialCode: dialCode, currencyCode: currencyCode ?? "")
            countriesWithCode.append(countryValue)
        }
        
        let sortedCountries = countriesWithCode.sorted { (firstCountry, secondCountry) -> Bool in
            let sortedByName = firstCountry.countryName.compare(secondCountry.countryName) == .orderedAscending
            return sortedByName
        }
        
        countriesWithCode.removeAll()
        countriesWithCode.append(contentsOf: sortedCountries)
        
        return countriesWithCode
    }
    
}

extension Locale {
    static let currency: [String: (code: String?, symbol: String?, name: String?)] = isoRegionCodes.reduce(into: [:]) {
        let locale = Locale(identifier: identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $1]))
        $0[$1] = (locale.currencyCode, locale.currencySymbol, locale.localizedString(forCurrencyCode: locale.currencyCode ?? ""))
    }
}
