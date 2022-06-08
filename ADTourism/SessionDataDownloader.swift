//
//  SessionDataDownloader.swift
//  ADTourism
//
//  Created by Muhammad Ali on 11/7/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

@objc protocol SessionDataDelegate{
    @objc optional func updateDataProgress(_ progress : Float ,  identity : String)
    @objc optional func dataDownloader(_ data : Data)
    
}

class SessionDataDownloader: NSObject,URLSessionDownloadDelegate, URLSessionDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {
    var downloadTask: URLSessionDataTask!
    var backgroundSession: Foundation.URLSession!
    var session:Foundation.URLSession!
    
    
    var del : SessionDataDelegate!
    var progress : CFloat = 0.0
    
    
    func setupPermitURL(){
        
        let permitUrl = Constants.baseURL + "downloadPermitsByLicense"

        var backgroundSessionId = "backgroundSession"
        
        backgroundSessionId = "permiturl"
        
        
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: backgroundSessionId)
        
        backgroundSessionConfiguration.isDiscretionary = false
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        
        
        
        let url = URL(string: permitUrl)!
        
        var mutableRequest = URLRequest(url: url)
        mutableRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        mutableRequest.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        
        self.downloadTask = backgroundSession.dataTask(with: mutableRequest)
        //downloadTask = backgroundSession.dataTaskWithRequest(muableRequest)
        //downloadTask = backgroundSession.downloadTaskWithURL(url)
       // print("Download Url \(url)")
        
        
        downloadTask.resume()

        
    }

    
    func setupSessionDownload(_ urlStr : String,session_id : String){
        var backgroundSessionId = "backgroundSession"
        
        backgroundSessionId = session_id
        
        
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: backgroundSessionId)
        
        backgroundSessionConfiguration.isDiscretionary = false
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        
       let urlstr1 =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlstr1!)!
        print("FORMATED URL \(url)")
        
        var mutableRequest = URLRequest(url: url)
        mutableRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        mutableRequest.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        

        self.downloadTask = backgroundSession.dataTask(with: mutableRequest)
        //downloadTask = backgroundSession.dataTaskWithRequest(muableRequest)
        //downloadTask = backgroundSession.downloadTaskWithURL(url)
        //print("Download Url \(url)")
        
        
        downloadTask.resume()
      
       /*
        let requestUrl = "https://www.google.com"
        let request = NSURLRequest(URL: NSURL(string: requestUrl)!)
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        self.session = NSURLSession(
            configuration: configuration,
            delegate: self,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task = session.dataTaskWithRequest(request)
        //session.dataTaskWithRequest(req, completionHandler: <#T##(NSData?, NSURLResponse?, NSError?) -> Void#>)
        
        task.resume()
 */
        
    
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
        self.del.dataDownloader!(data)
   
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
        self.del.dataDownloader!(data!)
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
        //  progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
        // print("Total Bytes written  / expected bytes  \(totalBytesWritten)/ \(totalBytesExpectedToWrite)")
        //del.updateProgress!(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), identity: "largeFile")
        //self.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        
    }
}
