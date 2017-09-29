//
//  Helper.swift
//  moonshot_test
//
//  Created by Miriam Hendler on 9/2/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
//import SwiftyJSON
//import Alamofire

class Helper {
    
    //    static func dumpJson(file: String) -> JSON {
    //        let path = Bundle.main.path(forResource: file, ofType: "json")
    //        let jsonData = NSData(contentsOfFile:path!)
    //        let json = JSON(data: jsonData! as Data)
    //        return json
    //        //        println(json["DDD"].string)
    //    }
    
    static func showAlert(controller: UIViewController) {
        let alertController = UIAlertController(title: "Error", message: "Please fill in missing fields", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    static func colorWithHexString (hex:String) -> UIColor
    {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cString = cString.lowercased()
        
        if (cString.hasPrefix("#"))
        {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6)
        {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    //    static func sendToTopic(school_topic: String, title: String, message: String) {
    //
    //        let key = "AIzaSyDQ76EQWhM7O5ExVUEtxTU9sHTJHUPop3Q"
    //        let headers = ["Authorization": "key=\(key)", "Content-Type": "application/json"]
    //        let contentURL = "https://fcm.googleapis.com/fcm/send"
    //        let params: [String: Any] = ["to": "/topics/\(school_topic)", "notification" : ["body" : message, "priority" : "high", "title" : title]]
    //
    //        Alamofire.request(contentURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).response { (response) in
    //            print("Sent Notification")
    //        }
    //    }
    static func getCurrentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        return "\(Int(month))-\(Int(day))-17-\(Int(hour))-\(Int(minutes))-\(second)"
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[Range(start ..< end)]
    }
    
    func decodeToImage() -> UIImage {
        let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters)
        let image = UIImage(data: imageData!)
        
        return image!
    }
    
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    
}

extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

extension UIView {
    func roundAndShadow(radius:CGFloat=5, opacity:Float=0.5, borderWidth: CGFloat=0, borderColor: CGColor=UIColor.brown.cgColor) {
        self.layer.masksToBounds = false;
        self.layer.cornerRadius = radius;
        self.layer.shadowOffset = CGSize(width: -1,height: 1);
        self.layer.shadowOpacity = opacity;
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
    func addBlur() {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.backgroundColor = UIColor.black
        }
    }
}
extension UIImage {
    func encodeTo64() -> String {
        
        let imageData = UIImagePNGRepresentation(self)!
        let strBase64 = imageData.base64EncodedString(options:  NSData.Base64EncodingOptions.init(rawValue: 0))
        
        return strBase64
    }
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x:0,y: 0,width: size.width,height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
extension UIImageView {
    func maskToCircle() {
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    
    
    
}
extension UIButton {
    
    func maskToCircle() {
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    
}

