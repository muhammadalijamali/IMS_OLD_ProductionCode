//
//  SessionFileDownLoader.swift
//  ADTourism
//
//  Created by Muhammad Ali on 9/7/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit
@objc protocol SessionDelegate{
    @objc optional func updateProgress(_ progress : Float ,  identity : String)
    @objc optional func fileDownload( _ url : URL)
    
}

class SessionFileDownLoader: NSObject,URLSessionDownloadDelegate {
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: Foundation.URLSession!

    var del : SessionDelegate!
    var progress : CFloat = 0.0
    var permitDao : PermitDao?
    
    
    func setupSessionDownload(_ urlStr : String){
        var backgroundSessionId = "backgroundSession"
        if self.permitDao != nil {
            let seconds = Date().timeIntervalSince1970 * 1000
            
        backgroundSessionId = "\(permitDao!.permitID!)\(seconds)"
        }
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: backgroundSessionId)
        backgroundSessionConfiguration.timeoutIntervalForRequest = 3000000.0
        backgroundSessionConfiguration.timeoutIntervalForResource = 60000000.0

        
        backgroundSessionConfiguration.isDiscretionary = false
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        //progressView.setProgress(0.0, animated: false)
        //backgroundSession.set
        let urlstr1 =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: urlstr1!)!
        downloadTask = backgroundSession.downloadTask(with: url)
        print(url)
        
        downloadTask.resume()
    }// end of the setupSession
    
    // 1
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL){
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
         let folderPath =  documentDirectoryPath + "/permits"
        
        let fileManager = FileManager()
        do {
            try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            //print("Permit Directory error  : \(error.localizedDescription)");
        }
        var fileName : String = "file.pdf"
        if permitDao != nil {
        fileName = "\(permitDao!.permitID!).pdf"
            
            
        }
        let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath + "/permits/\(fileName)")
        print(destinationURLForFile)
        del.fileDownload!(destinationURLForFile)
        self.backgroundSession.invalidateAndCancel()
//        if fileManager.fileExistsAtPath(destinationURLForFile.path!){
//            //showFileWithPath(destinationURLForFile.path!)
//        }
//        else{
            do {
                if destinationURLForFile.path != nil {
                if fileManager.fileExists(atPath: destinationURLForFile.path) {
                try fileManager.removeItem(at: destinationURLForFile)
                }
                }// end of the for loop
                try fileManager.moveItem(at: location, to: destinationURLForFile)
                
                //print("File is written to \(destinationURLForFile)")
                // show file
                //showFileWithPath(destinationURLForFile.path!)
            }catch let error as NSError{
                print("An error occurred while moving file to destination url : \(error)")
            }
       // }
    
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
        del.updateProgress!(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), identity: "largeFile")
        self.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        
    }
}
