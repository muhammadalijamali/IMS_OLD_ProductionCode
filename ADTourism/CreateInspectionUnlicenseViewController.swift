//
//  CreateInspectionUnlicenseViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 6/5/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import PKHUD
class CreateInspectionUnlicenseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,AVAudioRecorderDelegate  , AVAudioPlayerDelegate , MainJsonDelegate , UITextFieldDelegate {
    var firstImageId:Int = 0
    var secondImageId : Int = 0
    var thirdImageId : Int = 0
    var firstUIImage : UIImage?
    var secondUIImage : UIImage?
    var thirdUIImage : UIImage?
    var audioId : String = ""
    
    
    var whichImage : Int = 0 // 1 for first Image , 2 for second Image , 3 for third image
    var imagesArray : NSMutableArray = NSMutableArray()
 
    
    @IBAction func thirdImageMethod(_ sender: AnyObject) {
    }
    
    @IBAction func thirdImageCancelMethod(_ sender: AnyObject) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var thirdImageBtn: UIButton!
    
    @IBOutlet weak var thirdImageCancel: UIButton!
    
    @IBOutlet weak var secondImageBtn: UIButton!
    
    @IBAction func secondImageMethod(_ sender: AnyObject) {
    }
    
    @IBOutlet weak var secondImageCancel: UIButton!
    
