//
//  CreateIncidentViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 6/1/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import PKHUD
import EZLoadingActivity
protocol AddIncidentDelegate {
    func deleteNotif();
    
}


class CreateIncidentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,AVAudioRecorderDelegate  , AVAudioPlayerDelegate , MainJsonDelegate ,IncidentMediaDelegate,UITextFieldDelegate {
   
    @IBOutlet weak var incidentcommentslbl: UILabel!
    @IBOutlet weak var leftConst: NSLayoutConstraint!
    
    @IBOutlet weak var outerImageView: UIView!
    var imageCounter : Int = 0
    
    
    @IBOutlet weak var thirdImage: UIButton!
    
    @IBOutlet weak var firstBtn: UIButton!
    
    @IBAction func showFirstMethod(_ sender: UIButton) {
    self.deleteImage(sender)
    }
    
    
    @IBAction func firstImageMethod(_ sender: UIButton) {
        if self.imagesArray.count > 0 && self.appDel.showIncidentMedia == 1{
        let cnt = self.storyboard?.instantiateViewController(withIdentifier: "cnt_enlarge") as! EnlargeIncidentImageViewController
                    cnt.del = self
                    cnt.enlargeImage = self.imagesArray.object(at: 0) as? UIImage
            
                    cnt.modalPresentationStyle = UIModalPresentationStyle.formSheet
        
                    self.present(cnt, animated: true, completion: nil)
        }

    }
    
    
    @IBAction func thirdImageMethod(_ sender: AnyObject) {
        
        if self.imagesArray.count > 2 && self.appDel.showIncidentMedia == 1{
            let cnt = self.storyboard?.instantiateViewController(withIdentifier: "cnt_enlarge") as! EnlargeIncidentImageViewController
            cnt.del = self
            cnt.enlargeImage = self.imagesArray.object(at: 2) as? UIImage
            
            cnt.modalPresentationStyle = UIModalPresentationStyle.formSheet
            
            self.present(cnt, animated: true, completion: nil)
        }

    }
    
    
    @IBAction func secondImageMethod(_ sender: UIButton) {
        if self.imagesArray.count > 1 && self.appDel.showIncidentMedia == 1{
            let cnt = self.storyboard?.instantiateViewController(withIdentifier: "cnt_enlarge") as! EnlargeIncidentImageViewController
            cnt.del = self
            cnt.enlargeImage = self.imagesArray.object(at: 1) as? UIImage
            
            cnt.modalPresentationStyle = UIModalPresentationStyle.formSheet
            
            self.present(cnt, animated: true, completion: nil)
        }

    }
    
    
    
    @IBOutlet weak var secondBtn: UIButton!
    
    @IBAction func secondMethod(_ sender: UIButton) {
        self.deleteImage(sender)
        
    }
    
    
    
    
    @IBOutlet weak var thirdbtn: UIButton!
    
    
    @IBAction func thirdMethod(_ sender: UIButton) {
        self.deleteImage(sender)
        
    }
    
    var firstImageId:Int = 0
    var secondImageId : Int = 0
    var thirdImageId : Int = 0
    var firstUIImage : UIImage?
    var secondUIImage : UIImage?
    var thirdUIImage : UIImage?
    
    var whichImage : Int = 0 // 1 for first Image , 2 for second Image , 3 for third image
    var imagesArray : NSMutableArray = NSMutableArray()
    
    
    
    
    @IBOutlet weak var firstImage: UIButton!
    
    @IBOutlet weak var secondImage: UIButton!
    
    
    @IBOutlet weak var deleteAudioBtn: UIButton!
    
    
    @IBAction func deleteAudioMethod(_ sender: AnyObject) {
    self.appDel.notifDao!.incidentDao!.incidentMedia!.audio = nil
    audioBtn.setImage(UIImage(named:"recordiconreport"), for: UIControlState())
    self.deleteAudioBtn.isHidden = true
    self.deleteAudioBg.isHidden = true
    self.appDel.notifDao!.incidentDao!.incidentMedia!.audio_id = nil
    audioState = -1
        
        
        
    }
    
    @IBOutlet weak var deleteAudioBg: UIImageView!
    @IBOutlet weak var priorityview: UIView!
    @IBOutlet weak var incidentReportTitle: UILabel!
    @IBOutlet weak var addNotesLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var galleryImage: UIImageView!
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var notesTextView: UITextView!
    let LOWCOLOR : UIColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
    let MEDIUMCOLOR : UIColor =  UIColor(red:246/255 , green: 142/255, blue: 90/255, alpha: 1.0)
    let HIGHCOLOR : UIColor =  UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
    
    
    var userDefault : UserDefaults = UserDefaults.standard
    
    var report_type : Int = 0
    var urgency : Int = 0 // Green // 2 medium // 3 High
    
    
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var typeLbl: UILabel!
    
