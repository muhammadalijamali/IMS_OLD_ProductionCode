//
//  DownloaderUtility.swift
//  ADTourism
//
//  Created by Muhammad Ali on 3/20/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class DownloaderUtility: NSObject,MainJsonDelegate {
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
     let databaseManager = DatabaseManager()
    
    func downloadHistory(){
        if self.appDel.taskDao.company.company_id != nil && self.appDel.taskDao.company.license_info != nil {
            var history : String  = ""
            self.appDel.showIndicator = 0
            
            
             history = Constants.baseURL + "getEstablishmentViolationHistory?companyId=" + self.appDel.taskDao.company.company_id! + "&licenseNo=\(self.appDel.taskDao.company.license_info!)"
            
            print(history)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(history, idn: "violation_history")
        }
    }
 
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "violation_history" {
        let parser = JsonParser()
        let array = parser.parserOldViolations(data)
        databaseManager.deleteAllViolations()
        databaseManager.addViolations(array)
            
            
        }
    }
}