    @IBOutlet weak var secondImageCancelMethod: UIButton!
    
    
    @IBAction func firstImageCancelMethod(_ sender: AnyObject) {
    }
    @IBAction func firstImageMethod(_ sender: AnyObject) {
    }
    @IBOutlet weak var firstImageCancel: UIButton!
    @IBOutlet weak var firstImageBtn: UIButton!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var incidentLabel: UILabel!
    @IBOutlet weak var incidentReportTitle: UILabel!
    var report_type : Int = 0
    let LOWCOLOR : UIColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
    let MEDIUMCOLOR : UIColor =  UIColor(red:246/255 , green: 142/255, blue: 90/255, alpha: 1.0)
    let HIGHCOLOR : UIColor =  UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
    var urgency : Int = 0 // Green // 2 medium // 3 High
    

    
    @IBOutlet weak var incidentBtn: UIButton!
    
    
    @IBAction func incidentMethod(_ sender: AnyObject) {
        /*
        let alert = SCLAlertView()
        alert.showCloseButton = false
        
        alert.addButton("DTCM", action: {
           
            self.report_type = 1 // DTCM
            //self.incidentBtn.text = "DTCM"
            self.incidentBtn.setTitle("DTCM", forState: UIControlState.Normal)
            
        } )
        
        alert.addButton("NON DTCM", action: {
           
            self.report_type = 2 // NON DTCM
            //self.typeLbl.text = "NON DTCM"
            self.incidentBtn.setTitle("NON DTCM", forState: UIControlState.Normal)
            
            
        } )
        
        
        alert.addButton(localisation.localizedString(key: "questions.cancel"), action: {
           
            
        })
        
        alert.showInfo(localisation.localizedString(key: "incidentreport.reporttitle"), subTitle: "")
*/
        
        self.hideKaypad()
        let alert = SCLAlertView()
        alert.showCloseButton = false
        //  alert.showCircularIcon = false
        
        let high = alert.addButton(self.localisation.localizedString(key: "tasks.high"),tag: 150 , action: {
           
            self.urgency = 3 // NON DTCM
            //  self.typeLbl.text = self.localisation.localizedString(key: "tasks.high")
            self.incidentBtn.setTitle(self.localisation.localizedString(key: "tasks.high"), for: UIControlState())
            self.priorityView.layer.borderColor = self.HIGHCOLOR.cgColor
            self.priorityView.layer.borderWidth = 1.0
            
            
        } )
        
        high.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
        
        let mediumColor = UIColor(red:246/255 , green: 142/255, blue: 90/255, alpha: 1.0)
        
        alert.addButton(self.localisation.localizedString(key: "tasks.medium"),tag : 100, action: {
           
            self.urgency = 2 // NON DTCM
            //self.typeLbl.text = self.localisation.localizedString(key: "tasks.medium")
             self.priorityView.layer.borderColor = self.MEDIUMCOLOR.cgColor
             self.priorityView.layer.borderWidth = 1.0
            
            self.incidentBtn.setTitle(self.localisation.localizedString(key: "tasks.medium"), for: UIControlState())
            
            
        } )
        
        
        
        
        let low = alert.addButton(self.localisation.localizedString(key: "tasks.low"),tag: 50 ,action: {
           
            self.urgency =  1 // DTCM
            //self.typeLbl.text = self.localisation.localizedString(key: "tasks.low")
            self.priorityView.layer.borderColor = self.LOWCOLOR.cgColor
            self.priorityView.layer.borderWidth = 1.0
            
            self.incidentBtn.setTitle(self.localisation.localizedString(key: "tasks.low"), for: UIControlState())
            
        } )
        
        low.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
        
        
        
        
        
        // alert.ad
        
        alert.addButton(localisation.localizedString(key: "questions.cancel"),tag:250 , action: {
           
            
        })
        
        alert.showInfo(localisation.localizedString(key: "tasks.selecturgency"), subTitle: "")
        

        
    }
    
    
    @IBAction func categoryMethod(_ sender: AnyObject) {
    
        
//        let alert = UIAlertController(title: localisation.localizedString(key: "company.selectcategory"), message: "", preferredStyle: UIAlertControllerStyle.Alert)
//        for i in self.categoryArray as! [CompanyCategoryDao]{
//            let action1 = UIAlertAction(title: i.category_name!, style: UIAlertActionStyle.Default, handler: {
//               
//                self.categoryBtn.setTitle(i.category_name, forState: UIControlState.Normal)
//                self.selectedCategory = i
//                
//            })
//            alert.addAction(action1)
//            
//        }
//        
//        let cancelAction = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.Cancel, handler: nil)
//        alert.addAction(cancelAction)
//        
//        self.presentViewController(alert, animated: true, completion: nil)
//        
        self.hideKaypad()
        
        let alert = SCLAlertView()
        alert.showCloseButton = false
        //  alert.showCircularIcon = false
        
        let high = alert.addButton(self.localisation.localizedString(key: "tasks.high"),tag: 150 , action: {
           
            self.urgency = 3 // NON DTCM
          //  self.typeLbl.text = self.localisation.localizedString(key: "tasks.high")
            self.categoryBtn.setTitle(self.localisation.localizedString(key: "tasks.high"), for: UIControlState())
            //self.priorityview.layer.borderColor = self.HIGHCOLOR.CGColor
            //self.priorityview.layer.borderWidth = 1.0
            
            
        } )
        
        high.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
        
        let mediumColor = UIColor(red:246/255 , green: 142/255, blue: 90/255, alpha: 1.0)
        
        alert.addButton(self.localisation.localizedString(key: "tasks.medium"),tag : 100, action: {
           
            self.urgency = 2 // NON DTCM
            //self.typeLbl.text = self.localisation.localizedString(key: "tasks.medium")
           // self.priorityview.layer.borderColor = self.MEDIUMCOLOR.CGColor
           // self.priorityview.layer.borderWidth = 1.0
            
            self.categoryBtn.setTitle(self.localisation.localizedString(key: "tasks.medium"), for: UIControlState())
            
            
        } )
        
        
        
        
        let low = alert.addButton(self.localisation.localizedString(key: "tasks.low"),tag: 50 ,action: {
           
            self.urgency =  1 // DTCM
            //self.typeLbl.text = self.localisation.localizedString(key: "tasks.low")
            //self.priorityview.layer.borderColor = self.LOWCOLOR.CGColor
            //self.priorityview.layer.borderWidth = 1.0
            
            self.categoryBtn.setTitle(self.localisation.localizedString(key: "tasks.low"), for: UIControlState())
            
        } )
        
        low.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
        
        
        
        
        
        // alert.ad
        
        alert.addButton(localisation.localizedString(key: "questions.cancel"),tag:250 , action: {
           
            
        })
        
        alert.showInfo(localisation.localizedString(key: "tasks.selecturgency"), subTitle: "")

        
    
    }// end of the method
    
    @IBOutlet weak var categoryBtn: UIButton!
    
    @IBOutlet weak var categoryLbl: UILabel!
    