    @IBAction func showType(_ sender: AnyObject) {
        self.hideKeypad()
        let alert = SCLAlertView()
        alert.showCloseButton = false
      //  alert.showCircularIcon = false
        
        let high = alert.addButton(self.localisation.localizedString(key: "tasks.high"),tag: 150 , action: {
           
            self.urgency = 3 // NON DTCM
            self.typeLbl.text = self.localisation.localizedString(key: "tasks.high")
            self.typeBtn.setTitle(self.localisation.localizedString(key: "tasks.high"), for: UIControlState())
            self.priorityview.layer.borderColor = self.HIGHCOLOR.cgColor
            self.priorityview.layer.borderWidth = 1.0
            
            
        } )
        
        high.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
        
        let mediumColor = UIColor(red:246/255 , green: 142/255, blue: 90/255, alpha: 1.0)
        
        alert.addButton(self.localisation.localizedString(key: "tasks.medium"),tag : 100, action: {
            
            self.urgency = 2 // NON DTCM
            self.typeLbl.text = self.localisation.localizedString(key: "tasks.medium")
            self.priorityview.layer.borderColor = self.MEDIUMCOLOR.cgColor
            self.priorityview.layer.borderWidth = 1.0
            
            self.typeBtn.setTitle(self.localisation.localizedString(key: "tasks.medium"), for: UIControlState())
            
            
        } )
        

        
        
        let low = alert.addButton(self.localisation.localizedString(key: "tasks.low"),tag: 50 ,action: {
       
            self.urgency =  1 // DTCM
            self.typeLbl.text = self.localisation.localizedString(key: "tasks.low")
            self.priorityview.layer.borderColor = self.LOWCOLOR.cgColor
            self.priorityview.layer.borderWidth = 1.0
            
            self.typeBtn.setTitle(self.localisation.localizedString(key: "tasks.low"), for: UIControlState())
            
        } )
        
        low.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
        
        
        
        
      
       // alert.ad
    
        alert.addButton(localisation.localizedString(key: "questions.cancel"),tag:250 , action: {
           
            
        })
        
        
        
        
        alert.showInfo(localisation.localizedString(key: "tasks.selecturgency"), subTitle: "")
    }
    
    var localisation : Localisation!
    var mediaIds : String = ""
    var onlyAudioPlayer : AVAudioPlayer!
    var selectedImage : UIImage?
    var audioState : Int = 0
    var imageId : String = ""
    var audioId : String = ""
    
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func closeButtonMethod(_ sender: AnyObject) {
    self.appDel.showIncidentMedia = 0
    self.appDel.incidentEnlargeImage = nil
        self.dismiss(animated: true, completion: nil)
        
    }
    func deleteImage(){
    self.imageId = ""
        self.appDel.incidentEnlargeImage = nil
        if self.appDel.showIncidentMedia == 2 {
          self.appDel.notifDao?.incidentDao?.incidentMedia?.image = nil
          self.appDel.notifDao?.incidentDao?.incidentMedia?.image_id = nil
          cameraBtn.setImage(UIImage(named:"cameraiconreport"), for: UIControlState())
            
            
        }
    //self.cameraBtn.setImage(UIImage(named:"cameraiconreport"), forState: UIControlState.Normal)
    
    }
    
