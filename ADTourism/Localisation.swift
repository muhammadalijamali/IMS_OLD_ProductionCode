//
//  Localisation.swift
//  ADTourism
//
//  Created by Administrator on 10/24/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

class Localisation: NSObject {
   
    var  fallbackBundle : Bundle?
    var preferredBundle: Bundle?
    
    var fallbackLanguage : String?
    
    var preferredLanguage : String?
    
    
    
    func localizedString(key : String) -> String{
        var result : String?
        
        if self.fallbackBundle != nil {
            result = self.fallbackBundle?.localizedString(forKey: key, value: nil, table: nil)
        }
        
        if self.preferredBundle != nil {
            
            result = self.preferredBundle?.localizedString(forKey: key, value: nil, table: nil)
        }
        
        if result == nil {
            result = key
        }
        
        return result!
        
        
    }
    
    
    
    
    
    func setPreferred(_ preffered : String , fallback : String){
        fallbackLanguage = fallback
        preferredLanguage = preffered
        
        var bundlePath = Bundle.main.path(forResource: "Localizable", ofType: "strings", inDirectory: nil, forLocalization: fallback)
        self.fallbackBundle = Bundle(path: (bundlePath! as NSString).deletingLastPathComponent)
        bundlePath = Bundle.main.path(forResource: "Localizable", ofType: "strings", inDirectory: nil, forLocalization: preffered)
        self.preferredBundle = Bundle(path: (bundlePath! as NSString).deletingLastPathComponent)
        
        
        
    }


    
}