    @IBOutlet weak var companyNameEnlbl: UILabel!
    
    @IBOutlet weak var companyNameTextField: UITextField!
    
    @IBOutlet weak var companyNameArlbl: UILabel!
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var companyNameArTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    let categoryArray = NSMutableArray()
    var selectedCategory : CompanyCategoryDao?
    
    @IBOutlet weak var incidentSubtitle: UILabel!
    
    
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var galleryImage: UIImageView!
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var notesTextView: UITextView!
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var mediaIds : String = ""
     var localisation : Localisation!
    
    var selectedImage : UIImage?
    var audioState : Int = 0
    
    
    @IBAction func closeButtonMethod(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func setupSubmitReport(){
        if Reachability.connectedToNetwork() {
            
           
            
            var alertMessage : String = ""
            if self.companyNameTextField.text == nil || self.companyNameTextField.text == "" {
                alertMessage = localisation.localizedString(key: "addunlicense.Addestablishmentname")
            }
            else if self.companyNameArTextField.text == nil || self.companyNameArTextField.text == ""  {
                alertMessage = localisation.localizedString(key: "addunlicense.Addestablishmentnameinarabic")
            }
            else if self.addressTextField.text == nil || self.addressTextField.text == "" {
                alertMessage = localisation.localizedString(key: "addunlicense.Addestablishmentaddress")
            }
           
            if alertMessage != "" {
               
                
                let newalert = SCLAlertView()
                newalert.showCloseButton = false
                newalert.addButton(localisation.localizedString(key: "questions.cancel"), action: { })
                
                newalert.showError(localisation.localizedString(key: "addunlicense.missinginfo"), subTitle: alertMessage)
                
                
                
                
                return
                
            }
            
            if self.notesTextView.text == nil || self.notesTextView.text == "" {
                
                let alert = SCLAlertView()
                alert.showCloseButton = false
                
                alert.addButton(localisation.localizedString(key: "questions.cancel"), action: {
                   
                    
                })
                
                alert.showError(localisation.localizedString(key: "addunlicense.missinginfo"), subTitle: localisation.localizedString(key: "history.addnotes"))
                return
            } // end of the if
            
            if self.urgency == 0 {
                let alert = SCLAlertView()
                alert.showCloseButton = false
                alert.addButton(localisation.localizedString(key: "questions.cancel"), action: {
                   
                    
                })
                alert.showError("", subTitle: localisation.localizedString(key: "tasks.selecturgency"))
                
                
                return
                
            }
            
            if self.audioId != "" {
                self.mediaIds = self.audioId
            }
            if self.imagesArray.count > 0 && self.mediaIds == "" {
                self.mediaIds = "\(self.firstImageId)"
                
            }
            else if self.imagesArray.count > 0 && self.mediaIds != "" {
                self.mediaIds = "\(self.mediaIds),\(self.firstImageId)"
                
                
            }
            if self.imagesArray.count > 1 {
                self.mediaIds = "\(self.mediaIds),\(self.secondImageId)"
                
            }
            
            if self.imagesArray.count > 2 {
                self.mediaIds = "\(self.mediaIds),\(self.thirdImageId)"
                
            }
            


            
           
            var reportUrl:String?
            if self.mediaIds != "" {
                if self.appDel.userLocation != nil {
                reportUrl = Constants.baseURL + "issueUnLicensedIncidentReport?inspector_id=" + self.appDel.user.user_id + "&companyName=\(self.companyNameTextField.text!)&companyName_Arb=\(self.companyNameArTextField.text!)&address=\(self.addressTextField.text!)&latitude=\(self.appDel.userLocation!.latitude)&longitude=\(self.appDel.userLocation!.longitude)&notes=\(self.notesTextView.text)&media=\(self.mediaIds)&source=Inspection-App&category=\(self.appDel.reportType!)&urgency=\(self.urgency)"
                }
                else {
                    reportUrl = Constants.baseURL + "issueUnLicensedIncidentReport?inspector_id=" + self.appDel.user.user_id + "&companyName=\(self.companyNameTextField.text!)&companyName_Arb=\(self.companyNameArTextField.text!)&address=\(self.addressTextField.text!)&notes=\(self.notesTextView.text)&media=\(self.mediaIds)&source=Inspection-App&category=\(self.appDel.reportType!)&urgency=\(self.urgency)"
                    
                }
            }
            else {
                if self.appDel.userLocation != nil {
                reportUrl = Constants.baseURL + "issueUnLicensedIncidentReport?inspector_id=" + self.appDel.user.user_id + "&companyName=\(self.companyNameTextField.text!)&companyName_Arb=\(self.companyNameArTextField.text!)&address=\(self.addressTextField.text!)&latitude=\(self.appDel.userLocation!.latitude)&longitude=\(self.appDel.userLocation!.longitude)&notes=\(self.notesTextView.text!)&source=Inspection-App&category=\(self.appDel.reportType!)&urgency=\(self.urgency)"
                }
                else {
                    reportUrl = Constants.baseURL + "issueUnLicensedIncidentReport?inspector_id=" + self.appDel.user.user_id + "&companyName=\(self.companyNameTextField.text!)&companyName_Arb=\(self.companyNameArTextField.text!)&address=\(self.addressTextField.text!)&notes=\(self.notesTextView.text)&source=Inspection-App&category=\(self.appDel.reportType!)&urgency=\(self.urgency)"
                    
                }
                
            }
            
            print("Report url \(reportUrl)")
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(reportUrl!, idn: "report")
        }
        
        
    }
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "report"{
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            print(str)
            if ((str?.contains("success")) != nil) {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    @objc func hideKaypad(){
    self.companyNameTextField.resignFirstResponder()
    self.companyNameArTextField.resignFirstResponder()
    self.addressTextField.resignFirstResponder()
    self.notesTextView.resignFirstResponder()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notesTextView.becomeFirstResponder()
        
        self.localisation = Localisation()
        
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
            
            //  self.userTextField.textAlignment = NSTextAlignment.Right
            // self.passwordField.textAlignment = NSTextAlignment.Right
            
            
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            
            
        }
        
        //print(self.appDel.user.lat)
        //print(self.appDel.user.lon)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateInspectionUnlicenseViewController.hideKaypad))
        self.view.addGestureRecognizer(tap)
         self.incidentReportTitle.text = self.localisation.localizedString(key: "incidentreport.reporttitle")
         self.incidentSubtitle.text = self.localisation.localizedString(key: "finalise.notes")
        
        
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_bg")!)
        // self.outerView.backgroundColor = UIColor(patternImage: UIImage(named: "tablebg")!)
        self.companyNameEnlbl.text = self.localisation.localizedString(key: "company.companyname")
       // self.categoryLbl.text = self.localisation.localizedString(key: "company.category")
        self.companyNameArlbl.text = self.localisation.localizedString(key: "company.namear")
        self.addressLbl.text = self.localisation.localizedString(key: "company.address")
        self.incidentReportTitle.text = self.localisation.localizedString(key: "incidentreport.title")
        //self.incidentSubtitle.text = self.localisation.localizedString(key: "incidentreport.title")
        self.cancelBtn.setTitle(self.localisation.localizedString(key: "questions.cancel"), for: UIControlState())
        self.saveBtn.setTitle(self.localisation.localizedString(key: "profile.saveinfo"), for: UIControlState())
        self.incidentBtn.setTitle(self.localisation.localizedString(key: "incidentreport.reporttitle"), for: UIControlState())
        //self.incidentSubtitle.setTitle(self.localisation.localizedString(key: "tasks.selecturgency"), forState: UIControlState.Normal)
        self.incidentLabel.text = self.localisation.localizedString(key: "tasks.selecturgency")
        self.incidentBtn.setTitle(self.localisation.localizedString(key: "tasks.selecturgency"), for: UIControlState())
        
        // Do any additional setup after loading the view.
    }
    
    
  @IBAction func deleteImage(_ sender : UIButton){
        if sender.tag == 0 {
            self.firstImageId = 0
            print("Removing first image")
            
        }
        else if sender.tag == 1 {
            self.secondImageId = 0
            print("Removing second image")
            
        }
        else if sender.tag == 2 {
            print("Removing third image")
            
            self.thirdImageId = 0
            
        }
        self.imagesArray.removeObject(at: sender.tag)
        print("Array size \(self.imagesArray.count)")
        self.resetImages()
        self.setupImages()
        
    }
    func resetImages(){
        self.firstImageCancel.isHidden = true
        self.firstImageBtn.isHidden = true
        self.firstUIImage = nil
        
        self.secondImageCancel.isHidden = true
        self.secondImageBtn.isHidden = true
        self.secondUIImage = nil
        
        
        self.thirdImageCancel.isHidden = true
        self.thirdImageBtn.isHidden = true
        self.thirdUIImage = nil
        
    }
    func setupImages(){
        if self.imagesArray.count > 0 {
            self.firstUIImage = self.imagesArray.object(at: 0) as! UIImage
            self.firstImageBtn.setImage(firstUIImage, for: UIControlState())
            self.firstImageBtn.isHidden = false
            firstImageBtn.layer.cornerRadius = firstImageBtn.frame.width / 2;
            firstImageBtn.layer.masksToBounds = true
            self.firstImageCancel.isHidden = false
            self.whichImage = 1
            
            
        }
        
        if self.imagesArray.count > 1 {
            self.secondUIImage = self.imagesArray.object(at: 1) as! UIImage
            
            
            self.secondImageBtn.isHidden = false
            self.secondImageBtn.setImage(secondUIImage, for: UIControlState())
            secondImageBtn.layer.cornerRadius = secondImageBtn.frame.width / 2;
            secondImageBtn.layer.masksToBounds = true
            self.secondImageCancel.isHidden = false
            self.whichImage = 2
            
        }
        
        if self.imagesArray.count > 2{
            self.thirdUIImage = self.imagesArray.object(at: 2) as! UIImage
            
            
            self.thirdImageBtn.setImage(thirdUIImage, for: UIControlState())
            self.thirdImageBtn.isHidden = false
            
            thirdImageBtn.layer.cornerRadius = thirdImageBtn.frame.width / 2;
            thirdImageBtn.layer.masksToBounds = true
            self.thirdImageCancel.isHidden = false
            self.whichImage = 3
            
            
            
        }
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
       // self.viewWillAppear(animated)
        self.view.superview?.layer.cornerRadius = 0;
        
    }
    
    @IBOutlet weak var audioBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    
    @IBAction func audioMethod(_ sender: AnyObject) {
        if audioState == 0 ||  audioState == -1 {
            if self.soundRecorder != nil && self.soundRecorder.isRecording {
                return
            }
            self.audioBtn.setImage(UIImage(named: "stoprecord"), for: UIControlState())
            //self.recordSound(sender)
            self.setupRecorder("record.m4a")
            self.soundRecorder.record()
            audioState = 1
            
            
        }
        else
            
            
            if self.audioState == 3 {
                self.soundPlayer.stop()
                self.audioBtn.setImage(UIImage(named: "play"), for: UIControlState())
                self.audioState = 2
                
            }
            else
                
                if self.audioState == 2 {
                    self.playSound()
                    audioState = 3
                    audioBtn.setImage(UIImage(named: "pause"), for: UIControlState())
                    //self.soundPlayer.pause()
                    
                    
                }
                else
                    if self.audioState == 1 {
                        audioBtn.setImage(UIImage(named: "play"), for: UIControlState())
                        self.soundRecorder.stop()
                        self.audioState = 2
                        
        }
        
        
        
    }
    
    
    @IBAction func saveMethod(_ sender: AnyObject) {
        self.hideKaypad()
        self.appDel.showIndicator = 1
        self.setupSubmitReport()
    }
    
    
    
    
    var soundRecorder: AVAudioRecorder!
    
    var soundPlayer:AVAudioPlayer!
    
    
    let fileName = "demo.mp4"
    
    
    func getCacheDirectory() -> String {
        
        
        
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask, true)
        
        
        
        return paths[0]
        
    }
    
    func preparePlayer(_ fname : String) {
        
        
        var error: NSError?
        
        
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: getFileURL(fname))
        } catch let error1 as NSError {
            error = error1
            soundPlayer = nil
        }
        catch {
        soundPlayer = nil
         // Catch any other errors
        }
        
        
        
