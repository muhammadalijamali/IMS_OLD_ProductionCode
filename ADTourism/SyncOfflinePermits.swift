//
//  SyncOfflinePermits.swift
//  ADTourism
//
//  Created by Muhammad Ali on 1/29/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit

class SyncOfflinePermits: NSObject , SessionPermitsDataDelegate{
    let userDefaults : UserDefaults = UserDefaults.standard
    func setupOfflinePermits(){
        //self.userDefaults.removeObjectForKey("permitsync")
        // return
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        if Reachability.connectedToNetwork() {
            
            // self.rotateTimer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "rotate", userInfo: nil, repeats: true)
            
            
            if let syncDate = userDefaults.string(forKey: "permitsync")  {
                //dd/mm/yy
                //  let syncD = formatter.dateFromString(syncDate)
                if syncDate == formatter.string(from: Date()) {
                    print("Already synced today")
                }
                else {
                    print("Not Synced Today so synching")
                    print(syncDate)
                    print(formatter.string(from: Date()))
                    
                    
                    let session = AllPermitSessionDownloader()
                    session.del = self
                    let loginUrl = Constants.baseURL + "getPermitsInfo"
                    
                    print(loginUrl)
                    
                    session.setupDataDownloader(loginUrl, identity: "allpermits")
                    
                    
                }
            } // end of the if
            else {
                let session = AllPermitSessionDownloader()
                session.del = self
                let loginUrl = Constants.baseURL + "getPermitsInfo"
                
                print(loginUrl)
                print("Not Synced  so synching")
                
                session.setupDataDownloader(loginUrl, identity: "allpermits")
                
                
            } // end of the else
            
        }
        
        
        
    }
    
    func allRequestedDataDownloaded(_ data: Data, identity: String) {
        
        let parser = JsonParser()
        let allpermits = parser.perseAllPermits(NSMutableData(data: data))
        let database = DatabaseManager()
        database.deleteDrivers()
        database.deleteOfflinePermits()
        database.deleteVehicles(allpermits)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let today = Date()
        let todayStr = formatter.string(from: today)
        //  print("Today Str \(todayStr)")
        self.userDefaults.setValue(todayStr, forKey: "permitsync")
        self.userDefaults.synchronize()
        print(userDefaults.string(forKey: "permitsync"))
        //database.addAllPermits(allpermits)
        
    }
    
    
}
