//
//  AudioViewController.swift
//  ADTourism
//
//  Created by Administrator on 8/29/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {
    var audioRecorder:AVAudioRecorder!
    @IBAction func deleteMethod(_ sender: AnyObject) {
    }
    @IBAction func recordMethod(_ sender: AnyObject) {
        if audioRecorder.isRecording {
            self.recordbtn.setBackgroundImage(UIImage(named: "stoprecord"), for: UIControlState())

        }
        else {
        self.record()
        }
    }
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var recordbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.record()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func closeMethod(_ sender: AnyObject) {
   self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        func record(){
        self.recordbtn.setBackgroundImage(UIImage(named: "stoprecord"), for: UIControlState())
        var audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        do {
            try audioSession.setActive(true)
        } catch _ {
        }
        
        var documents: NSString = NSSearchPathForDirectoriesInDomains( FileManager.SearchPathDirectory.documentDirectory,  FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        var str =  documents.appendingPathComponent("recordTest.caf")
            
            var url = URL(fileURLWithPath: str as String)
        
        /*
            var recordSettings = [AVFormatIDKey:kAudioFormatAppleIMA4,
            AVSampleRateKey:44100.0,
            AVNumberOfChannelsKey:2,AVEncoderBitRateKey:12800,
            AVLinearPCMBitDepthKey:16,
            AVEncoderAudioQualityKey:AVAudioQuality.Max.rawValue
            
        ]
*/
            
            let recordSettings: [String : AnyObject] = [
                AVFormatIDKey:Int(kAudioFormatMPEG4AAC) as AnyObject, //Int required in Swift2
                AVSampleRateKey:44100.0 as AnyObject,
                AVNumberOfChannelsKey:2 as AnyObject,
                AVEncoderBitRateKey:12800 as AnyObject,
                AVLinearPCMBitDepthKey:16 as AnyObject,
                AVEncoderAudioQualityKey:AVAudioQuality.max.rawValue as AnyObject
            ]
            
        
        print("url : \(url)")
        var error: NSError?
        
        do {
            audioRecorder = try AVAudioRecorder(url:url, settings: recordSettings as [String : AnyObject])
        } catch let error1 as NSError {
            error = error1
            audioRecorder = nil
        }
        if let e = error {
            print(e.localizedDescription)
        } else {
            
            audioRecorder.record()
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
