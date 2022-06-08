
//
//  Util.swift
//  ADTourism
//
//  Created by Muhammad Ali on 5/2/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class Util: NSObject {
    static var del : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    class func getEnglishNo(_ original : String) -> String{
        var original1 = original as NSString
        
        
        original1  = original1.replacingOccurrences(of: "١", with: "1") as NSString
        original1 = original1.replacingOccurrences(of: "٢", with: "2") as NSString
        original1 = original1.replacingOccurrences(of: "٣", with: "3") as NSString
        original1 = original1.replacingOccurrences(of: "٤", with: "4") as NSString
        original1 = original1.replacingOccurrences(of: "٥", with: "5") as NSString
        original1 = original1.replacingOccurrences(of: "٦", with: "6") as NSString
        original1 = original1.replacingOccurrences(of: "٧", with: "7") as NSString
        original1 = original1.replacingOccurrences(of: "٨", with: "8") as NSString
        original1 = original1.replacingOccurrences(of: "٩", with: "9") as NSString
        original1 = original1.replacingOccurrences(of: "٠", with: "0") as NSString
        return original1 as String
    }
   class func removeSpecialCharsFromString(_ text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }

    class func validateCoordinates(_ lat : String , lon : String) -> Bool {
        let latDao = Double(lat)
        let lonDao = Double(lon)
        
        if latDao > 0 && lonDao > 0{
        return true
        }
        else {
        return false
        }
    }
    
    
    
    
    
    
    
    class func returnUserLocation() -> (lat : Double, lon:Double){
    
        if self.del.user.lat != nil &&  self.del.user.lon != nil {
        return (self.del.user.lat , self.del.user.lon)
        }
        else {
            return (self.del.userDefault.double(forKey: "lat"),self.del.userDefault.double(forKey: "lon"))
                
            
    
        }
    
    }
    
    
    
    
    class func encryptPassword(password : String) -> String{
        let pub_key : String? = "-----BEGIN PUBLIC KEY----- MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCv4zRt7GAvm/RPjvCK/wbPl3gB 8eTvvHe+o8rZXYYc09DU2UaGwpg8kgQ3v2yodIY4bWXFM/UroGUwPrNwBMBOJCqQ HjM/IAsIYjGwK9vSxMXVH1PMpKa7U1m0enGeOzeBLUxhgdrr8vD22iRzCiWvG1eF AKbB8Qb/Spyf1sZHZQIDAQAB -----END PUBLIC KEY-----"
        
        
        let encWithPubKey = RSA.encryptString(password, publicKey: pub_key)
        
        return encWithPubKey!
        
        
        
    }
    
    

}
