//
//  DataDownloader+Utility.swift
//  ADTourism
//
//  Created by Muhammad Ali on 8/8/18.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import Foundation
extension DataDownloader {
    func saveTasksToDatabase(json_string : String,task_id : String,unique_id : String, type : Int, server_response : String){
        
        /// type 1 offline , 0 online
        
        
        
        var taskResult = TaskResultsDao()
        taskResult.json_string = json_string
        taskResult.task_id = task_id
        taskResult.type = type
        taskResult.unique_id = unique_id
        taskResult.server_reponse = server_response
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy hh:mm:ss"
        taskResult.entry_datetime = format.string(from: Date())
        taskResult.submit_datetime = taskResult.entry_datetime
        DatabaseManager().addOfflineTaskStatus(_offline: taskResult)
        
    }
    
    func updateTasksToDatabase(unique_id : String , server_response : String) {
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy hh:mm:ss"
        DatabaseManager().updateOfflineTasks(task_id: unique_id, server_reponse: server_response, submitted_time: format.string(from: Date()))
        
        
       
    }
    
    func updateTasksToDatabase(unique_id : String , server_response : String,type : Int) {
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy hh:mm:ss"
        DatabaseManager().updateOfflineTasks(task_id: unique_id, server_reponse: server_response, submitted_time: format.string(from: Date()),type : type)
        
        
        
    }
    
    func setupCloseTaskGetRequest(task_id :  String,requestStr : String, type : Int) {
        self.xmlData = NSMutableData()
       let urlstr1 =  requestStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
       // let urlstr1 =  requestStr
        
       print(requestStr)
        print(urlstr1)
        if urlstr1 == nil {
            return
        }
        let ourl : URL =  URL(string: urlstr1!)!
        var  urlRequest : URLRequest = URLRequest (url:ourl)
        urlRequest.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
       
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print("error \(urlstr1)")
                print(error!.localizedDescription)
                self.delegate?.failed!(self.iden)
            }
            
            guard let data = data else { return }
            
            let str = String(data: data, encoding:  String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            print("Server response before saving \(str)")
            if str != nil {
                 self.delegate?.dataDownloaded!(NSMutableData(data: data), identity: self.iden)
                self.updateTasksToDatabase(unique_id: task_id, server_response: str!,type:type)
              //  self.delegate?.dataDownloaded(data, identity: self.iden)
            }
            else {
                print("str is nill and cant save data")
                self.delegate?.failed!(self.iden)
            }
            
            
            }.resume()
        
    }
    
}
