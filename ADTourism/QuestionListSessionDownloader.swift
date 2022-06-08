//
//  GeneralSessionDownloader.swift
//  ADTourism
//
//  Created by Muhammad Ali on 3/5/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit

@objc protocol QuestionListSessionDataDelegate{
    @objc optional func updateDataProgress(_ progress : Float ,  identity : String)
    @objc optional func questionListDataDownloader(_ data : Data , identity : String , task_id : String)
    
}// end of the GeneralSessionDataDelegate

class QuestionListSessionDownloader: NSObject,URLSessionDownloadDelegate, URLSessionDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {
        var downloadTask: URLSessionDataTask!
        var backgroundSession: Foundation.URLSession!
        var session:Foundation.URLSession!
        var iden : String?
        var task_id : String?
    
    
        
        var del : QuestionListSessionDataDelegate!
        var progress : CFloat = 0.0
        
        
    
    func setupSessionDownload(_ urlStr : String,session_id : String,iden : String, task_id : String){
            var backgroundSessionId = "backgroundSession"
            self.iden = iden
            self.task_id = task_id
        
            backgroundSessionId = session_id
            let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: backgroundSessionId)
            
            backgroundSessionConfiguration.isDiscretionary = false
            backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
            
            
            let url = URL(string: urlStr)!
            
            var mutableRequest = URLRequest(url: url)
            mutableRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            mutableRequest.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
            
            self.downloadTask = backgroundSession.dataTask(with: mutableRequest)
            print("QuestionList Download Url \(url)")
            
            
            downloadTask.resume()
            
        
            
        }// end of the setupSession
        
        // 1
        
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
            print("Response!!")
            completionHandler(Foundation.URLSession.ResponseDisposition.becomeDownload)
                  }
        
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            //print(data)
            print("RECEIVING DATA!!!!")
            let str  = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            print(str)
           //self.del.generalDataDownloader!(data,identity : self.iden!)
            self.del.questionListDataDownloader!(data, identity: self.iden!,task_id : self.task_id!)
            
            
        }
        func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
            print(error)
        }
        
        
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
            print("didBecomeDownloadTask")
        }
        
        func urlSession(_ session: URLSession,
                        downloadTask: URLSessionDownloadTask,
                        
                        didFinishDownloadingTo location: URL){
            
            let data = try? Data(contentsOf: location)
            // let str = NSString(data: data, encoding:)
            
            
            //print(data)
            
            if self.del != nil && data != nil {
                self.del.questionListDataDownloader!(data!, identity: self.iden!,task_id : self.task_id!)
                
            }
            //print("didFinishDownloadingToURL didFinishDownloadingToURL didFinishDownloadingToURL didFinishDownloadingToURL")
            
        }
        // 2
        
        func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
            print("Download complete")
        }
        func urlSession(_ session: URLSession,
                        downloadTask: URLSessionDownloadTask,
                        didWriteData bytesWritten: Int64,
                                     totalBytesWritten: Int64,
                                     totalBytesExpectedToWrite: Int64){
         
            
        }
}
