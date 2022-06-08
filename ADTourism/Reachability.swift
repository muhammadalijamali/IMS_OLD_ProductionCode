//
//  Reachability.swift
//
//
//  Created by Administrator on 12/3/15.
//
//

import UIKit
import SystemConfiguration


class Reachability: NSObject {
    static let appDel = UIApplication.shared.delegate as! AppDelegate
    class func connectedToNetwork() -> Bool {
        // For swift1.2 following code was used
        
        //        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        //        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        //        zeroAddress.sin_family = sa_family_t(AF_INET)
        //
        //        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
        //            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        //        }
        //
        //        var flags: SCNetworkReachabilityFlags = []
        //        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
        //            return false
        //        }
        //
        //        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        //        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        //
        //        return (isReachable && !needsConnection) ? true : false
        //  return true
        
        // For swift2 following code is used
        
        /*
         var Status:Bool = false
         let url = NSURL(string: Constants.baseURL)
         let request = NSMutableURLRequest(URL: url!)
         request.HTTPMethod = "HEAD"
         
         request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
         request.timeoutInterval = 0.1
         var semaphore = dispatch_semaphore_create(0)
         
         //let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
         //sessionConfig.timeoutIntervalForRequest = 1.0
         //sessionConfig.timeoutIntervalForResource = 0.5
         
         
         //let session = NSURLSession(configuration:sessionConfig, delegate: IMSURLSession(), delegateQueue: nil)
         //session.SETDE; = IMSURLSession()
         let session = NSURLSession.sharedSession()
         
         
         session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
         
         //      print("data \(data)")
         //       print("response \(response)")
         //  print("error \(error)")
         
         if let httpResponse = response as? NSHTTPURLResponse {
         print("httpResponse.statusCode \(httpResponse.statusCode)")
         if httpResponse.statusCode == 200 || httpResponse.statusCode == 403  {
         print("STATUS TRUE")
         Status = true
         
         
         }
         else {
         
         Status = false
         print("ELSE")
         }
         }
         dispatch_semaphore_signal(semaphore)
         }).resume()
         dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
         
         
         //  print("Returning \(Status)")
         return Status
         */
        
        
        
        
        // start of swift2 //
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
//        }
//        var flags = SCNetworkReachabilityFlags()
//        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
//            return false
//        }
//        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        
//        
//        let networkStatus = (isReachable && !needsConnection)
//        
//        
        // Start of swift3
        
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
      //return (isReachable && !needsConnection)
        
        // end of swift 3
        
        
        
        //print("Returning \((networkStatus && appDel.vpnManager.vpnStatus()))")
        //return (networkStatus)
        //print("Internet connection Available \(appDel.interConnection)")
        
        // return (networkStatus && appDel.vpnManager.vpnStatus() && appDel.interConnection)
  // return appDel.vpnManager.vpnStatus()
        
    return (isReachable && !needsConnection)  // QA/UAT
         
       //return (networkStatus)
        
    //  return appDel.vpnManager.vpnStatus() // PRODUCTION
        
        
        //return Status
        
    }
    
    class func checkConnecetdInternet(){
        var Status:Bool = false
        var del = UIApplication.shared.delegate as! AppDelegate
        let url = URL(string: "https://google.com")
        var request = URLRequest(url: url!)
        request.httpMethod = "HEAD"
        
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 3.0
        //var semaphore = dispatch_semaphore_create(0)
        
        //let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        //sessionConfig.timeoutIntervalForRequest = 1.0
        //sessionConfig.timeoutIntervalForResource = 0.5
        
        
        //let session = NSURLSession(configuration:sessionConfig, delegate: IMSURLSession(), delegateQueue: nil)
        //session.SETDE; = IMSURLSession()
        let session = URLSession.shared
        
        
        session.dataTask(with: request, completionHandler: {(data, response, error) in
            
           // print("data \(data)")
           // print("response \(response)")
           // print("error \(error)")
            
            if let httpResponse = response as? HTTPURLResponse {
                //print("httpResponse.statusCode \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 403  {
                    //print("STATUS TRUE")
                    Status = true
                    del.interConnection = true
                    
                    
                    
                }
                else {
                    
                    //Status = false
                    del.interConnection = false
                    print("ELSE")
                }
            }
            else {
                del.interConnection = false
            }
            // dispatch_semaphore_signal(semaphore)
        }).resume()
        // dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        
        //  print("Returning \(Status)")
        
        
        
        
        
    }
    
    class func isConnectedNetwork() -> Bool {
        
        // Start ofs swift 3
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
        
        
        // start oof swift2
        
        
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
//        }
//        var flags = SCNetworkReachabilityFlags()
//        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
//            return false
//        }
//        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        let networkStatus = (isReachable && !needsConnection)
//        return networkStatus
    }
}
