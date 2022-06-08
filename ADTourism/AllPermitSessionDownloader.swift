//
//  AllPermitSessionDownloader.swift
//  ADTourism
//
//  Created by Muhammad Ali on 1/26/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit
@objc protocol SessionPermitsDataDelegate{
    @objc optional func allRequestedDataDownloaded(_ data : Data , identity : String)
}
class AllPermitSessionDownloader: NSObject,URLSessionDownloadDelegate, URLSessionDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {
        var downloadTask: URLSessionDataTask!
        var backgroundSession: Foundation.URLSession!
        var session:Foundation.URLSession!
    var identity : String?
    
    
        var del : SessionPermitsDataDelegate!
        var progress : CFloat = 0.0
    
    func setupDataDownloader(_ url : String , identity : String){
        
        
        var backgroundSessionId = "backgroundSession"
        
        backgroundSessionId = "permiturl"
        self.identity = identity
        
        
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: backgroundSessionId)
        
        backgroundSessionConfiguration.isDiscretionary = false
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        
        
        let url = URL(string: url)!
        
        var mutableRequest = URLRequest(url: url)
        mutableRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        mutableRequest.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        
        self.downloadTask = backgroundSession.dataTask(with: mutableRequest)
        
        
        downloadTask.resume()
        
    }
    
        func setupSessionDownload(_ urlStr : String,session_id : String){
            var backgroundSessionId = "backgroundSession"
            
            backgroundSessionId = session_id
            
            
            let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: backgroundSessionId)
            
            backgroundSessionConfiguration.isDiscretionary = false
            backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
            
            
            let url = URL(string: urlStr)!
            
            var mutableRequest = URLRequest(url: url)
            mutableRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            mutableRequest.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
            
            self.downloadTask = backgroundSession.dataTask(with: mutableRequest)
           // print("Download Url \(url)")
            
            
            downloadTask.resume()
            
            
        }// end of the setupSession
        
        // 1
        
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
            print("Response!!")
            completionHandler(Foundation.URLSession.ResponseDisposition.becomeDownload)
            //let data = NSData(contentsOfURL: location)
            //  print(String(data: data, encoding: ))
            
            //print(data)
            
            //self.del.dataDownloader!(data!)
        }
    
        
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            //print(data)
            print("RECEIVING DATA!!!!")
            let str  = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            print(str)
            self.del.allRequestedDataDownloaded!(data, identity: self.identity!)
            
            
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
           //  let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            //print(str)
            
            if self.del != nil && data != nil {
                self.del.allRequestedDataDownloaded!(data!, identity: self.identity!)
                
            }
            print("didFinishDownloadingToURL didFinishDownloadingToURL didFinishDownloadingToURL didFinishDownloadingToURL")
            
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

    




