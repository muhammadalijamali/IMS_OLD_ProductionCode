//
//  MyFileManager.swift
//  
//
//  Created by Administrator on 12/11/15.
//
//

import UIKit

class MyFileManager: NSObject {
    func createTaskFolder(_ task_id : String){
        var error: NSError?
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: NSString = paths[0] as NSString
        let dataPath = documentsDirectory.appendingPathComponent(task_id)
        
        if (!FileManager.default.fileExists(atPath: dataPath)) {
            do {
                try FileManager.default .createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error1 as NSError {
                error = error1
            }
        }
    }
    func createAudioFolder(_ task_id : String){
        var error: NSError?

        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: NSString = paths[0] as NSString
        let dataPath = documentsDirectory.appendingPathComponent("\(task_id)/audio")
        
        if (!FileManager.default.fileExists(atPath: dataPath)) {
            do {
                try FileManager.default .createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error1 as NSError {
                error = error1
            }
        }

        
    }
    func createImageFolder(_ task_id : String){
        var error: NSError?

        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: NSString = paths[0] as NSString
        let dataPath = documentsDirectory.appendingPathComponent("\(task_id)/image")
        
        if (!FileManager.default.fileExists(atPath: dataPath)) {
            do {
                try FileManager.default .createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error1 as NSError {
                error = error1
            }
        }
        

        
    }
    func writeImage(_ task_id : String , q_id : String , data : Data){
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: NSString = paths[0] as NSString
        let dataPath = documentsDirectory.appendingPathComponent("\(task_id)/image/\(q_id).jpeg")
        print("image written to \(dataPath)")
        FileManager.default.createFile(atPath: dataPath, contents: data, attributes: nil)
        
    
    }
    func writeAudio(_ task_id : String , q_id : String , data : Data){
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: NSString = paths[0] as NSString
        let dataPath = documentsDirectory.appendingPathComponent("\(task_id)/audio/\(q_id).m4a")
        FileManager.default.createFile(atPath: dataPath, contents: data, attributes: nil)
        
        
    }
    
}