    func setupSubmitReport(){
        if Reachability.connectedToNetwork() {
            if self.appDel.showIncidentMedia == 2 {
               self.mediaIds = ""
                if self.appDel.notifDao!.incidentDao!.incidentMedia!.image_id != nil {
                self.mediaIds = self.appDel.notifDao!.incidentDao!.incidentMedia!.image_id!
                }
                
                if self.appDel.notifDao!.incidentDao!.incidentMedia!.audio_id != nil {
                self.audioId = self.appDel.notifDao!.incidentDao!.incidentMedia!.audio_id!
                }
                
//            if self.imageId != "" {
//            self.mediaIds = self.imageId
//            }
//                
//                
//            if self.audioId != "" && self.mediaIds == "" {
//            self.mediaIds = self.audioId
//            }
//            else {
//            self.mediaIds = self.mediaIds + "," + self.audioId
//            }
                
                
                
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
                
                
                
            if self.notesTextView.text == nil || self.notesTextView.text == "" {
            
               let alert = SCLAlertView()
                alert.showCloseButton = false
                alert.addButton("Cancel", action: {
               
                    
                })
                alert.showError("Add report notes", subTitle: "")
               return
            } // end of the if
            
            
            
            
            let aa = self.userDefault.double(forKey: "lat")
            let bb = self.userDefault.double(forKey: "lon")
             var company_id : Int = 0
                if let c = Int(self.appDel.notifDao!.incidentDao!.establishmentID!) {
                    company_id = c
                }
            

            
            
           
            
            var reportUrl:String?
                var completeData : NSMutableDictionary = NSMutableDictionary()
                self.appDel.showIndicator = 1
            if self.mediaIds != "" {
                if self.mediaIds == ","{
                self.mediaIds = ""
                }
                
                if aa != 0.0 {
              reportUrl = Constants.baseURL + "updateIncidentReport?incident_id=\(self.appDel.notifDao!.incidentDao!.incident_id!)&inspector_id=" + self.appDel.user.user_id! + "&notes=\(self.notesTextView.text!)&media=\(self.mediaIds)&source=Inspection-App&urgency=\(self.urgency)&latitude=\(aa)&longitude=\(bb)&category=\(self.appDel.notifDao!.incidentDao!.category!)"
                    completeData  = NSMutableDictionary()
                    

                   completeData.setObject(self.appDel.notifDao!.incidentDao!.incident_id!, forKey: "incident_id" as NSCopying)
                   completeData.setObject(self.appDel.user.user_id, forKey: "inspector_id" as NSCopying)
                   completeData.setObject(company_id, forKey: "company_id" as NSCopying)
                   completeData.setObject(self.notesTextView.text!, forKey: "notes" as NSCopying)
                   completeData.setObject(self.mediaIds, forKey: "media" as NSCopying)
                   completeData.setObject("Inspection-App", forKey: "source" as NSCopying)
                   completeData.setObject(aa, forKey: "latitude" as NSCopying)
                   completeData.setObject(bb, forKey: "longitude" as NSCopying)
                   completeData.setObject(self.urgency, forKey: "urgency" as NSCopying)
                    completeData.setObject(self.appDel.notifDao!.incidentDao!.category!, forKey: "category" as NSCopying)
                    
                    
                    
                    
                }
                else {
                    reportUrl = Constants.baseURL + "updateIncidentReport?incident_id=\(self.appDel.notifDao!.incidentDao!.incident_id!)&?inspector_id=" + self.appDel.user.user_id + "&notes=\(self.notesTextView.text)&media=\(self.mediaIds)&source=Inspection-App&urgency=\(self.urgency)&category=\(self.appDel.notifDao!.incidentDao!.category!)"
                    completeData  = NSMutableDictionary()

                    completeData.setObject(self.appDel.notifDao!.incidentDao!.incident_id!, forKey: "incident_id" as NSCopying)
                    completeData.setObject(self.appDel.user.user_id, forKey: "inspector_id" as NSCopying)
                    completeData.setObject(company_id, forKey: "company_id" as NSCopying)
                    completeData.setObject(self.notesTextView.text!, forKey: "notes" as NSCopying)
                    completeData.setObject(self.mediaIds, forKey: "media" as NSCopying)
                    completeData.setObject("Inspection-App", forKey: "source" as NSCopying)
                    completeData.setObject(self.urgency, forKey: "urgency" as NSCopying)
                    completeData.setObject(self.appDel.notifDao!.incidentDao!.category!, forKey: "category" as NSCopying)
                    
                    

                    
                    
                }
            }
            else {
                if aa != 0.0 {
                    reportUrl = Constants.baseURL + "updateIncidentReport?incident_id=\(self.appDel.notifDao!.incidentDao!.incident_id!)&inspector_id=" + self.appDel.user.user_id + "&notes=\(self.notesTextView.text)&source=Inspection-App&urgency=\(self.urgency)&latitude=\(aa)&longitude=\(bb)&category=\(self.appDel.notifDao!.incidentDao!.category!)"
                    
                    completeData  = NSMutableDictionary()
                    
                    completeData.setObject(self.appDel.notifDao!.incidentDao!.incident_id!, forKey: "incident_id" as NSCopying)
                    completeData.setObject(self.appDel.user.user_id, forKey: "inspector_id" as NSCopying)
                    completeData.setObject(company_id, forKey: "company_id" as NSCopying)
                    completeData.setObject(self.notesTextView.text, forKey: "notes" as NSCopying)
                    completeData.setObject("Inspection-App", forKey: "source" as NSCopying)
                    completeData.setObject(aa, forKey: "latitude" as NSCopying)
                    completeData.setObject(bb, forKey: "longitude" as NSCopying)
                    completeData.setObject(self.urgency, forKey: "urgency" as NSCopying)
                    completeData.setObject(self.appDel.notifDao!.incidentDao!.category!, forKey: "category" as NSCopying)
                    
                    
                    
                    
                }
                else {
                    reportUrl = Constants.baseURL + "updateIncidentReport?incident_id=\(self.appDel.notifDao!.incidentDao!.incident_id!)&inspector_id=" + self.appDel.user.user_id! + "&notes=\(self.notesTextView.text!)&source=Inspection-App&urgency=\(self.urgency)&category=\(self.appDel.notifDao!.incidentDao!.category!)"
                    completeData  = NSMutableDictionary()
                    
                    completeData.setObject(self.appDel.notifDao!.incidentDao!.incident_id!, forKey: "incident_id" as NSCopying)
                    completeData.setObject(self.appDel.user.user_id, forKey: "inspector_id" as NSCopying)
                    completeData.setObject(company_id, forKey: "company_id" as NSCopying)
                    completeData.setObject(self.notesTextView.text, forKey: "notes" as NSCopying)
                    completeData.setObject("Inspection-App", forKey: "source" as NSCopying)
                    completeData.setObject(self.urgency, forKey: "urgency" as NSCopying)
                    completeData.setObject(self.appDel.notifDao!.incidentDao!.category!, forKey: "category" as NSCopying)
                    


                    
                }
            }
            print("Report url \(reportUrl)")
                
                if company_id != 0 {
                    reportUrl = "\(reportUrl!)&company_id=\(company_id)"
                }

                
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
                if reportUrl != nil {
                downloader.startDownloader(reportUrl!, idn: "report")
                }
        
        }
        else {
                var completeData : NSMutableDictionary = NSMutableDictionary()

//            self.mediaIds = ""
//            if self.imageId != "" {
//                self.mediaIds = self.imageId
//            }
//            if self.audioId != "" && self.mediaIds == "" {
//                self.mediaIds = self.audioId
//            }
//            else {
//                self.mediaIds = self.mediaIds + "," + self.audioId
//            }

                
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

                
            if self.notesTextView.text == nil || self.notesTextView.text == "" {
                
                let alert = SCLAlertView()
                alert.showCloseButton = false
                alert.addButton(localisation.localizedString(key: "questions.cancel"), action: {
                   
                    
                })
                alert.showError(localisation.localizedString(key: "history.addnotes"), subTitle: "")
                
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
            
            let aa = self.userDefault.double(forKey: "lat")
            let bb = self.userDefault.double(forKey: "lon")
            var company_id : Int = 0
                
                if self.appDel.searchedCompany != nil {
                if let c = Int(self.appDel.searchedCompany!.company_id!) {
                    company_id = c
                }
                }

//            if self.appDel.reportType == 2 {
//                if let c = Int(self.appDel.externalOrg!.ID!) {
//                    company_id = c
//                }
//            }
//            else {
//                
//                if let c = Int(self.appDel.searchedCompany!.company_id!) {
//                    company_id = c
//                }
//            }
            
            
            
               
            
            var reportUrl:String?
            if self.mediaIds != "" {
                if self.mediaIds == ","{
                    self.mediaIds = ""
                }

                if aa != 0.0 {
                    reportUrl = Constants.baseURL + "issueIncidentReport?inspector_id=" + self.appDel.user.user_id! + "&notes=\(self.notesTextView.text!)&media=\(self.mediaIds)&source=Inspection-App&urgency=\(self.urgency)&latitude=\(aa)&longitude=\(bb)&category=\(self.appDel.reportType!)"
                    completeData = NSMutableDictionary()
                    
                    completeData.setObject(self.appDel.user.user_id, forKey: "inspector_id" as NSCopying)
                    completeData.setObject(company_id, forKey: "company_id" as NSCopying)
                    completeData.setObject(self.notesTextView.text, forKey: "notes" as NSCopying)
                    completeData.setObject(self.mediaIds, forKey: "media" as NSCopying)
                    completeData.setObject("Inspection-App", forKey: "source" as NSCopying)
                    completeData.setObject(self.urgency, forKey: "urgency" as NSCopying)
                    completeData.setObject(aa, forKey: "latitude" as NSCopying)
                    completeData.setObject(bb, forKey: "longitude" as NSCopying)
                    completeData.setObject(self.appDel.reportType!, forKey: "category" as NSCopying)
                    

                }
                else {
                    reportUrl = Constants.baseURL + "issueIncidentReport?inspector_id=" + self.appDel.user.user_id! + "&notes=\(self.notesTextView.text!)&media=\(self.mediaIds)&source=Inspection-App&urgency=\(self.urgency)&category=\(self.appDel.reportType!)"
                    
                    completeData = NSMutableDictionary()
                    
                    completeData.setObject(self.appDel.user.user_id, forKey: "inspector_id" as NSCopying)
                    completeData.setObject(company_id, forKey: "company_id" as NSCopying)
                    completeData.setObject(self.notesTextView.text, forKey: "notes" as NSCopying)
                    completeData.setObject(self.mediaIds, forKey: "media" as NSCopying)
                    completeData.setObject("Inspection-App", forKey: "source" as NSCopying)
                    completeData.setObject(self.urgency, forKey: "urgency" as NSCopying)
                    completeData.setObject(self.appDel.reportType!, forKey: "category" as NSCopying)
                    

                    
                }
            }
            else {
                if aa != 0.0 {
                    reportUrl = Constants.baseURL + "issueIncidentReport?inspector_id=" + self.appDel.user.user_id! + "&notes=\(self.notesTextView.text!)&source=Inspection-App&urgency=\(self.urgency)&latitude=\(aa)&longitude=\(bb)&category=\(self.appDel.reportType!)"
                    completeData = NSMutableDictionary()
                    
                    completeData.setObject(self.appDel.user.user_id, forKey: "inspector_id" as NSCopying)
                    completeData.setObject(company_id, forKey: "company_id" as NSCopying)
                    completeData.setObject(self.notesTextView.text, forKey: "notes" as NSCopying)
                    completeData.setObject("Inspection-App", forKey: "source" as NSCopying)
                    completeData.setObject(self.urgency, forKey: "urgency" as NSCopying)
                    completeData.setObject(aa, forKey: "latitude" as NSCopying)
                    completeData.setObject(bb, forKey: "longitude" as NSCopying)
                    completeData.setObject(self.appDel.reportType!, forKey: "category" as NSCopying)
                    
                    
                }
                else {
                    reportUrl = Constants.baseURL + "issueIncidentReport?inspector_id=" + self.appDel.user.user_id! + "&notes=\(self.notesTextView.text!)&source=Inspection-App&urgency=\(self.urgency)&category=\(self.appDel.reportType!)"
                    completeData = NSMutableDictionary()
                    
                    completeData.setObject(self.appDel.user.user_id, forKey: "inspector_id" as NSCopying)
                    completeData.setObject(company_id, forKey: "company_id" as NSCopying)
                    completeData.setObject(self.notesTextView.text, forKey: "notes" as NSCopying)
                    completeData.setObject("Inspection-App", forKey: "source" as NSCopying)
                    completeData.setObject(self.urgency, forKey: "urgency" as NSCopying)
                    completeData.setObject(self.appDel.reportType!, forKey: "category" as NSCopying)
                    

                    
                }
            }
            print("Report url \(reportUrl)")
                if company_id != 0 {
                reportUrl = "\(reportUrl!)&company_id=\(company_id)"
                }
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(reportUrl!, idn: "report")
        }

        }
     
    }
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "report"{
        let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        print(str)
            if ((str?.contains("success")) != nil) {
            self.dismiss(animated: true, completion: nil)
            self.appDel.incidentEnlargeImage = nil
            self.appDel.searchedCompany = nil
                
                
                
            }
        
        }
        if identity == "image" {
        let image = UIImage(data: data as Data)
         self.appDel.incidentEnlargeImage = image
           let cnt = self.storyboard?.instantiateViewController(withIdentifier: "cnt_enlarge") as! EnlargeIncidentImageViewController
            cnt.modalPresentationStyle = UIModalPresentationStyle.formSheet
            cnt.del = self
            self.present(cnt, animated: true, completion: nil)

        }
        if identity == "audio" {
            var error:NSError?
            
            do{
                self.onlyAudioPlayer = try  AVAudioPlayer(data: data as Data)
                self.onlyAudioPlayer.delegate = self
                self.onlyAudioPlayer.play()
                
                    self.audioBtn.setImage(UIImage(named: "pause"), for: UIControlState())
                
                
            }catch let error1 as NSError {
                error = error1
                self.onlyAudioPlayer = nil
                print(error)
            }

        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       // self.viewWillAppear(animated)
        self.view.superview?.layer.cornerRadius = 0;

    }
    
    func deleteImage(_ sender : UIButton){
        self.hideKeypad()
        if sender.tag == 0 {
        self.firstImageId = 0
         print("Removing first image")
            self.imageCounter = self.imageCounter - 1
            
            
        }
        else if sender.tag == 1 {
        self.secondImageId = 0
            print("Removing second image")
            self.imageCounter = self.imageCounter - 1
            
        }
        else if sender.tag == 2 {
            print("Removing third image")
            
            self.thirdImageId = 0
            self.imageCounter = self.imageCounter - 1
            
        }
      self.imagesArray.removeObject(at: sender.tag)
      print("Array size \(self.imagesArray.count)")
       self.resetImages()
       self.setupImages()
        
    }
    func resetImages(){
    self.firstBtn.isHidden = true
    self.firstImage.isHidden = true
    self.firstUIImage = nil
        
        self.secondBtn.isHidden = true
        self.secondImage.isHidden = true
        self.secondUIImage = nil
        
    
        self.thirdbtn.isHidden = true
        self.thirdImage.isHidden = true
        self.thirdUIImage = nil
        
    }
    func setupImages(){
        if self.imagesArray.count > 0 {
            self.firstUIImage = self.imagesArray.object(at: 0) as! UIImage
            self.firstImage.setImage(firstUIImage, for: UIControlState())
            self.firstImage.isHidden = false
            firstImage.layer.cornerRadius = firstImage.frame.width / 2;
            firstImage.layer.masksToBounds = true
            self.firstBtn.isHidden = false
            self.whichImage = 1
            
            
        }
        
        if self.imagesArray.count > 1 {
            self.secondUIImage = self.imagesArray.object(at: 1) as! UIImage
            
            
            self.secondImage.isHidden = false
            self.secondImage.setImage(secondUIImage, for: UIControlState())
            secondImage.layer.cornerRadius = firstImage.frame.width / 2;
            secondImage.layer.masksToBounds = true
            self.secondBtn.isHidden = false
            self.whichImage = 2
            
        }
        
        if self.imagesArray.count > 2{
            self.thirdUIImage = self.imagesArray.object(at: 2) as! UIImage

           
            self.thirdImage.setImage(thirdUIImage, for: UIControlState())
            self.thirdImage.isHidden = false
            
            thirdImage.layer.cornerRadius = firstImage.frame.width / 2;
            thirdImage.layer.masksToBounds = true
            self.thirdbtn.isHidden = false
            self.whichImage = 3
            
            
            
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.localisation = Localisation()
        
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
            
            //  self.userTextField.textAlignment = NSTextAlignment.Right
            // self.passwordField.textAlignment = NSTextAlignment.Right
            
            
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            
            
        }
        self.incidentcommentslbl.text = ""
        self.saveBtn.setTitle(localisation.localizedString(key: "finalise.submit"), for: UIControlState())
        self.incidentReportTitle.text = localisation.localizedString(key: "incidentreport.title")
        
        self.addNotesLbl.text = localisation.localizedString(key: "history.addnotes")
        self.typeBtn.setTitle(self.localisation.localizedString(key: "tasks.selecturgency"), for: UIControlState())
        
        
        if self.appDel.showIncidentMedia == 1 {
             self.typeBtn.isEnabled = false
              self.cameraBtn.isHidden = true
//            if self.appDel.taskDao.incidentDao?.image != nil {
//            cameraBtn.setImage(UIImage(named:"tickedimage"), forState: UIControlState.Normal)
//            }
//            else {
//            cameraBtn.hidden = true
//                
//            }
//            
            
            if self.appDel.taskDao.incidentMediaArray.count > 0 {
                print("Incident Count \(self.appDel.taskDao.incidentMediaArray.count)")
                var imageCount : Int = 0
                for a in 0  ..< self.appDel.taskDao.incidentMediaArray.count  {
                    let media = self.appDel.taskDao.incidentMediaArray.object(at: a) as! IncidentMediaDao
                    if media.media_type == 1
                    {
                        if imageCount == 0  {
                            firstImage.isHidden = false
                            let fullrul : String = Constants.downloadUrl + media.image!
                            let nsurl = URL(string: fullrul)
                            let data = try? Data(contentsOf: nsurl!)
                            
                            
                            
                            print(fullrul)
                            if data != nil {
                            let img = UIImage(data:data!)
                            
                            self.imagesArray.add(img!)
                            self.firstImageId = Int(media.image_id!)!
                            //self.setupImages()
                        self.imageCounter = 1
                                
                                
                            self.firstImage.setImage(img, for: UIControlState())
                            self.firstImage.isHidden = false
                            firstImage.layer.cornerRadius = firstImage.frame.width / 2;
                            firstImage.layer.masksToBounds = true
                            }
                            //self.firstImage.setImage(img!, forState: UIControlState.Normal)
                            
                        }
                        
                        if imageCount == 1  {
                            secondImage.isHidden = false
                            let fullrul : String = Constants.downloadUrl + media.image!
                            let nsurl = URL(string: fullrul)
                            let data = try? Data(contentsOf: nsurl!)
                            
                            print(fullrul)
                            self.imageCounter = 2
                            let img = UIImage(data:data!)
                            
                            self.imagesArray.add(img!)
                            self.secondImageId = Int(media.image_id!)!
                            //self.setupImages()
                            
                            self.secondImage.isHidden = false
                            self.secondImage.setImage(img, for: UIControlState())
                            secondImage.layer.cornerRadius = firstImage.frame.width / 2;
                            secondImage.layer.masksToBounds = true
                            
                            
                            
                        }
                        
                        
                        
                        if imageCount == 2  {
                            //thirdImage.hidden = false
                            
                            thirdImage.isHidden = false
                            let fullrul : String = Constants.downloadUrl + media.image!
                            let nsurl = URL(string: fullrul)
                            let data = try? Data(contentsOf: nsurl!)
                            
                            print(fullrul)
                            let img = UIImage(data:data!)
                            self.imagesArray.add(img!)

                            self.imageCounter = 3
                            self.thirdImageId = Int(media.image_id!)!
                            
                            self.thirdImage.setImage(img, for: UIControlState())
                            self.thirdImage.isHidden = false
                            
                            thirdImage.layer.cornerRadius = firstImage.frame.width / 2;
                            thirdImage.layer.masksToBounds = true
                            
                           // self.setupImages()
                            
                            
                            
                        }
                        
                        imageCount += 1
                    }
                    else {
                        
                        self.appDel.taskDao.incidentDao!.audio = media.audio!
                        self.appDel.taskDao.incidentDao!.audio_id = media.audio_id!
                        
                        audioBtn.setImage(UIImage(named:"play"), for: UIControlState())
                        self.deleteAudioBg.isHidden = false
                        self.deleteAudioBtn.isHidden = false
                        
                    }
                    
                }
            }
            
            

            
            
            
            if self.appDel.taskDao.incidentDao?.audio != nil {
               audioBtn.setImage(UIImage(named:"play"), for: UIControlState())
                self.deleteAudioBg.isHidden = true
                self.deleteAudioBtn.isHidden = true
                self.outerImageView.frame = CGRect(x: 96 , y: 60, width: 220, height: 48)

            }
            else{
            audioBtn.isHidden = true
                self.deleteAudioBg.isHidden = true
                self.deleteAudioBtn.isHidden = true
             
                
            }
        self.notesTextView.isEditable = false
        
            if self.appDel.taskDao.incidentDao != nil {
                if self.appDel.taskDao.incidentDao!.notes != nil {
           self.notesTextView.text = self.appDel.taskDao.incidentDao!.notes!
                }
            }
         self.saveBtn.isHidden = true
         self.cancelBtn.isHidden = true
            
            if self.appDel.taskDao!.incidentDao!.urgency!  == "1" {
                self.urgency =  1 // DTCM
                self.typeLbl.text = self.localisation.localizedString(key: "tasks.low")
                self.priorityview.layer.borderColor = self.LOWCOLOR.cgColor
                self.priorityview.layer.borderWidth = 1.0
                
                self.typeBtn.setTitle(self.localisation.localizedString(key: "tasks.low"), for: UIControlState())
                
                
            }
            else if self.appDel.taskDao!.incidentDao!.urgency! == "2" {
                self.urgency = 2 // NON DTCM
                self.typeLbl.text = self.localisation.localizedString(key: "tasks.medium")
                self.priorityview.layer.borderColor = self.MEDIUMCOLOR.cgColor
                self.priorityview.layer.borderWidth = 1.0
                
                self.typeBtn.setTitle(self.localisation.localizedString(key: "tasks.medium"), for: UIControlState())
                
            }
            else if self.appDel.taskDao!.incidentDao!.urgency! == "3" {
                self.urgency = 3 // NON DTCM
                self.typeLbl.text = self.localisation.localizedString(key: "tasks.high")
                self.typeBtn.setTitle(self.localisation.localizedString(key: "tasks.high"), for: UIControlState())
                self.priorityview.layer.borderColor = self.HIGHCOLOR.cgColor
                self.priorityview.layer.borderWidth = 1.0
                
            }

            
        }
        else if self.appDel.showIncidentMedia == 2 {
            self.typeBtn.isEnabled = false

            self.notesTextView.becomeFirstResponder()
            self.notesTextView.isEditable = true
//            if self.appDel.notifDao!.incidentDao!.incidentMedia?.image != nil {
//                cameraBtn.setImage(UIImage(named:"tickedimage"), forState: UIControlState.Normal)
//            }
//            else {
//                cameraBtn.hidden = false
//                
//            }
//            
//            if self.appDel.notifDao!.incidentDao!.incidentMedia?.audio != nil {
//                audioBtn.setImage(UIImage(named:"play"), forState: UIControlState.Normal)
//                self.deleteAudioBg.hidden = false
//                self.deleteAudioBtn.hidden = false
//            }
//            else{
//                audioBtn.hidden = false
//                self.deleteAudioBg.hidden = true
//                self.deleteAudioBtn.hidden = true
//
//                
//            }
            
            
            audioBtn.isHidden = false
            self.deleteAudioBg.isHidden = true
            self.deleteAudioBtn.isHidden = true

            if self.appDel.notifDao!.incidentDao!.incidentMediaArray.count > 0 {
                var imageCount : Int = 0
                for a in 0  ..< self.appDel.notifDao!.incidentDao!.incidentMediaArray.count  {
                let media = self.appDel.notifDao!.incidentDao!.incidentMediaArray.object(at: a) as! IncidentMediaDao
                    if media.media_type == 1
                    {
                        if imageCount == 0  {
                              firstImage.isHidden = false
                               let fullrul : String = Constants.downloadUrl + media.image!
                            
                                
                             let nsurl = URL(string: fullrul)
                            if nsurl != nil {
                            let data = try? Data(contentsOf: nsurl!)
                                if data != nil {
                            print(fullrul)
                            let img = UIImage(data:data!)
                            self.imageCounter = 1
                           self.imagesArray.add(img!)
                           self.firstImageId = Int(media.image_id!)!
                           self.setupImages()
                                }
                            }
                           //self.firstImage.setImage(img!, forState: UIControlState.Normal)

                        }
                        
                        if imageCount == 1  {
                            secondImage.isHidden = false
                            let fullrul : String = Constants.downloadUrl + media.image!
                            let nsurl = URL(string: fullrul)
                            if nsurl != nil {
                                
                            let data = try? Data(contentsOf: nsurl!)
                            if data != nil {
                            print(fullrul)
                            let img = UIImage(data:data!)
                            self.imageCounter = 2
                            self.imagesArray.add(img!)
                            self.secondImageId = Int(media.image_id!)!
                            self.setupImages()
                            }
                            }
                        }
                        
                        
                        
                        if imageCount == 2  {
                            //thirdImage.hidden = false
                        
                            thirdImage.isHidden = false
                            let fullrul : String = Constants.downloadUrl + media.image!
                            let nsurl = URL(string: fullrul)
                            if nsurl != nil {
                            let data = try? Data(contentsOf: nsurl!)
                            self.imageCounter = 3
                            
                            print(fullrul)
                                if data != nil {
                                    
                                let img = UIImage(data:data!)
                            
                            self.imagesArray.add(img!)
                            self.thirdImageId = Int(media.image_id!)!
                            self.setupImages()
                            
                            }
                            }
                        }
                    
                        imageCount += 1
                    }
                    else {
                        self.appDel.notifDao!.incidentDao!.incidentMedia!.audio = media.audio!
                        self.appDel.notifDao!.incidentDao!.incidentMedia!.audio_id = media.audio_id!
                        
                        audioBtn.setImage(UIImage(named:"play"), for: UIControlState())
                         self.deleteAudioBg.isHidden = false
                        self.deleteAudioBtn.isHidden = false
                     
                 }
                    
                }
            }
            
            
            if self.appDel.notifDao!.incidentDao!.notes != nil {
            self.notesTextView.text = self.appDel.notifDao!.incidentDao!.notes!
            }
            if self.appDel.notifDao!.incidentDao!.incident_comments != nil {
                print("Notif Dao is \(self.appDel.notifDao!.incidentDao!.incident_comments)")
                
            self.incidentcommentslbl.text = self.appDel.notifDao!.incidentDao!.incident_comments!.replacingOccurrences(of: "\r\n", with: " ")
                
                
                self.incidentcommentslbl.text = self.localisation.localizedString(key: "finalise.notes") + ":" + self.incidentcommentslbl.text!
                
                //print("Incident comments \(self.localisation.localizedString(key: "finalise.notes") + ":" + self.appDel.notifDao!.incidentDao!.incident_comments!)")
                
                
            }
            if self.appDel.notifDao!.incidentDao!.urgency != nil {
            if self.appDel.notifDao!.incidentDao!.urgency!  == "1" {
                self.urgency =  1 // DTCM
                self.typeLbl.text = self.localisation.localizedString(key: "tasks.low")
                self.priorityview.layer.borderColor = self.LOWCOLOR.cgColor
                self.priorityview.layer.borderWidth = 1.0
                
                self.typeBtn.setTitle(self.localisation.localizedString(key: "tasks.low"), for: UIControlState())
                
                
            }
            else if self.appDel.notifDao!.incidentDao!.urgency! == "2" {
                self.urgency = 2 // NON DTCM
                self.typeLbl.text = self.localisation.localizedString(key: "tasks.medium")
                self.priorityview.layer.borderColor = self.MEDIUMCOLOR.cgColor
                self.priorityview.layer.borderWidth = 1.0
                
                self.typeBtn.setTitle(self.localisation.localizedString(key: "tasks.medium"), for: UIControlState())
                
            }
            else if self.appDel.notifDao!.incidentDao!.urgency! == "3" {
                self.urgency = 3 // NON DTCM
                self.typeLbl.text = self.localisation.localizedString(key: "tasks.high")
                self.typeBtn.setTitle(self.localisation.localizedString(key: "tasks.high"), for: UIControlState())
                self.priorityview.layer.borderColor = self.HIGHCOLOR.cgColor
                self.priorityview.layer.borderWidth = 1.0
                
            }
            
            }
            
            
            
        }
        else {
        self.notesTextView.becomeFirstResponder()
            self.notesTextView.isEditable = true
            self.deleteAudioBg.isHidden = true
            self.deleteAudioBtn.isHidden = true
          //  self.outerImageView.frame = CGRectMake(30 , 60, 220, 48)
            self.leftConst.constant = self.leftConst.constant - 26
            self.view.layoutIfNeeded()


            
            
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(CreateIncidentViewController.hideKeypad))
        self.view.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
    
    }
    @objc func hideKeypad(){
    self.notesTextView.resignFirstResponder()
    }
    
    @IBOutlet weak var audioBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!

    @IBAction func audioMethod(_ sender: AnyObject) {
        if self.appDel.showIncidentMedia == 1 && self.appDel.taskDao.incidentDao != nil {
            if self.appDel.taskDao.incidentDao!.audio != nil {
            self.appDel.showIndicator = 1
            if self.onlyAudioPlayer != nil {
                if self.onlyAudioPlayer.isPlaying {
                   
                    
                    self.onlyAudioPlayer.stop()
                    self.audioBtn.setImage(UIImage(named: "play"), for: UIControlState())
                    
                    return
                    
                    
                }
            }
            let fullrul : String = Constants.downloadUrl + self.appDel.taskDao.incidentDao!.audio!
            print(fullrul)
            
                let datadownloader:DataDownloader = DataDownloader()
            datadownloader.delegate = self
            //var loginUrl = Constants.baseURL + "getTaskQuestionList?list_id=" + tasks.list_id
            datadownloader.startDownloader(fullrul, idn: "audio")
            }
            
            return
            
        }
        
        if self.appDel.showIncidentMedia == 2 {
        
            if self.appDel.notifDao?.incidentDao != nil {
                if self.appDel.notifDao!.incidentDao!.incidentMedia != nil {
                     if self.appDel.notifDao!.incidentDao!.incidentMedia?.audio != nil {
                self.appDel.showIndicator = 1
                if self.onlyAudioPlayer != nil {
                    if self.onlyAudioPlayer.isPlaying {
                        
                        
                        self.onlyAudioPlayer.stop()
                        self.audioBtn.setImage(UIImage(named: "play"), for: UIControlState())
                        
                        return
                        
                        
                    }
                }
                let fullrul : String = Constants.downloadUrl + self.appDel.notifDao!.incidentDao!.incidentMedia!.audio!
                print(fullrul)
                
                let datadownloader:DataDownloader = DataDownloader()
                datadownloader.delegate = self
                //var loginUrl = Constants.baseURL + "getTaskQuestionList?list_id=" + tasks.list_id
                datadownloader.startDownloader(fullrul, idn: "audio")
             return
                    }
            }
            }
           

            
        }

        
        
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
        
        if let err = error {
            print("audioSession error: \(err.localizedDescription)")
        }
        
        
        
        do {
            soundRecorder = try AVAudioRecorder(url: getFileURL(fname), settings: recordSettings as [String : AnyObject])
        } catch let error1 as NSError {
            error = error1
            soundRecorder = nil
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
    


    
    @IBAction func cameraMethod(_ sender: UIButton) {
//        if   self.appDel.showIncidentMedia == 1 && self.appDel.taskDao.incidentDao != nil  {
//            if self.appDel.taskDao.incidentDao?.image != nil {
//            self.appDel.showIndicator = 1
//            // Constants.kMediaBaseUrl
//            //let fullrul : String = "http://einspection.net/uploads/" + button.mediaId
//            let fullrul : String = Constants.downloadUrl + self.appDel.taskDao.incidentDao!.image!
//            
//            print(fullrul)
//           
//            let datadownloader:DataDownloader = DataDownloader()
//            datadownloader.delegate = self
//            self.appDel.showIndicator = 1
//            //var loginUrl = Constants.baseURL + "getTaskQuestionList?list_id=" + tasks.list_id
//            datadownloader.startDownloader(fullrul, idn: "image")
//        return
//            }
//        }
//        if self.appDel.showIncidentMedia == 2 {
//            if self.appDel.notifDao?.incidentDao?.incidentMedia!.image != nil {
//                self.appDel.showIndicator = 1
//                // Constants.kMediaBaseUrl
//                //let fullrul : String = "http://einspection.net/uploads/" + button.mediaId
//                let fullrul : String = Constants.downloadUrl + self.appDel.notifDao!.incidentDao!.incidentMedia!.image!
//                
//                print(fullrul)
//                
//                let datadownloader:DataDownloader = DataDownloader()
//                datadownloader.delegate = self
//                self.appDel.showIndicator = 1
//                //var loginUrl = Constants.baseURL + "getTaskQuestionList?list_id=" + tasks.list_id
//                datadownloader.startDownloader(fullrul, idn: "image")
//                return
//            }
//
//        }
//        
//
//        
//        if self.appDel.incidentEnlargeImage != nil {
//        let cnt = self.storyboard?.instantiateViewControllerWithIdentifier("cnt_enlarge") as! EnlargeIncidentImageViewController
//            cnt.del = self
//            cnt.modalPresentationStyle = UIModalPresentationStyle.FormSheet
//            
//            self.presentViewController(cnt, animated: true, completion: nil)
//        }
//        else {
        self.hideKeypad()
        print("Image Counter \(self.imageCounter)")
        
        if self.imageCounter < 3 {
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
        else {
             SCLAlertView().showError("", subTitle: "You can not add more than 3 images")
        
        }
        
        
        
    }
    
    @IBAction func galleryMethod(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.photoLibrary
            // imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            
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
            var request = URLRequest(url: myUrl!)
            
            let session = URLSession.shared
            //PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            //PKHUD.sharedHUD.show()
           //  EZLoadingActivity.show("Loading...", disableUI: false)
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
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                //PKHUD.sharedHUD.hide(animated: true)
              //  EZLoadingActivity.hide(true, animated: true)
                if error != nil
                {
                    print(error!.localizedDescription)
                }
                else
                {
                    let responseStr:NSString = NSString(data:data!, encoding:String.Encoding.utf8.rawValue)!
                    print("Returning url \(responseStr)")
                    let parser =  JsonParser()
                    let str = parser.parseMedia(data!)
                    if str != "error"{
                        if type == "image" {
                            
                                //self.imageId = str + "," + self.imageId
                                if self.whichImage ==  1 {
                                self.firstImageId = Int(str)!
                                self.imageCounter = self.imageCounter + 1
                                    
                                    
                                }
                                else if self.whichImage == 2 {
                                self.secondImageId = Int(str)!
                                self.imageCounter = self.imageCounter + 1
                                    
                                }
                                else if self.whichImage == 3 {
                                self.thirdImageId = Int(str)!
                                self.imageCounter = self.imageCounter + 1
                                    
                            }
                            
                            
                            
                            //                          print("Which Image \(self.whichImage) first image \(self.firstImageId) second Image \(self.secondImageId) third Image \(self.thirdImageId)")
                            
                        }
                        else  if type == "audio" {
                        self.audioId = str
                            print("Audio Str \(self.audioId)")
                        }
//                        if self.mediaIds == nil {
//                        self.mediaIds = str
//                        } // end of the if
//                        else {
//                        self.mediaIds = self.mediaIds! + "," + str
//                            
//                        }
                        
                    }
                }
            })
            
            
            task.resume()
            
            
            
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
    
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
          //  let customPicker : CustomImageController =  picker as! CustomImageController
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
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
