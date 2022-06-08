//
//  VPNManager.swift
//  ADTourism
//
//  Created by Muhammad Ali on 10/6/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit
import NetworkExtension

class VPNManager: NSObject {
    var vpnDao : VPNDao!
    var timer : Timer?
    
    
    // let del = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func startVPNTimer(_ vpn : VPNDao){
        self.vpnDao = vpn
        
        //self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: @sele, userInfo: nil, repeats: true)
        if self.timer != nil {
        self.timer?.invalidate()
        self.timer = nil
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
        
        
    }
    func disconnect(){
    NEVPNManager.shared().connection.stopVPNTunnel()
    }
    @objc func runTimer(){
       

        if NEVPNManager.shared().connection.status == NEVPNStatus.connected || NEVPNManager.shared().connection.status == NEVPNStatus.connecting {
           
        // del.vpnConnected = true
          // print("Connected")
            
        }
        else {
          //  del.vpnConnected = false
           //  print("not Connected")

            
            
        self.startVPN()
        }
        
    }
    func setupVPN(_ vpnDao : VPNDao) -> Bool{
        self.vpnDao = vpnDao
        
        
        
      //  KeychainMethods().createKeychainValue(VPN_PASSWORD, forIdentifier: "VPN_PASSWORD")
      //  KeychainMethods.storeData("PSK", data:SHARED_SECRET)
        
        KeychainMethods.storeData("PSK3", data:vpnDao.SHARED_SECRET)
        KeychainMethods().createKeychainValue(self.vpnDao.VPN_PASSWORD,forIdentifier : "VPN_PASSWORD3")
         KeychainMethods.storeData("VPN_PASSWORD3", data:self.vpnDao.VPN_PASSWORD)
        
        let manager = NEVPNManager.shared()
        var returnedValue = false

        manager.loadFromPreferences { (error) ->  Void in
            if error  == nil  {
               // print("error is nill")
                let p = NEVPNProtocolIPSec()
                p.username = vpnDao.VPN_USER
                
               // print(p.username)
                
                
                p.passwordReference = KeychainMethods().searchKeychainCopy(matching: "VPN_PASSWORD3")
                
                
                
                
                
                p.serverAddress = vpnDao.VPN_SERVER
                p.authenticationMethod = NEVPNIKEAuthenticationMethod.sharedSecret
                p.sharedSecretReference = KeychainMethods.getData("PSK3")
                
                p.localIdentifier = vpnDao.LOCAL_IDENTIFIER
                p.remoteIdentifier = vpnDao.SERVER_IDENTIFIER
                
                
                
                p.useExtendedAuthentication = true
                p.disconnectOnSleep = vpnDao.DISCONNECT_SLEEP
                
                if #available(iOS 9.0, *) {
                    manager.protocolConfiguration = p
                } else {
                    // Fallback on earlier versions
                    
                }
                
                manager.isEnabled = true
                manager.saveToPreferences(completionHandler: {(error) ->  Void in
                    if error == nil  {
                        print("saved")
                       returnedValue = true
                        self.startVPN()
                        
                    }
                    else {
                        returnedValue = false
                        print (error.debugDescription)
                    }
                })
                //                do{
                //                let error = try manager.connection.startVPNTunnel()
                //                } catch {
                //                print("error occured" + error.localizedDescription)
                //                }
            }
            else {
                print(error?.localizedDescription)
            }
            
            
            
        }
        print("Returning \(returnedValue)")
       
        
        return returnedValue
        
    }
    
    
    
    
    func deleteVPN(){
        NEVPNManager.shared().connection.stopVPNTunnel()
        NEVPNManager.shared().removeFromPreferences(completionHandler: {(error) ->  Void in
        self.timer?.invalidate()
        })
        
        
    
    }
    
    func vpnStatus() -> Bool {
        if NEVPNManager.shared().connection.status == NEVPNStatus.disconnected || NEVPNManager.shared().connection.status == NEVPNStatus.disconnecting || NEVPNManager.shared().connection.status == NEVPNStatus.invalid {
            print("VPN not connected \(NEVPNManager.shared().connection.status.rawValue)")
        return false
        }
        else {
            //print("VPN connected\(NEVPNManager.sharedManager().connection.status.rawValue)")
            
        return true
        }
    
        
    }
    
    func startVPN(){
         Reachability.checkConnecetdInternet()

        
        let del = UIApplication.shared.delegate as! AppDelegate

         let state = UIApplication.shared.applicationState
        if Reachability.isConnectedNetwork() && state != UIApplicationState.background && del.interConnection == true{
                let manager = NEVPNManager.shared()
        
        
        manager.loadFromPreferences { (error) ->  Void in
            
            if error  == nil  {
               // print("error is nill")
                
                do {
                 try manager.connection.startVPNTunnel()
                } catch let error as NSError {
                print("VPN" + error.localizedDescription)
                }
                
                           }
            
            
        }
        }// end of network check

    }
    

}