        if let err = error {
            
            print("AVAudioPlayer error: \(err.localizedDescription)")
            
        } else {
            
            soundPlayer.delegate = self
            
            soundPlayer.prepareToPlay()
            
            soundPlayer.volume = 1.0
            
        }
        
    }
    
    
    
    
    func playSound() {
        
        
        
        
        preparePlayer("record.m4a")
        if soundPlayer != nil {
            soundPlayer.play()
            
        }
        
        //   soundPlayer.stop()
        
        
    }
    
    
    
    func setupRecorder(_ fname : String) {
        
        
        
        
        let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0) as Float),
                              AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC) as Int32),
                              AVNumberOfChannelsKey : NSNumber(value: 2 as Int32),
                              AVLinearPCMBitDepthKey : NSNumber(value: 16 as Int32),
                              AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue) as Int32),
                              AVEncoderBitRateKey : NSNumber(value: Int32(320000) as Int32)]
        
        
        
        
        
        var error: NSError?
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
        } catch var error1 as NSError {
            error = error1
        }
         catch {
    // Catch any other errors
    }
        
        if let err = error {
            print("audioSession error: \(err.localizedDescription)")
        }
        
        
        
        do {
            soundRecorder = try AVAudioRecorder(url: getFileURL(fname), settings: recordSettings as [String : AnyObject])
        } catch let error1 as NSError {
            error = error1
            soundRecorder = nil
        }
     catch {
    // Catch any other errors
    }
        
        
        
        if let err = error {
            
            print("AVAudioRecorder error: \(err.localizedDescription)")
            
        } else {
            
            soundRecorder.delegate = self
            
            soundRecorder.prepareToRecord()
            
        }
        
    }
    
    func getFileURL(_ fname : String) -> URL {
        
        
        
        let path = (getCacheDirectory() as NSString).appendingPathComponent(fname)
        
        let filePath = URL(fileURLWithPath: path)
        
        print(filePath)
        
        
        return filePath
        
    }
    
    
    
    
    @IBAction func cameraMethod(_ sender: AnyObject) {
        
        /*
        if self.appDel.incidentEnlargeImage != nil {
            let cnt = self.storyboard?.instantiateViewControllerWithIdentifier("cnt_enlarge") as! EnlargeIncidentImageViewController
            cnt.modalPresentationStyle = UIModalPresentationStyle.FormSheet
            
            self.presentViewController(cnt, animated: true, completion: nil)
        }
        else {
            let alert = SCLAlertView()
            alert.showCloseButton  = false
            //alert.title = "Select photo source"
            alert.addButton("Camera", action: {
               
                if UIImagePickerController.isSourceTypeAvailable(
                    UIImagePickerControllerSourceType.Camera) {
                    
                    let imagePicker = UIImagePickerController()
                    
                    imagePicker.delegate = self
                    imagePicker.sourceType =
                        UIImagePickerControllerSourceType.Camera
                    // imagePicker.mediaTypes = [kUTTypeImage as String]
                    imagePicker.allowsEditing = false
                    
                    self.presentViewController(imagePicker, animated: true,
                        completion: nil)
                    
                }
                
                
            })
            alert.addButton("Gallery", action: {
               
                
                if UIImagePickerController.isSourceTypeAvailable(
                    UIImagePickerControllerSourceType.PhotoLibrary) {
                    
                    let imagePicker = UIImagePickerController()
                    
                    imagePicker.delegate = self
                    imagePicker.sourceType =
                        UIImagePickerControllerSourceType.PhotoLibrary
                    // imagePicker.mediaTypes = [kUTTypeImage as String]
                    imagePicker.allowsEditing = false
                    
                    self.presentViewController(imagePicker, animated: true,
                        completion: nil)
                    
                }
                
                
                
            })
            
            alert.addButton("Cancel", action: {
               
                
            })
            
            alert.showInfo("Select photo source", subTitle: "")
            //self.presentViewController(alert, animated: true, completion: nil)
        }
        
        */
        
        
        let alert = SCLAlertView()
        alert.showCloseButton  = false
        //alert.title = "Select photo source"
        alert.addButton("Camera", action: {
           
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                self.whichImage = sender.tag
                
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.camera
                // imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = true
                
                self.present(imagePicker, animated: true,
                    completion: nil)
                
            }
            
            
        })
        alert.addButton("Gallery", action: {
           
            
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.photoLibrary) {
                
                let imagePicker = UIImagePickerController()
                self.whichImage = sender.tag
                print("Which Media \(self.whichImage)")
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.photoLibrary
                // imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: true,
                    completion: nil)
                
            }
            
            
            
        })
        
        alert.addButton("Cancel", action: {
           
            
        })
        
        alert.showInfo("Select photo source", subTitle: "")
        //self.presentViewController(alert, animated: true, completion: nil)
        //}

        
        
        
    }
    
    @IBAction func galleryMethod(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.photoLibrary
            // imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true,
                                       completion: nil)
            
        }
        
        
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if Reachability.connectedToNetwork() {
            let data =  try? Data(contentsOf: self.getFileURL("record.m4a"))
            self.createMultipart("audio.m4a",imageData:data, type : "audio")
        }
        
        //            }
        //
        
    }
    
    func createMultipart(_ filename : String  , imageData : Data? , type : String){
        
        
        let myUrl = URL(string: Constants.kUploadMedia);
        
        if imageData != nil{
            let request = NSMutableURLRequest(url: myUrl!)
            
            let session = URLSession.shared
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            PKHUD.sharedHUD.show()
            
            request.httpMethod = "POST"
            request.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
            
            
            var boundary = NSString(format: "---------------------------14737809831466499882746641449")
            var contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
            //  println("Content Type \(contentType)")
            request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            
            var body = NSMutableData()
            
            
            // Title
            body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data; name=\"media\"; filename=\"\(filename)\"\\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append(imageData!)
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            
            
            
            request.httpBody = body as Data
            
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler:{(response:URLResponse?, responseData:Data?, error: NSError?)  in
                PKHUD.sharedHUD.hide(animated: true)
                
                if error != nil
                {
                    print(error!.description)
                }
                else
                {
                    let responseStr:NSString = NSString(data:responseData!, encoding:String.Encoding.utf8.rawValue)!
                    print("Returning url \(responseStr)")
                    let parser =  JsonParser()
                    let str = parser.parseMedia(responseData!)
                    if str != "error"{
                        
//                        if self.mediaIds == nil {
//                            self.mediaIds = str
//                        } // end of the if
//                        else {
//                            self.mediaIds = self.mediaIds! + "," + str
//                            
//                        }
                        
                        
                        if type == "image" {
                            
                            //self.imageId = str + "," + self.imageId
                            if self.whichImage ==  1 {
                                self.firstImageId = Int(str)!
                            }
                            else if self.whichImage == 2 {
                                self.secondImageId = Int(str)!
                            }
                            else if self.whichImage == 3 {
                                self.thirdImageId = Int(str)!
                            }
                            
                            
                            
                            print("Which Image \(self.whichImage) first image \(self.firstImageId) second Image \(self.secondImageId) third Image \(self.thirdImageId)")
                            
                        }
                        else  if type == "audio" {
                            self.audioId = str
                        }

                        
                        
                    }
                }
            } as! (URLResponse?, Data?, Error?) -> Void)
            
            
            
            
            
        }
        else {
            print("data is null")
        }
        
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        
        print("Finish recording \(error)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        print("Finish Playing")
        self.audioBtn.setImage(UIImage(named: "play"), for: UIControlState())
        self.audioState = 2
    }
    
    
    
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
        print("Finish Playing error \(error)")
        
        
    }
    
    
    
    @IBOutlet weak var galleryBtn: UIButton!
    
    @IBAction func submitMethod(_ sender: AnyObject) {
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        
        
        self.appDel.incidentEnlargeImage = image
        self.imagesArray.add(image)
        self.setupImages()

        let imageData = UIImageJPEGRepresentation(image, 0.5)
        if Reachability.connectedToNetwork() {
            self.createMultipart("notes.jpeg"  , imageData: imageData , type: "image")
        }
        //self.cameraBtn.setImage(UIImage(named:"tickedimage"), forState: UIControlState.Normal)
        self.dismiss(animated: true, completion: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
