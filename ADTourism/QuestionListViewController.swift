//
//  QuestionListViewController.swift
//  ADTourism
//
//  Created by Administrator on 8/26/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit
import AVFoundation
import PKHUD
import ANLoader

////// THE MONSTER CLASS///////

class QuestionListViewController: UIViewController , MainJsonDelegate , UITableViewDataSource, UITableViewDelegate , NotesDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate , AVAudioRecorderDelegate  , AVAudioPlayerDelegate , DateSelectorDelegate , ViolationDelegate, ReasonDelegate , UITextFieldDelegate , FinishDelegate,MultiImageDelegae  {
    
    @IBOutlet weak var selectAllView: UIView!
    @IBOutlet weak var norecordsLbl: UILabel!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var timeSpentlbl: UILabel!
    @IBOutlet weak var timerlbl: UILabel!
    var allImagesBank : NSMutableDictionary = NSMutableDictionary()
    var amount8501 : String?
    var amount8502 :String?
    var company_detail_pressed : Int = 0
    var permit_pressed : Int = 0
    var cameraSender : ADButton?
    var questionCategories : NSMutableArray = NSMutableArray()
    var isExpanded : Int = 0
    var expandedIndex : Int = -1
    var tempQuesttions = NSMutableArray()
    var questionStorageArray = NSMutableArray()
    
    
    
    @IBOutlet weak var permitBtn: UIButton!
    
    var selectAll : Int = -1
    
  
    @IBAction func permitMethod(_ sender: AnyObject) {
    
        if self.appDel.taskDao.permitDao != nil  {
            self.appDel.selectedPermit = self.appDel.taskDao.permitDao
            self.company_detail_pressed = 1
            let cnt = storyboard?.instantiateViewController(withIdentifier: "cnt_fileview") as? FileViewController
            self.navigationController?.pushViewController(cnt!, animated: true)
            self.permit_pressed = 1
            
            
        }
        
        
    }
    
    var searchedArry : NSMutableArray = NSMutableArray()
    var recordButtonsDictionary : NSMutableDictionary = NSMutableDictionary()
    
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var companyDetailBtn: UIButton!
    
    var localisation : Localisation!
    var viewdisapearing : Int  = 0 // 0 normally 1 with camera or something else
   
       @IBAction func selectAllMethod(_ sender: AnyObject) {
        self.searchField.resignFirstResponder()
        if self.selectAll == 0 || self.selectAll == -1 {
            self.selectAll = 1
            // self.selectAllBtn.setImage(UIImage(named: "", forState:UIControlState.Normal))
            self.selectAllBtn.setImage(UIImage(named: "toggle_on"), for: UIControlState())
           
            
            self.questionsTable.reloadData()
            
        }
        else if self.selectAll == 1{
            self.selectAllBtn.setImage(UIImage(named: "toggle"), for: UIControlState())
            self.selectAll = 0
            
            self.questionsTable.reloadData()
            deselectAllQuestion()
            
        }
    }
    
    var timerSecond : Int = 0
    var calulatedWarnings : NSMutableDictionary = NSMutableDictionary()
    var trackSelectedQuestions : NSMutableDictionary = NSMutableDictionary()
    var isSearching: Int  = 0
    var processTask : Int = 0
    var cameraShown : Int = 0
    var usersSelectedQuestions : NSMutableDictionary = NSMutableDictionary()
    
    
    
    
    
    /*  Show Result creiteria , it can show results if co-assign is present or it can show result if coming from history
     
     
     
     */
    
    
    // MARK:- TEXTFIELD DELEGATE
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
         print(textField.text)
        if self.appDel.fromHistoryToResult == 1 {
            if let txt = textField as? MarginTextField {
            let downloader = DataDownloader()
            downloader.delegate = self
            downloader.iden = "updatequestions"
            let url = URL(string: Constants.baseURL + "updateInspectionQuestions")
            
            if self.appDel.user.user_id != nil && self.appDel.history_task!.id != nil && txt.question_id != nil && txt.extraOptionId != nil {
                
                downloader.sendPostQuestionChange(url!, inspector_id: self.appDel.user.user_id, task_id: self.appDel.history_task!.id! , question_id: txt.question_id!, extra_option_id: txt.extraOptionId!,td_amount: textField.text)
            }
        
        }
        }
        return true
    }
    
    
    func reasonSelected(_ reason : String ,  reasonnotes : String)
    {
        
        self.appDel.showIndicator = 0
        
        var isclosed : Int = 0
        if reason == "الشركة غير موجودة" {
        
        isclosed = 1
        }
        else {
            isclosed = 0
            
        }
        
        var loginUrl = ""
        let date = Date()
        
        let completedTime = Int64(date.timeIntervalSince1970 * 1000)
        
            if self.appDel.taskDao.task_id == "0" {
                
                // this condition if task is created offline so its task_id is 0
               
                
                if  self.appDel.taskDao.uniqueid != nil {
                    let str = DataDownloader().getOfflineCloseTasksForClosedTasks(offlineIdentifier: self.appDel.taskDao.uniqueid!, coInspectorsIDs: self.appDel.taskDao.coninspectors, unfinishedNotes: reasonnotes, unfinishedReason: reason, is_closed: "\(isclosed)")
                    print("Unique Id \(self.appDel.taskDao.uniqueid!)")
                    self.saveTasksToDatabase(json_string: str, task_id:self.appDel.taskDao.task_id  , unique_id: self.appDel.taskDao.uniqueid!, type : 12)
                    self.navigationController?.popToRootViewController(animated: true)
                     self.databaseManager.changeStatusOffline( self.appDel.taskDao.uniqueid!)
                }
                else {
                    
                    let str = DataDownloader().getOfflineCloseTasksForClosedTasks(offlineIdentifier: self.appDel.unique, coInspectorsIDs: self.appDel.taskDao.coninspectors, unfinishedNotes: reasonnotes, unfinishedReason: reason, is_closed: "\(isclosed)")
                    
                    self.saveTasksToDatabase(json_string: str, task_id:self.appDel.taskDao.task_id  , unique_id: self.appDel.unique, type : 12)
                    self.navigationController?.popToRootViewController(animated: true)
                }
               

                //self.databaseManager.changeStatus(self.appDel.taskDao.task_id)
            } else {
                // This else if task created online and its Task id is null
                 loginUrl = Constants.baseURL + "setTaskClosedNotes?task_id=" + self.appDel.taskDao.task_id + "&inspector_id=\(self.appDel.user.user_id!)&unfinished_note=\(reasonnotes)&unfinished_reason=\(reason)&is_closed=\(isclosed)&company_id=\(self.appDel.taskDao.company.company_id!)"
      
             if self.appDel.currentZoneTask != nil {
            if self.appDel.currentZoneTask!.zoneStatus == "started" {
                //completeData.setObject(self.appDel.currentZoneTask!.task_id!, forKey: "zone_id")
                loginUrl = Constants.baseURL + "setTaskClosedNotes?task_id=" + self.appDel.taskDao.task_id + "&inspector_id=\(self.appDel.user.user_id!)&unfinished_note=\(reasonnotes)&unfinished_reason=\(reason)&is_closed=\(isclosed)&company_id=\(self.appDel.taskDao.company.company_id!)&zone_id=\(self.appDel.currentZoneTask!.task_id!)"

            } // end of the zone started
     
        } // end of the

        
        
        
        if Reachability.connectedToNetwork() {
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            self.appDel.showIndicator = 0
            
            downloader.startDownloader(loginUrl, idn: "notready")
            self.databaseManager.changeStatus(self.appDel.taskDao.task_id)
            self.dontSet = 1
            
            self.navigationController?.popToRootViewController(animated: true)

            
        }
        else {
            if self.appDel.taskDao.task_id != "0" && self.appDel.taskDao.task_id != nil {
                
                
                self.saveTasksToDatabase(json_string: loginUrl, task_id:self.appDel.taskDao.task_id  , unique_id: self.appDel.unique, type : 4)
                self.databaseManager.changeStatus(self.appDel.taskDao.task_id)
                
               
                self.appDel.user.status = "active"
                self.userDefault.synchronize()
                
                
            }
            else {
                
                
            }
            self.navigationController?.popToRootViewController(animated: true)
            //self.navigationController?.popViewControllerAnimated(true)
        }
            }
        
        
        
        
        
        
    }
    
    @IBOutlet weak var timeOuterView: UIView!
    var secondsTimer : Timer?
    
    @IBAction func siteNotReady(_ sender: AnyObject) {
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "cnt_reasonNav") as! UINavigationController
        let cnt : ReasonNotCompleteViewController = storyboard?.instantiateViewController(withIdentifier: "cnt_reason")  as! ReasonNotCompleteViewController
        
        
        
        
        cnt.delegate = self
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            cnt.modalPresentationStyle = UIModalPresentationStyle.formSheet
        }
        else {
        cnt.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        }
        present(cnt, animated: true, completion: nil)
        
        /*
         if Reachability.connectedToNetwork() {
         
         }
         else {
         let alert : UIAlertController = UIAlertController(title:"Please check internet connection", message: "", preferredStyle: UIAlertControllerStyle.Alert)
         let action1 : UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
         alert.addAction(action1)
         self.presentViewController(alert, animated: true, completion: nil)
         
         return
         }
         
         
         let alert = UIAlertController(title: localisation.localizedString(key: "questions.unfinish"), message: "", preferredStyle: UIAlertControllerStyle.Alert)
         let action = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.Default, handler: {
        
         self.siteNotreadyTasks()
         })
         alert.addAction(action)
         
         let cancel = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.Cancel, handler: nil)
         alert.addAction(cancel)
         
         self.presentViewController(alert, animated: true, completion: nil)
         //self.siteNotreadyTasks()
         
         */
        
    }
    @IBOutlet weak var submitbtn: UIBarButtonItem!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var notesBtn: ADButton!
    let userDefault : UserDefaults = UserDefaults.standard
    
    var dontSet : Int = 0
    let databaseManager = DatabaseManager()
    
    
    @IBOutlet weak var questionsTable: UITableView!
    var onlyAudioPlayer : AVAudioPlayer!
    var resultSubmitted : Int = 0
    
    @IBOutlet weak var siteNotReadyBtn: UIButton!
    
    
    var ausioPlayer : AVPlayer!
    
    var currentBtn : ADButton!
    var selectedImage : UIImage!
    var allImage : NSMutableDictionary = NSMutableDictionary()
    var allVideos : NSMutableDictionary = NSMutableDictionary()
    var allDates : NSMutableDictionary = NSMutableDictionary()
    var violations : NSMutableDictionary = NSMutableDictionary()
    var warningArray : NSMutableArray = NSMutableArray()
    var indexPathBank : NSMutableDictionary = NSMutableDictionary()
    var selectedQuestionBank : NSMutableDictionary = NSMutableDictionary()
    var allImages : NSMutableDictionary = NSMutableDictionary()
    
    
    
    @IBOutlet weak var submitBtn: UIButton!
    var checkedRows=Set<IndexPath>()
    
    
    
    
    var soundRecorder: AVAudioRecorder!
    
    var soundPlayer:AVAudioPlayer!
    
    
    let fileName = "demo.mp4"
    
    
    func getCacheDirectory() -> String {
        
        
        
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask, true)
        
        
        
        return paths[0]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDel = UIApplication.shared.delegate as! AppDelegate
         self.navigationController?.isNavigationBarHidden = true
        self.secondsTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(QuestionListViewController.countSeconds), userInfo: nil, repeats: true)
        self.company_detail_pressed = 0
        self.appDel.showCompanyDetail = 0
        
        if self.appDel.taskDao != nil {
        if self.appDel.taskDao.permitDao != nil {
            self.permitBtn.isHidden = false
            self.companyDetailBtn.isHidden = true
            
        } // end of the if
        else {
            self.permitBtn.isHidden = true
            self.companyDetailBtn.isHidden = false
            
        } // end of the else
            
        } // end of the taskDao 
        
        if self.permit_pressed == 1 {
        self.navigationController?.isNavigationBarHidden = true
        }
        if UIDevice.current.userInterfaceIdiom == .phone {
        self.navigationController? .setNavigationBarHidden(true, animated:true)
        }
        self.questionsTable.reloadData()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("view dis apread")
        if self.secondsTimer != nil {
            self.secondsTimer!.invalidate()
        }
        if self.appDel.fromHistoryToResult == 0 && self.resultSubmitted == 0 && self.appDel.show_result != 1 && self.dontSet == 0 && processTask != 1 && self.cameraShown == 0 && self.company_detail_pressed != 1 && self.appDel.selectedIndividual == nil{
            if Reachability.connectedToNetwork() {
                print("deactivate tasks")
                
                self.appDel.deactiveTask(self.appDel.taskDao.task_id)
            } // end of the
        }
    }
    
    
    func getFileURL(_ fname : String) -> URL {
        
        
        print("File Name is \(fname)")
        
        let path = (getCacheDirectory() as NSString).appendingPathComponent(fname)
        
        let filePath = URL(fileURLWithPath: path)
        
        print(filePath)
        
        
        return filePath
        
    }
    
    
    
    
    func setupRecorder(_ fname : String) {
        
        
        
        //set the settings for recorder
        
        
        /*
         var recordSettings = [
         AVFormatIDKey:kAudioFormatMPEG4AAC,
         //  AVFormatIDKey: kAudioFormatAppleLossless,
         
         AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
         
         AVEncoderBitRateKey : 320000,
         
         AVNumberOfChannelsKey: 2,
         
         AVSampleRateKey : 44100.0
         
         ]
         */
        //        let recordSettings: [String : AnyObject] = [
        //            AVFormatIDKey:Int(kAudioFormatMPEG4AAC), //Int required in Swift2
        //            AVSampleRateKey:44100.0,
        //            AVNumberOfChannelsKey:2,
        //            AVEncoderBitRateKey:12800,
        //            AVLinearPCMBitDepthKey:16,
        //            AVEncoderAudioQualityKey:AVAudioQuality.Max.rawValue
        //        ]
        
        let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0) as Float),
                              AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC) as Int32),
                              AVNumberOfChannelsKey : NSNumber(value: 2 as Int32),
                              AVLinearPCMBitDepthKey : NSNumber(value: 16 as Int32),
                              AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue) as Int32),
                              AVEncoderBitRateKey : NSNumber(value: Int32(320000) as Int32)]
        
        
        //        AVAudioSession *session = [AVAudioSession sharedInstance];
        //        [session setCategory:AVAudioSessionCategoryRecord error:nil];
        //        [session setActive:YES error:nil];
        //
        
        
        
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
    
    
    
    
    
    func recordSound(_ sender: UIButton) {
        
        soundRecorder.record()
        
        
        
        
        
        //    soundRecorder.stop()
        
        
        
        
        
    }
    
    
    func playSound(_ sender: UIButton) {
        
        
        
        
        preparePlayer("\(sender.tag).m4a")
        if soundPlayer != nil {
            soundPlayer.play()
            
        }
        
        //   soundPlayer.stop()
        
        
    }
    
    
    
    //MARK:- READY TO SUBMIT BUTTON
    @IBAction func finishReport(_ sender: AnyObject) {
        self.submitreport()
    }
    var appDel : AppDelegate! = UIApplication.shared.delegate as! AppDelegate
    
    var tasks : TaskDao!
    var allQuestion : NSMutableArray!
    var allDropdowns : NSMutableDictionary!
    var notes:NSMutableDictionary!
    var audio : NSMutableDictionary!
    var images : NSMutableDictionary!
    var allSelectedQuestions: NSMutableDictionary!
    
    
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.questionCategories.count > 0 && self.isSearching == 0 {
           return self.questionCategories.count
        }
        return 1
    }
    func resetfornewrows(_ cell : RadioBtnTableViewCell) {
        //    println("Resetting the cell")
        
        cell.radio1.setImage(UIImage(named: "toggle"), for: UIControlState())
        cell.radio1.valueSelect = 0
        cell.radio2.setImage(UIImage(named: "toggle"), for: UIControlState())
        cell.radio2.valueSelect = 0
        cell.radio3.setImage(UIImage(named: "toggle"), for: UIControlState())
        cell.radio3.valueSelect = 0
             
        
        // cell.radio3.setImage(UIImage(named: "toggle"), forState: UIControlState.Normal)
       // cell.radio3.valueSelect = 0
       // cell.radio4.setImage(UIImage(named: "toggle"), forState: UIControlState.Normal)
       // cell.radio4.valueSelect = 0
       // cell.radio5.setImage(UIImage(named: "toggle"), forState: UIControlState.Normal)
       // cell.radio5.valueSelect = 0
        cell.barIndicator.backgroundColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1.0)
        cell.notesBtn.setBackgroundImage(UIImage(named: "notesreport"), for: UIControlState())
        cell.cameraBtn.setBackgroundImage(UIImage(named: "cameraiconreport"), for: UIControlState())
        cell.cameraBtn.mediaId = nil
       // ////////////cell.cameraBtn2.mediaId = nil
       // //cell.cameraBtn3.mediaId = nil
        
        cell.recordBtn.mediaId = nil
        cell.cameraBtn.isHidden = true
       // ////////////cell.cameraBtn2.hidden = true
       // //cell.cameraBtn3.hidden = true
        cell.recordBtn.isHidden = true
        cell.notesBtn.isHidden = true
        cell.amountTextField.isHidden = true
        cell.nolbl.isHidden = true
        cell.reddot.isHidden = true
        
        
        
        
        //cell.cameraBtn.setBackgroundImage(img, forState: UIControlState.Normal)
        
        cell.recordBtn.setImage(UIImage(named: "recordiconreport"), for: UIControlState())
        // cell.recordBtn.audioState =  -1
        
        //        self.currentBtn.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
        
        cell.questionTitle.textColor = UIColor(red: 52/255, green: 40/255, blue: 44/255, alpha: 1.0)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isExpanded == 0 {
            self.isExpanded = 1
            self.expandedIndex = indexPath.section
        }
        else {
           self.isExpanded = 0
            self.expandedIndex = 0
        }
        // self.questionsTable.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
        self.questionsTable.reloadData()

    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CategoryTableViewHeader") as! CategoryTableViewHeader
        let catg = self.questionCategories.object(at: section) as! QuestionCategoryDao
        
        if self.expandedIndex == section {
            headerView.icon.image = UIImage(named: "categoryarrowup")
            
        }
        else {
            headerView.icon.image = UIImage(named: "categoryarrowdown")
            
        }
        
        var catg_desc : String = ""
        if self.appDel.selectedLanguage == 1 && catg.catg_name != nil { // english
            
            catg_desc = (catg.catg_name! != "") ? catg.catg_name! : catg.catg_name_ar!
            
        }
        else if  catg.catg_name_ar != nil {
            catg_desc = (catg.catg_name_ar != "") ? catg.catg_name_ar! : catg.catg_name!
            
        }
        
        
        
        headerView.categoryTitle.text = catg_desc
        headerView.section = section
        headerView.category = catg
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.expandTable(gesture:))))
        
        
        
      //  headerView.gestureRecognizers = [UITapGestureRecognizer(target: self, action: Selector("expandTable:"))]
       // v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:))))
        
        return headerView
    }
    
    @objc func expandTable(gesture : UITapGestureRecognizer){
        let v = gesture.view as! CategoryTableViewHeader
        
        if self.isExpanded == 0 {
            self.isExpanded = 1
            v.icon.image = UIImage(named: "categoryarrowup")
            tempQuesttions = filterArrayByCategory(catd_id: v.category!.catg_id!, questions: self.questionStorageArray)
            allQuestion = tempQuesttions
            self.expandedIndex = v.section!
        }
        else if self.expandedIndex != v.section!{
            self.isExpanded = 1
            v.icon.image = UIImage(named: "categoryarrowup")
            tempQuesttions = filterArrayByCategory(catd_id: v.category!.catg_id!, questions: self.questionStorageArray)
            allQuestion = tempQuesttions
            self.expandedIndex = v.section!
        }
        else {
            self.isExpanded = 0
                      self.expandedIndex = 0
                      self.expandedIndex = -1
                      
                      v.icon.image = UIImage(named: "categoryarrowdown")
                      
        }
//        self.questionsTable.beginUpdates()
//         self.questionsTable.reloadSections(NSIndexSet(index: v.section!) as IndexSet, with: .automatic)
//        self.questionsTable.endUpdates()
       self.questionsTable.reloadData()
       // self.questionsTable.beginUpdates()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
        
        
        var question : QuestionDao = allQuestion.object(at: indexPath.row) as! QuestionDao
        if self.isSearching == 1 {
            question  = self.searchedArry.object(at: indexPath.row) as! QuestionDao
            
            
        }
        //print("question id \(question.question_id) for indexPathrow \(indexPath.row)")
        
        // println("Medai \(question.media)")
        // if question.allOptions.count > 0 {
        
        // var option1  = question.allOptions.objectAtIndex(0) as! OptionDao
        
        //            if option1.option_type == "checkbox"{
        //                var cell : CheckBoxTableViewCell =  tableView.dequeueReusableCellWithIdentifier("cell_checkbox") as! CheckBoxTableViewCell
        //                cell.view1.hidden = false
        //                cell.questiontitle.text = question.question_desc
        //                if indexPath.row % 2 == 0 {
        //                cell.contentView.backgroundColor =  UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1)
        //                }
        //                else {
        //                    cell.contentView.backgroundColor =  UIColor.whiteColor()
        //
        //                }
        //                return self.setupCheckBoxCell(cell, option1: option1, question: question)
        //
        //
        //         }
        //            else if option1.option_type == "radio"{
        let cell : RadioBtnTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "cell_radio") as! RadioBtnTableViewCell
        cell.view1.isHidden = false
        //        if checkedRows.contains(indexPath) {
        //           // self.checkedRows.remove(indexPath)
        //                       println("IndexPath removed")
        //        } else {
        //        //    println("IndexPath added")
        //            // self.resetfornewrows(cell)
        //
        //            self.checkedRows.insert(indexPath)
        //        }
        
        cell.backgroundColor = UIColor.white
        //   println("Options \(question.allOptions.count)")
        // cell.questionTitle.text = question.question_desc
        //        if indexPath.row == 5 {
        //        cell.questionTitle.text = "عدم توفر شرط أو أكثر من شروط الفحص الفني في المركبة السياحية \n عدم توفر شرط أو أكثر من شروط الفحص الفني في المركبة السياحية \n عدم توفر شرط أو أكثر من شروط الفحص الفني في المركبة السياحية \n عدم توفر شرط أو أكثر من شروط الفحص الفني في المركبة السياحية \n"
        //        }
        //        else {
        var question_desc : String = ""
        if self.appDel.selectedLanguage == 1 && question.question_desc_en != nil { // english
            
            question_desc = (question.question_desc_en! != "") ? question.question_desc_en! : question.question_desc
            
        }
        else {
            question_desc = (question.question_desc != nil && question.question_desc != "") ? question.question_desc : question.question_desc_en!
            
        }
        
        if question.violation_code != nil {
           if question.violation_code != "0" {
            cell.questionTitle.text = question_desc + " (" + "\(question.violation_code!)" + ")"
            }
            else {
                 cell.questionTitle.text = question_desc
                
            }
        }
        else {
            cell.questionTitle.text = question_desc
            //print("violation code is null")
        }
        // }
        
        //                if indexPath.row % 2 == 0 {
        //                    cell.contentView.backgroundColor =  UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1)
        //                }
        //                else {
        //                    cell.contentView.backgroundColor =  UIColor.whiteColor()
        //
        //                }
        
        
        UIGraphicsBeginImageContext(cell.contentView.frame.size)
        UIImage(named: "bigbg")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        //self.view.backgroundColor = UIColor(patternImage: image)
        //  cell.outerbg.backgroundColor = UIColor(patternImage: UIImage(named: "bigbg")!)
        cell.outerbg.backgroundColor = UIColor(patternImage: image)
        cell.amountTextField.delegate = self 
        // return self.setupRadiobtncell(cell, option1: option1, question: question , rowIndex: indexPath.row)
        return self.setupRadioCell(cell, question: question, rowIndex: indexPath.row)
        //}
    }
    
    
    //            }
    //
    //            else if option1.option_type == "drop_down" {
    //                var cell : DropDownTableViewCell =  tableView.dequeueReusableCellWithIdentifier("cell_dropdown") as! DropDownTableViewCell
    //                cell.notesBtn.questionid = question.question_id.toInt()
    //
    //                cell.cameraBtn.addTarget(self, action: "setUpCamera:", forControlEvents: UIControlEvents.TouchUpInside)
    //                cell.cameraBtn.tag = question.question_id.toInt()!
    //                cell.notesBtn.addTarget(self, action: "saveNotes:", forControlEvents: UIControlEvents.TouchUpInside)
    //
    //                cell.dropdownbtn.questionid = question.question_id.toInt()
    //                cell.dropdownbtn.option_id = option1.option_id.toInt()
    //                cell.dropdownbtn.addTarget(self, action: "showDropDown:", forControlEvents: UIControlEvents.TouchUpInside)
    //                cell.questiontitle.text = question.question_desc
    //                //cell.dropDowntitle.text = option1.option_label
    //                if indexPath.row % 2 == 0 {
    //                    cell.contentView.backgroundColor =  UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1)
    //                }
    //                else {
    //                    cell.contentView.backgroundColor =  UIColor.whiteColor()
    //
    //                }
    //
    //
    //                 return cell
    //
    //            }
    //
    //
    //
    //        }
    //
    //
    //
    //        let cell : UITableViewCell  = tableView.dequeueReusableCellWithIdentifier("cell_radio") as! UITableViewCell
    //        return cell
    //
    //   }
    
    
//    func prepare(for segue: UIStoryboardSegue,
//                     sender: ADButton)
//    {
//    print("Prepare method called")
//        if segue.identifier == "sw_showmultiimages"{
//        if segue.destinationViewController is MultiImageViewController {
//        (segue.destinationViewController as! MultiImageViewController).question_id = sender.question.question_id
//        }
//        }
//        }
    
    func openCameraOrGallery(_ sender : ADButton){
        
        let alert = SCLAlertView()
        alert.showCloseButton  = false
        //alert.title = "Select photo source"
        alert.addButton("Camera", action: {
           
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.camera) {
                
                let imagePicker = CustomImageController()
                  imagePicker.button = sender
                  imagePicker.question = sender.question
                
                imagePicker.delegate = self
                //  self.whichImage = sender.tag
                
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
                
                let imagePicker = CustomImageController()
                // self.whichImage = sender.tag
                //print("Which Media \(self.whichImage)")
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.photoLibrary
                // imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                imagePicker.button = sender
                imagePicker.question = sender.question
                
                self.present(imagePicker, animated: true,
                    completion: nil)
                
            }
            
            
            
        })
        
        alert.addButton("Cancel", action: {
           
            
        })
        
        alert.showInfo("Select photo source", subTitle: "")
        
        
    }
    
    
    
    
    @objc func setUpCamera(_ button : ADButton){
        
       // self.performSelector(Selector("sw_showmultiimages"), withObject: nil)
       //self.performSegueWithIdentifier("sw_showmultiimages", sender: button)
        if (self.appDel.fromHistoryToResult != 1) {
        if button.question.allImages.count > 0 {
            self.currentBtn = button
            self.appDel.currentBtn = button
            
        self.performSegue(withIdentifier: "sw_showmultiimages", sender: button)
        }
        else {
        self.currentBtn = button
        self.appDel.currentBtn = button
        
        self.openCameraOrGallery(button)
        }
        
        return
        }
        
        else if (self.appDel.fromHistoryToResult == 1) {
            if   button.mediaId != nil  {
                self.appDel.showIndicator = 1
                // Constants.kMediaBaseUrl
                //let fullrul : String = "http://einspection.net/uploads/" + button.mediaId
                let fullrul : String = Constants.downloadUrl + button.mediaId
                print(fullrul)
                self.currentBtn = button
                let datadownloader:DataDownloader = DataDownloader()
                datadownloader.delegate = self
                self.appDel.showIndicator = 1
                //var loginUrl = Constants.baseURL + "getTaskQuestionList?list_id=" + tasks.list_id
                datadownloader.startDownloader(fullrul, idn: "image")
            }
            return
            
            
        }// end of the showing images
        
        if (self.appDel.show_result == 1 && self.allSelectedQuestions.object(forKey: button.question.question_id) != nil && self.usersSelectedQuestions.object(forKey: button.question.question_id) == nil) {
            if   button.mediaId != nil  {
                self.appDel.showIndicator = 1
                let fullrul : String = Constants.downloadUrl + button.mediaId
                print(fullrul)
                
                let datadownloader:DataDownloader = DataDownloader()
                datadownloader.delegate = self
                self.appDel.showIndicator = 1
                
                datadownloader.startDownloader(fullrul, idn: "image")
            }
            return
            
            
        }// end of the showing images
        
        
        
        
        //        if self.appDel.show_result == 1 {
        //            if self.allSelectedQuestions.objectForKey(button.question.question_id) != nil && self.usersSelectedQuestions.objectForKey(button.question.question_id) == nil {
        //                print("returning its already selected")
        //                return
        //            }
        //
        //
        //        }
        
        
        
        
        
        DispatchQueue.main.async(execute: {
            let source = CustomImageController()
            source.question = button.question
            
            
            self.currentBtn = button
            
            // source.mediaTypes = [kUTTypeImage];
            
            source.sourceType = .camera
            source.delegate = self
            self.cameraShown = 1
            
            source.allowsEditing = true
            //        let popRect: CGRect = button.frame
            //        let popover: UIPopoverController = UIPopoverController(contentViewController: source);
            //        popover.presentPopoverFromRect(popRect, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Up, animated: true);
            //
            self.present(source, animated: true, completion: {
               
                UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.none)
            })
            
        });
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        //  println("didFinishPickingImage")
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let customPicker : CustomImageController =  picker as! CustomImageController
        
        
        //  print("didFinishPickingImage")
        let tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        print(tempImage)
        //self.currentBtn.setImage(tempImage, forState: UIControlState.Normal)
        self.selectedImage = tempImage
        picker.dismiss(animated: true, completion: nil)
        if self.currentBtn == nil {
        print("Current Button is nill")
        }
        self.allImages.setObject(tempImage, forKey: self.currentBtn.question.question_id as NSCopying)
        
        //let cgImage = CIImage(image: tempImage)
        //let uimage = UIImage(CIImage: cgImage!)
        
        let imageData = UIImageJPEGRepresentation(tempImage, 0.5)
        //let imageData = UIImagePNGRepresentation(tempImage)
       // print("Image data \(imageData)")
//        if imageData == nil {
//            print("returning as image is nill")
//        return
//        }
        if Reachability.connectedToNetwork() {
            if customPicker.question != nil {
                ANLoader.showLoading("", disableUI: true)
                
            self.createMultipart("notes.jpeg" , q: customPicker.question , imageData: imageData! , type: "image")
            }
            else {
            print("Question is nill")
            }
            }
        else{
            
            // COMMENTING FOR OFFLINE FOR NOW
            
            
            
            let file = MyFileManager()
            file.createTaskFolder(self.appDel.unique)
            file.createAudioFolder(self.appDel.unique)
            file.createImageFolder(self.appDel.unique)
            //self.currentBtn.setImage(self.selectedImage, forState: UIControlState.Normal)
            file.writeImage(self.appDel.unique, q_id: customPicker.question.question_id!, data: imageData!)
            print("Unique Id \(self.appDel.unique),Question Id \(customPicker.question.question_id) Image")
            
            
            
            let dao = ImageDao()
            dao.image_id = "\(customPicker.question.allImages.count + 1)"
            dao.q_id = customPicker.question.question_id
            dao.image = UIImage(data: imageData!)
            dao.media_id = self.appDel.unique
            customPicker.question.allImages.add(dao)
            self.currentBtn.radioCell.reddot.isHidden = false
            self.currentBtn.radioCell.nolbl.text =  "\(customPicker.question.allImages.count)"
            self.currentBtn.radioCell.nolbl.isHidden = false

            
            
            
            self.questionsTable.reloadData()
            
            self.currentBtn.radioCell.reddot.isHidden = false
            self.currentBtn.radioCell.nolbl.text =  "1"
            self.currentBtn.radioCell.nolbl.isHidden = false
            
        }
        self.cameraShown = 0
        
    }
    func showDatePicket(_ sender : ADButton){
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        let menuViewController: DateSelectorViewController = storyboard.instantiateViewController(withIdentifier: "cnt_date") as! DateSelectorViewController
        menuViewController.delegate = self
        menuViewController.button = sender
        
        
        menuViewController.modalPresentationStyle = .popover
        //menuViewController.preferredContentSize = CGSizeMake(50, 100)
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .any
        // popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = sender
        //        popoverMenuViewController?.sourceRect = CGRect(
        //            x: location.x,
        //            y: location.y,
        //            width: 1,
        //            height: 1)
        present(
            menuViewController,
            animated: true,
            completion: nil)
        
    }
    
    
    
    func showDropDown(_ sender:ADButton){
        let selected = SelectedCellData()
        selected.optionSelected = sender.buttonnumber
        
        let alert : UIAlertController = UIAlertController(title: localisation.localizedString(key: "questions.selectoption"), message:"" , preferredStyle: UIAlertControllerStyle.alert)
        if sender.option.option_type == "drop_down" {
            let violationFound : Int = 0
            selected.questionStatus = 7 // dropdown
            
            // all dropdowns dictionary keeps the track on all violations
            
            let allOption : NSMutableArray = self.allDropdowns.object(forKey: String(sender.option.option_id)) as! NSMutableArray
            
            
         //   for var i = 0 ;i < allOption.count ; i += 1 {
                
                for  i in 0 ..< allOption.count  {
                    
                
                let eoption : ExtraOption = allOption.object(at: i) as! ExtraOption
                
                
                let action : UIAlertAction = UIAlertAction(title: eoption.value, style: UIAlertActionStyle.default, handler:{ action in
                    //sender.setTitle(eoption.value, forState: UIControlState.Normal)
                    if eoption.violation_id != "" && eoption.violation_id != nil && eoption.violation_id != "0" {
                        print(sender.option.violation_code)
                        sender.option.violation_code = eoption.valication_code
                        sender.extraOption = eoption
                        //sender.radioCell.questionTitle.text = sender.question.question_desc + "\(eoption.value)"
                        //sender.option.v
                        self.violations.setObject(sender, forKey: sender.question.question_id as NSCopying)
                        //  violationFound = 1
                    }
                    else {
                        // self.violations.removeObjectForKey(sender.question.question_id)
                    }
                    sender.radioCell.questionTitle.text = sender.question.question_desc + " (\(eoption.value))"
                    //sender.radioCell.questionTitle.textColor = UIColor.whiteColor()
                    sender.radioCell.questionTitle.textColor = UIColor(red: 52/255, green: 40/255, blue: 44/255, alpha: 1.0)
                    
                    selected.questiontitle = sender.question.question_desc + " (\(eoption.value))"
                    //self.calulatedWarnings.setObject(sender, forKey: sender.question.question_id)
                   // self.allSelectedQuestions.setObject(String(eoption.extra_optionId), forKey: String(sender.question.question_id))
                    self.allSelectedQuestions.setObject(String(eoption.extra_optionId), forKey: String(sender.question.question_id) as NSCopying)
                    //}
                })
                alert.addAction(action)
                
            }
            if violationFound == 0 {
                self.violations.removeObject(forKey: sender.question.question_id)
                
            }
        }
        else  if sender.option.option_type == "warning" {
            
            self.violations.removeObject(forKey: sender.question.question_id)
            selected.questionStatus = 2
            // selection option is warning
            
            for i in 0 ..< self.warningArray.count  {
               // for var i = 0 ;i < self.warningArray.count ; i++ {
                
                let eoption : String = warningArray.object(at: i) as! String
                
                
                let action : UIAlertAction = UIAlertAction(title: eoption, style: UIAlertActionStyle.default, handler:{ action in
                    self.allDates.setObject(eoption, forKey: String(sender.question.question_id) as NSCopying)
                    // allSelectedQuestions
                    self.allSelectedQuestions.setObject(sender.option.option_id, forKey:String(sender.question.question_id) as NSCopying)
                    sender.radioCell.questionTitle.textColor = UIColor.yellow
                    sender.radioCell.questionTitle.text = sender.question.question_desc + " (\(eoption))"
                    selected.questiontitle = sender.question.question_desc + " (\(eoption))"
                    self.calulatedWarnings.setObject(sender, forKey: sender.question.question_id as NSCopying)
                    self.violations.removeObject(forKey: sender.question.question_id)
                    
                    
                    //sender.setTitle(eoption.value, forState: UIControlState.Normal)
                    //                    if sender.option.violation_code != "" {
                    //                        self.violations.setObject(sender.option, forKey: sender.question.question_id)
                    //                    }
                    //                   // self.allSelectedQuestions.setObject(String(eoption.extra_optionId), forKey: String(sender.question.question_id))
                    //}
                })
                alert.addAction(action)
                
            }
            
            
        }
        // Selected question bank stores all data as SelectedCellData(questionStatus,optionSelected, questiontitle)
        
        
        self.selectedQuestionBank.setObject(selected, forKey: sender.question.question_id as NSCopying)
        let cancel : UIAlertAction = UIAlertAction(title:localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.default, handler:nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    func setupButtonTitle(_ str : String , button : ADButton){
        //button.setTitle(str, forState: UIControlState.)
    }
    @objc func startRercording(_ sender:ADButton){
        print(sender.audioState)
        // IF ITS HISTORY THAN IT CAN HAVE DIGITAL DATA ALSO
        if self.appDel.fromHistoryToResult == 1{
            self.appDel.showIndicator = 1
            if self.onlyAudioPlayer != nil {
                if self.onlyAudioPlayer.isPlaying {
                    self.currentBtn = sender
                    
                    self.onlyAudioPlayer.stop()
                    self.currentBtn.setImage(UIImage(named: "play"), for: UIControlState())
                    
                    return
                    
                    
                }
            }
            let fullrul : String = Constants.downloadUrl + sender.mediaId
            self.currentBtn = sender
            //Constants.downloadUrl
            print(fullrul)
            
            //let fullrul : String = "http://einspection.net/uploads/" + sender.mediaId
            
            //            if let soundURL = NSURL(string: fullrul) {
            //                println(fullrul)
            //                var mySound: SystemSoundID = 0
            //                AudioServicesCreateSystemSoundID(soundURL, &mySound)
            //                // Play
            //                AudioServicesPlaySystemSound(mySound);
            //            }
            //
            //   var fullrul : String = "http://einspection.net/uploads/" + sender.mediaId
            let datadownloader:DataDownloader = DataDownloader()
            datadownloader.delegate = self
            //var loginUrl = Constants.baseURL + "getTaskQuestionList?list_id=" + tasks.list_id
            datadownloader.startDownloader(fullrul, idn: "audio")
            
            
            return
            
        }
        
        
        
        
        if (self.appDel.show_result == 1 && self.allSelectedQuestions.object(forKey: sender.question.question_id) != nil && self.usersSelectedQuestions.object(forKey: sender.question.question_id) == nil) {
            
            if   sender.mediaId != nil  {
                if self.onlyAudioPlayer != nil {
                    if self.onlyAudioPlayer.isPlaying {
                        self.onlyAudioPlayer.stop()
                        self.currentBtn.setImage(UIImage(named: "play"), for: UIControlState())
                        
                        return
                    }
                }
                let fullrul : String = Constants.downloadUrl + sender.mediaId
                self.currentBtn = sender
                
                print(fullrul)
                let datadownloader:DataDownloader = DataDownloader()
                datadownloader.delegate = self
                //var loginUrl = Constants.baseURL + "getTaskQuestionList?list_id=" + tasks.list_id
                datadownloader.startDownloader(fullrul, idn: "audio")
                
            }
            return
            
            
            
        }
        
        
        self.currentBtn = sender
        if sender.audioState == 3 {
            if self.soundPlayer != nil {
            
            
            self.soundPlayer.stop()
            sender.setImage(UIImage(named: "play"), for: UIControlState())
                
            }
            sender.audioState = 2
            
        }
        if sender.audioState == 2 {
            self.playSound(sender)
            sender.audioState = 3
            sender.setImage(UIImage(named: "pause"), for: UIControlState())
            //self.soundPlayer.pause()
            
            
        }
        if sender.audioState == 1 {
            sender.setImage(UIImage(named: "play"), for: UIControlState())
            self.soundRecorder.stop()
            sender.audioState = 2
            
        }
        
        
        if sender.audioState == 0 ||  sender.audioState == -1 {
            if self.soundRecorder != nil && self.soundRecorder.isRecording {
                return
            }
            sender.setImage(UIImage(named: "stoprecord"), for: UIControlState())
            //self.recordSound(sender)
            print("Setup Recorder")
            self.setupRecorder("\(sender.question.question_id!).m4a")
            self.soundRecorder.record()
            
            sender.audioState = 1
            
            
        }
        
        self.recordButtonsDictionary.setObject(sender, forKey: sender.question.question_id as NSCopying)
        
        
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        print("Finish recroding")
        if currentBtn.question.question_id == nil {
            return 
            
        }
        let data =  try? Data(contentsOf: self.getFileURL("\(currentBtn.question.question_id!).m4a"))
        
        self.audio.setObject(data!, forKey: currentBtn.question.question_id as NSCopying)
        if Reachability.connectedToNetwork() {
            self.createMultipart("audio.m4a", q: currentBtn.question, imageData:data, type : "audio")
        }
        else {
            let file = MyFileManager()
            file.createTaskFolder(self.appDel.unique)
            file.createAudioFolder(self.appDel.unique)
            file.createImageFolder(self.appDel.unique)
            file.writeAudio(self.appDel.unique, q_id: currentBtn.question.question_id, data: data!)
            
        }
    }
    
    
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        
        print("Finish recording \(error)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        print("Finish Playing")
        if self.currentBtn != nil {
            self.currentBtn.setImage(UIImage(named: "play"), for: UIControlState())
            
            self.currentBtn.audioState = 2
        }
    }
    
    
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
        print("Finish Playing error \(error)")
        
        
    }
    
    /// this radiocell is setting up
    /*
     
     
     
     */
    
    
    func setupRadioCell(_ cell : RadioBtnTableViewCell , question : QuestionDao , rowIndex : Int) -> RadioBtnTableViewCell{
        
        /*
         ***** HOW WE MAINTIAN CELL STATE ********
         1:We store selected question in SelectedCellData than in  selectedQuestionBank dictionary
         2:When any item is selected it calls resetcheckbox
         3:In Reset checkbox or in showdropdown , showPicket we set data for SelectedCellData
         4:In setupRadioCell we check if indexPathBank which stores path of all selected indexes
         5:If indexPathBank has index than get it from selectedQuestionBank and set in required section
         6:
         
         
         */
        
        var selected : SelectedCellData?
        self.resetfornewrows(cell)
        
        // indexPathBank dictionary stores the index of selected questions so that it can be show later on,
        if self.indexPathBank.object(forKey: question.question_id) != nil {
            //    println("returning cell \(question.question_id)")
            //   println(rowIndex)
            // print(selected)
            selected  = self.selectedQuestionBank.object(forKey: question.question_id) as? SelectedCellData
            if selected != nil {
               // print("Not Null option selected \(selected?.optionSelected)")
                
                //print("item id \(selected!.questiontitle) question id \(question.question_id)")
            }
            else {
                //print("indexpathbank has data but selectedQuestionBank does not have")
            }
            //  return self.indexPathBank.objectForKey(question.question_id) as! RadioBtnTableViewCell
        }
        else {
            
            
            
            self.resetfornewrows(cell)
        }
        
        cell.notesBtn.questionid = Int(question.question_id)
        cell.notesBtn.question = question
        
        // print(self.recordButtonsDictionary)
        
        let recordBtn = self.recordButtonsDictionary.object(forKey: question.question_id) as? ADButton
        if recordBtn != nil {
            cell.recordBtn.audioState = recordBtn?.audioState
            
            if cell.recordBtn.audioState == 2 {
                cell.recordBtn.setImage(UIImage(named: "play"), for: UIControlState())
                
            }
            if cell.recordBtn.audioState == 3 {
                
                cell.recordBtn.setImage(UIImage(named: "pause"), for: UIControlState())
                
            }
            
            if cell.recordBtn.audioState == 1 {
                cell.recordBtn.setImage(UIImage(named: "stoprecord"), for: UIControlState())
            }
        }
        
        cell.notesBtn.addTarget(self, action: #selector(QuestionListViewController.saveNotes(_:)), for: UIControlEvents.touchUpInside)
        // notes are present in questions just show these its for history
        if question.notes != nil && question.notes != "" && appDel.show_result == 1 {
            self.notes.setObject(question.notes, forKey:String(question.question_id) as NSCopying)
        }
        cell.recordBtn.tag = Int(question.question_id)! + 1000
        // Initially when coming from history hide media button
        if self.appDel.fromHistoryToResult == 1{
            
            cell.notesBtn.isHidden = true
            cell.recordBtn.isHidden = true
            cell.cameraBtn.isHidden = true
            
        }
        
        
        // Check how much which media we have for this questiomn
        for aa in 0  ..< question.media.count    {
            var imageIndex : Int = 0
            let media = question.media.object(at: aa) as! MediaDao
            
            
            print("\(question.question_desc) has Media of \(question.media.count)")
            // question has audio enable audio button and assign path to button
            
            if media.media_type == "audio" {
                cell.recordBtn.isHidden = false
                cell.recordBtn.mediaId = media.media_Path
                cell.recordBtn.setImage(UIImage(named: "play"), for:UIControlState())
                
            }
            // if question has image , enable image button and assign path
            if media.media_type == "image" {
                if imageIndex == 0 {
                cell.cameraBtn.isHidden = false
                imageIndex = 1
                    

                cell.cameraBtn.mediaId = media.media_Path
                cell.cameraBtn.setBackgroundImage(UIImage(named: "capturedphoto"), for: UIControlState())
                }
//                if imageIndex == 1 {
//                    imageIndex = 2
//                    ////////////cell.cameraBtn2.hidden = false
//                    ////////////cell.cameraBtn2.mediaId = media.media_Path
//                    //////////cell.cameraBtn2.setBackgroundImage(UIImage(named: "capturedphoto"), forState: UIControlState.Normal)
//                    
//                }
//                if imageIndex == 2 {
//                    //cell.cameraBtn3.hidden = false
//                    //cell.cameraBtn3.mediaId = media.media_Path
//                    //cell.cameraBtn3.setBackgroundImage(UIImage(named: "capturedphoto"), forState: UIControlState.Normal)
//                    
//                }
                
            }
            
        }
        // if question has notes show notes button and assign question to notes so that notes button has question from where popover can select thenotes
        if question.notes != nil {
            if question.notes != "" {
                cell.notesBtn.isHidden = false
                cell.notesBtn.setBackgroundImage(UIImage(named:"not_sel"), for: UIControlState())
                
                
                cell.notesBtn.question = question
            }
        }
        // setup actions and data to camera and record buttons
        cell.cameraBtn.question = question
        //////////cell.cameraBtn2.question = question
        ////cell.cameraBtn3.question = question
        
        //////////cell.cameraBtn2.addTarget(self, action: #selector(QuestionListViewController.setUpCamera(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.cameraBtn.addTarget(self, action: #selector(QuestionListViewController.setUpCamera(_:)), for: UIControlEvents.touchUpInside)
        //cell.cameraBtn3.addTarget(self, action: #selector(QuestionListViewController.setUpCamera(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.cameraBtn.tag = Int(question.question_id)!
        cell.cameraBtn.radioCell = cell
        
        cell.recordBtn.addTarget(self, action: #selector(QuestionListViewController.startRercording(_:)), for: UIControlEvents.touchUpInside)
        cell.recordBtn.question = question
        cell.recordBtn.tag = Int(question.question_id)!
        
        
        //
        let allOptions : NSMutableArray = self.divideOptions2(question)
        //  println("all options \(allOptions.count)")
        for a in 0  ..< allOptions.count  {
            
            let divided : DividedQuestion = allOptions.object(at: a) as! DividedQuestion
            
            if a == 2 {
                          /*
                           Here we are setting up to for first option so first option which is mutabiq will be selected by default
                           */
                          
                          
                          if divided.extraOption.is_selected != nil  && divided.extraOption.is_selected != nil && self.trackSelectedQuestions.object(forKey: question.question_id) == nil{
                              if divided.extraOption.is_selected == 1{
                                 // print("O is selected")
                                  
                                  
                                  cell.radio3.setImage(UIImage(named: "toggle_on_yellow"), for: UIControlState())
                                  if divided.extraOption.violation_id != nil &&  divided.extraOption.violation_id != "0" {
                                      cell.radio3.setImage(UIImage(named: "toggle_red"), for: UIControlState())
                                      cell.barIndicator.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
                                      
                                      
                                  }
                                  else {
                                      cell.barIndicator.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha:1.0)
                                   //   cell.notesBtn.isHidden = true
                                   ///   cell.recordBtn.isHidden = true
                                    //  cell.cameraBtn.isHidden = true
                                      if divided.extraOption.is_media == "1" {
                                          cell.notesBtn.isHidden = false
                                          cell.recordBtn.isHidden = false
                                          cell.cameraBtn.isHidden = false
                                          
                                      }

                                  }
                                 
                                  cell.radio3.dividedOption = divided
                                  
                                  self.selectedQuestionBank.setObject(cell, forKey: question.question_id as NSCopying)
                                  if divided.extraOption != nil {
                                      if divided.extraOption.extra_optionId != nil {
                                          
                                          self.allSelectedQuestions.setObject(String(divided.extraOption.extra_optionId), forKey:String(question.question_id) as NSCopying)
                                      }
                                  }
                                  
                                  
                              } // end of the isselected
                              
                          }
                          
                          
                          
                          cell.view3.isHidden = false
                          cell.radio3.question = question
                          cell.radio3.option = divided.option
                          cell.radio3.buttonnumber = 3
                          cell.radio3.option_id = Int(divided.option.option_id)
                          cell.radio3.radioCell = cell
                          // cell.radio1.setImage(UIImage(named: "toggle"), forState: UIControlState.Normal)
                          
                          cell.radio3.rowIndex = rowIndex
                          cell.radio3.addTarget(self, action: #selector(QuestionListViewController.resetRadioBtn(_:)), for: UIControlEvents.touchUpInside)
                          // This self.appDel.fromHistoryToResult means inspecor is viewing the history
                          
                          if (self.appDel.fromHistoryToResult == 1 || self.appDel.show_result == 1) && divided.extraOption != nil && divided.option.option_type != "warning" {
                              
                              if divided.extraOption.is_selected == 1{
                                  // println("DIVIDED \(divided.option.violation_code)")
                                  cell.radio3.setImage(UIImage(named: "toggle_on_yellow"), for: UIControlState())
                                  if divided.extraOption.violation_id != nil &&  divided.extraOption.violation_id != "0" {
                                      cell.radio3.setImage(UIImage(named: "toggle_red"), for: UIControlState())
                                      
                                      //cell.questionTitle.textColor = UIColor(red: 104/255, green: 0, blue: 0, alpha: 1)
                                      //cell.questionTitle.text = question.question_desc + "( \(divided.extraOption.violation_name) : \(divided.extraOption.valication_code))"
                                      cell.radio3.setImage(UIImage(named:"toggle_red"), for: UIControlState())
                                      cell.barIndicator.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
                                      
                                      // THIS UPDATE IS DONE WHEN IN CO INSPECTION WE NEED TO SHOW VIOLATIONS OF CO INSPECTORS ON FINAL RESULT SCREEN
                                      
                                      let button = ADButton()
                                      button.question = question
                                      
                                      self.violations.setObject(button, forKey: button.question.question_id as NSCopying)
                                      //print("CREATING AND ADDING \(button.question.question_desc)")
                                  }
                                  else if divided.option.option_type == "dropdown" {
                                      
                                      //   cell.questionTitle.textColor = UIColor.greenColor()
                                      
                                  }
                                  else {
                                      cell.barIndicator.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha:1.0)
                                      
                                      
                                  }
                                  self.selectedQuestionBank.setObject(cell, forKey: question.question_id as NSCopying)
                                  if divided.extraOption != nil {
                                      if divided.extraOption.extra_optionId != nil {
                                          
                                          self.allSelectedQuestions.setObject(String(divided.extraOption.extra_optionId), forKey:String(question.question_id) as NSCopying)
                                      }}
                              }
                          } // end of the history condition
                          
                          
                          
                          if divided.option.is_selected != nil && (self.appDel.fromHistoryToResult == 1 || self.appDel.show_result == 1){
                              
                              if divided.option.is_selected == 1  {
                                  
                                  cell.radio3.setImage(UIImage(named: "toggle_on_yellow"), for: UIControlState())
                                  
                                  cell.radio3.valueSelect = 1
                                  
                                  
                                  self.selectedQuestionBank.setObject(cell, forKey: question.question_id as NSCopying)
                                  if divided.extraOption != nil {
                                      if divided.extraOption.extra_optionId != nil {
                                          
                                          self.allSelectedQuestions.setObject(String(divided.extraOption.extra_optionId), forKey:String(question.question_id) as NSCopying)
                                      }
                                  }
                                  
                              }
                          } // End of condition for history on warning and request to attend
                          
                          
                          
                          cell.radio3.tag = 3
                          cell.title3.text = divided.optionTitle
                          cell.radio3.extraOption = divided.extraOption
                          
                          // as we are using UITableView so rows are regenrated , to keep the track on old record we are using dictionary and Dicionary has object SelectedCellData ,
                          
                          if let selected1 = selected
                          {
                              print(selected1.optionSelected)
                              if selected1.optionSelected == 3 {
                                  
                                  print("selected1.optionSelected == 1")
                                  cell.radio3.setImage(UIImage(named: "toggle_on_yellow"), for: UIControlState())
                                  cell.radio3.valueSelect = 1
                                  cell.notesBtn.isHidden = false
                                  cell.recordBtn.isHidden = false
                                  cell.cameraBtn.isHidden = false
                                
                                
                                if cell.radio3.question.allImages.count > 0 {
                                                       cell.reddot.isHidden = false
                                                       cell.nolbl.isHidden = false
                                                       cell.cameraBtn.question.allImages = cell.radio3.question.allImages
                                                       cell.nolbl.text = "\(cell.radio3.question.allImages.count)"
                                                           
                                                           
                                                       }
                                                       else {
                                                           cell.reddot.isHidden = true
                                                           cell.nolbl.isHidden = true
                                                           cell.nolbl.text = "0"
                                                           
                                                       }
                            
                                  //cell.questionTitle.text = selected1.questiontitle
                                  if selected1.questionStatus == 3 {
                                      //cell.questionTitle.textColor = UIColor(red: 104/255, green: 0, blue: 0, alpha: 1)
                                  }
                                  if selected1.questionStatus == 2 {
                                      //cell.questionTitle.textColor = UIColor.yellowColor()
                                      
                                  }
                                  else {
                                      //    cell.barIndicator.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha:1.0)
                                  }
                                  
                                  // dont need to reset the dictionary when its already selected
                                  // self.selectedQuestionBank.setObject(cell, forKey: question.question_id)
                                  
                                  if divided.extraOption != nil {
                                      if divided.extraOption.extra_optionId != nil {
                                          
                                          self.allSelectedQuestions.setObject(String(divided.extraOption.extra_optionId), forKey:String(question.question_id) as NSCopying)
                                      }
                                  }
                                  
                                  
                                  
                            }
                }
                
            }
                          
                          
                          
                          
                          
                          
                          
            
            
            
            if a == 0 {
                /*
                 Here we are setting up to for first option so first option which is mutabiq will be selected by default
                 */
                
                
                if divided.extraOption.is_selected != nil  && divided.extraOption.is_selected != nil && self.trackSelectedQuestions.object(forKey: question.question_id) == nil{
                    if divided.extraOption.is_selected == 1{
                       // print("O is selected")
                        
                        
                        cell.radio1.setImage(UIImage(named: "toggle_on"), for: UIControlState())
                        if divided.extraOption.violation_id != nil &&  divided.extraOption.violation_id != "0" {
                            cell.radio1.setImage(UIImage(named: "toggle_red"), for: UIControlState())
                            cell.barIndicator.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
                            
                            
                        }
                        else {
                            cell.barIndicator.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha:1.0)
                            cell.notesBtn.isHidden = true
                            cell.recordBtn.isHidden = true
                            cell.cameraBtn.isHidden = true
                            if divided.extraOption.is_media == "1" {
                                cell.notesBtn.isHidden = false
                                cell.recordBtn.isHidden = false
                                cell.cameraBtn.isHidden = false
                                
                            }

                        }
                       
                        cell.radio1.dividedOption = divided
                        
                        self.selectedQuestionBank.setObject(cell, forKey: question.question_id as NSCopying)
                        if divided.extraOption != nil {
                            if divided.extraOption.extra_optionId != nil {
                                
                                self.allSelectedQuestions.setObject(String(divided.extraOption.extra_optionId), forKey:String(question.question_id) as NSCopying)
                            }
                        }
                        
                        
                    } // end of the isselected
                    
                }
                
                
                
                cell.view1.isHidden = false
                cell.radio1.question = question
                cell.radio1.option = divided.option
                cell.radio1.buttonnumber = 1
                cell.radio1.option_id = Int(divided.option.option_id)
                cell.radio1.radioCell = cell
                // cell.radio1.setImage(UIImage(named: "toggle"), forState: UIControlState.Normal)
                
                cell.radio1.rowIndex = rowIndex
                cell.radio1.addTarget(self, action: #selector(QuestionListViewController.resetRadioBtn(_:)), for: UIControlEvents.touchUpInside)
                // This self.appDel.fromHistoryToResult means inspecor is viewing the history
                
                if (self.appDel.fromHistoryToResult == 1 || self.appDel.show_result == 1) && divided.extraOption != nil && divided.option.option_type != "warning" {
                    
                    if divided.extraOption.is_selected == 1{
                        // println("DIVIDED \(divided.option.violation_code)")
                        cell.radio1.setImage(UIImage(named: "toggle_on"), for: UIControlState())
                        if divided.extraOption.violation_id != nil &&  divided.extraOption.violation_id != "0" {
                            cell.radio1.setImage(UIImage(named: "toggle_red"), for: UIControlState())
                            
                            //cell.questionTitle.textColor = UIColor(red: 104/255, green: 0, blue: 0, alpha: 1)
                            //cell.questionTitle.text = question.question_desc + "( \(divided.extraOption.violation_name) : \(divided.extraOption.valication_code))"
                            cell.radio1.setImage(UIImage(named:"toggle_red"), for: UIControlState())
                            cell.barIndicator.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
                            
                            // THIS UPDATE IS DONE WHEN IN CO INSPECTION WE NEED TO SHOW VIOLATIONS OF CO INSPECTORS ON FINAL RESULT SCREEN
                            
                            let button = ADButton()
                            button.question = question
                            
                            self.violations.setObject(button, forKey: button.question.question_id as NSCopying)
                            //print("CREATING AND ADDING \(button.question.question_desc)")
                        }
                        else if divided.option.option_type == "dropdown" {
                            
                            //   cell.questionTitle.textColor = UIColor.greenColor()
                            
                        }
                        else {
                            cell.barIndicator.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha:1.0)
                            
                            
                        }
                        self.selectedQuestionBank.setObject(cell, forKey: question.question_id as NSCopying)
                        if divided.extraOption != nil {
                            if divided.extraOption.extra_optionId != nil {
                                
                                self.allSelectedQuestions.setObject(String(divided.extraOption.extra_optionId), forKey:String(question.question_id) as NSCopying)
                            }}
                    }
                } // end of the history condition
                
                
                
                if divided.option.is_selected != nil && (self.appDel.fromHistoryToResult == 1 || self.appDel.show_result == 1){
                    
                    if divided.option.is_selected == 1  {
                        
                        cell.radio1.setImage(UIImage(named: "toggle_on"), for: UIControlState())
                        
                        cell.radio1.valueSelect = 1
                        
                        
                        self.selectedQuestionBank.setObject(cell, forKey: question.question_id as NSCopying)
                        if divided.extraOption != nil {
                            if divided.extraOption.extra_optionId != nil {
                                
                                self.allSelectedQuestions.setObject(String(divided.extraOption.extra_optionId), forKey:String(question.question_id) as NSCopying)
                            }
                        }
                        
                    }
                } // End of condition for history on warning and request to attend
                
                
                
                cell.radio1.tag = 1
                cell.title1.text = divided.optionTitle
                cell.radio1.extraOption = divided.extraOption
                
                // as we are using UITableView so rows are regenrated , to keep the track on old record we are using dictionary and Dicionary has object SelectedCellData ,
                
                if let selected1 = selected
                {
                    print(selected1.optionSelected)
                    if selected1.optionSelected == 1 {
                        
                        print("selected1.optionSelected == 1")
                        cell.radio1.setImage(UIImage(named: "toggle_on"), for: UIControlState())
                        cell.radio1.valueSelect = 1
                        
                        //cell.questionTitle.text = selected1.questiontitle
                        if selected1.questionStatus == 3 {
                            //cell.questionTitle.textColor = UIColor(red: 104/255, green: 0, blue: 0, alpha: 1)
                        }
                        if selected1.questionStatus == 2 {
                            //cell.questionTitle.textColor = UIColor.yellowColor()
                            
                        }
                        else {
                            //    cell.barIndicator.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha:1.0)
                        }
                        
                        // dont need to reset the dictionary when its already selected
                        // self.selectedQuestionBank.setObject(cell, forKey: question.question_id)
                        
                        if divided.extraOption != nil {
                            if divided.extraOption.extra_optionId != nil {
                                
                                self.allSelectedQuestions.setObject(String(divided.extraOption.extra_optionId), forKey:String(question.question_id) as NSCopying)
                            }
                        }
                        
                        
                        
                    }
                }
                
                
                
                
                
                
                
                
            }
            else if a == 1 {
                //print("a == 1")
                cell.view2.isHidden = false
                cell.radio2.question = question
                cell.radio2.option = divided.option
                cell.radio2.rowIndex = rowIndex
                cell.radio2.option_id = Int(divided.option.option_id)
                cell.radio2.radioCell = cell
                cell.radio2.buttonnumber = 2
                
                
                if (self.appDel.fromHistoryToResult == 1 || self.appDel.show_result == 1) && divided.extraOption != nil {
                    // println(divided.extraOption)
                   // print("In History")
                    
                    if divided.extraOption.is_selected == 1{
                        
                        cell.radio2.setImage(UIImage(named: "toggle_on"), for: UIControlState())
                        cell.radio2.valueSelect = 1
                        
                        
                        
                        if divided.extraOption.violation_id != nil &&  divided.extraOption.violation_id != "0" {
                            // cell.contentView.backgroundColor = UIColor.redColor()
                            //  cell.questionTitle.textColor = UIColor(red: 104/255, green: 0, blue: 0, alpha: 1)
                            cell.radio2.setImage(UIImage(named:"toggle_red"), for: UIControlState())
                            cell.barIndicator.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
                            
                            if divided.extraOption.violation_id != nil &&  divided.extraOption.violation_id != "0" {
                                
                                //cell.questionTitle.text = question.question_desc + "( \(divided.extraOption.violation_name) : \(divided.extraOption.valication_code))"
                                let button = ADButton()
                                button.question = question
                                self.violations.setObject(button, forKey: button.question.question_id as NSCopying)
                                print("Adding violations for \(rowIndex)")
                                
                                
                            }
                            else if divided.option.option_type == "dropdown" {
                                
                                // cell.questionTitle.textColor = UIColor.greenColor()
                                
                            }
                            
                            self.selectedQuestionBank.setObject(cell, forKey: question.question_id as NSCopying)
                            
                            
                            if divided.extraOption != nil {
                                if divided.extraOption.extra_optionId != nil {
                                    
                                    self.allSelectedQuestions.setObject(String(divided.extraOption.extra_optionId), forKey:String(question.question_id) as NSCopying)
                                }
                            }
                            
                            
                        }
                        else {
                            
                            cell.barIndicator.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha:1.0)
                            
                            
                            
                        }
                    }
                }
                else if divided.option.is_selected != nil {
                    
                    //  println("Type is OPTION  \(divided.option.option_type) ")
                }
                if divided.option.is_selected != nil {
                    if divided.option.is_selected == 1 {
                        
                        cell.radio2.setImage(UIImage(named: "toggle_on"), for: UIControlState())
                        cell.radio2.valueSelect = 1
                        //working on check list design
                        
                        
                    }
                }
                cell.radio2.addTarget(self, action: #selector(QuestionListViewController.resetRadioBtn(_:)), for: UIControlEvents.touchUpInside)
                cell.radio2.tag = 2
                cell.title2.text = divided.optionTitle
                cell.radio2.extraOption = divided.extraOption
                if let selected1 = selected
                {
                    //cell.radio2.valueSelect = 1
                    
                    print("SELECTED ====== \(selected1.questiontitle)")
                    //print("CELL IS SELECTED ALREADY")
                    if selected1.optionSelected == 2 {
                        
                        cell.cameraBtn.isHidden = true
                        //////////cell.cameraBtn2.hidden = true
                        //cell.cameraBtn3.hidden = true)
                        
                        cell.recordBtn.isHidden = true
                        cell.notesBtn.isHidden = true
                        if divided.extraOption.is_media == "1" {
                            print("\(question.question_desc) has Media of \(question.media.count)")
                                
                            
                            cell.notesBtn.isHidden = false
                            cell.recordBtn.isHidden = false
                            cell.cameraBtn.isHidden = false
                            
                        }
                         print("TOTAL IMAGES : \(cell.radio2.question.allImages.count)")
                        
                        
//                        if images.count <= 0 {
//                            
//                            self.currentBtn!.radioCell.reddot.hidden = true
//                            self.currentBtn!.radioCell.nolbl.hidden = true
//                        }
//                        else {
//                            self.currentBtn!.radioCell.nolbl.hidden = false
//                            
//                            self.currentBtn!.radioCell.nolbl.text = "\(images.count)"
//                        }

                        if cell.radio2.question.allImages.count > 0 {
                        cell.reddot.isHidden = false
                        cell.nolbl.isHidden = false
                        cell.cameraBtn.question.allImages = cell.radio2.question.allImages
                        cell.nolbl.text = "\(cell.radio2.question.allImages.count)"
                            
                            
                        }
                        else {
                            cell.reddot.isHidden = true
                            cell.nolbl.isHidden = true
                            cell.nolbl.text = "0"
                            
                        }
                        
                        
                        cell.radio2.setImage(UIImage(named: "toggle_on"), for: UIControlState())
                        // cell.questionTitle.text = selected1.questiontitle
                        
                        cell.barIndicator.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha:1.0)
                        
                        
                        
                        if selected1.questionStatus == 3 {
                            // cell.questionTitle.textColor = UIColor(red: 104/255, green: 0, blue: 0, alpha: 1)
                            cell.radio2.setImage(UIImage(named: "toggle_red"), for: UIControlState())
                            cell.barIndicator.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
                            let button = ADButton()
                            button.question = question
                            self.violations.setObject(button, forKey: button.question.question_id as NSCopying)
                            //print("QUESTION STATIS == 3")
                            
                            
                            cell.cameraBtn.isHidden = false
                            //////////cell.cameraBtn2.hidden = false
                            //cell.cameraBtn3.hidden = false
                            cell.recordBtn.isHidden = false
                            cell.notesBtn.isHidden = false
                            
                            if button.question.violation_code == "8501" || button.question.violation_code == "8502" {
                                cell.amountTextField.isHidden = false
                                cell.amountTextField.activity_code = button.question.violation_code
                                if button.question.violation_code == "8501" {
                                cell.amountTextField.text = amount8501
                                }
                                if button.question.violation_code == "8502" {
                                    cell.amountTextField.text = amount8502
                                }

                                
                            }
                            else {
                                cell.amountTextField.isHidden = true
                                cell.amountTextField.activity_code = nil
                                
                            }
                            
                            
                            
                            
                        }
                        if selected1.questionStatus == 2 {
                            //    cell.questionTitle.textColor = UIColor.yellowColor()
                            
                        }
                        else {
                            
                            //  cell.barIndicator.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha:1.0)
                            
                        }
                        //self.selectedQuestionBank.setObject(cell, forKey: question.question_id)
                        
                        if divided.extraOption != nil {
                            if divided.extraOption.extra_optionId != nil {
                                
                                self.allSelectedQuestions.setObject(String(divided.extraOption.extra_optionId), forKey:String(question.question_id) as NSCopying)
                            }
                        }
                    }
                    
                    
                }
                
                
                
                
                
            }
            
        }
        
        
        if self.notes.object(forKey: question.question_id) != nil {
            cell.notesBtn.setBackgroundImage(UIImage(named: "not_sel"), for: UIControlState())
        }
        
        if self.audio.object(forKey: question.question_id) != nil {
            cell.recordBtn.setImage(UIImage(named: "play"), for: UIControlState())
            //self.currentBtn.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
            
            //  self.currentBtn.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
            
        }
        if self.allImages.object(forKey: question.question_id) != nil {
            // print(self.allImages)
           // let img = self.allImages.objectForKey(question.question_id) as! UIImage
            //cell.cameraBtn.setBackgroundImage(img, forState: UIControlState.Normal)
            print("Camera image setting for \(question.question_id)")
            
        }
        else
        {
            cell.cameraBtn.setBackgroundImage(UIImage(named: "cameraiconreport"), for: UIControlState())
            //print("Unset")
            
            
        }
        
//        for var a = 0 ; a < self.violations.allKeys.count ; a++ {
//            let b = self.violations.objectForKey(self.violations.allKeys[a]) as! ADButton
//           // print("Question id \(b.question.question_id)")
//        }
        
        return cell
        
    }
    
    func divideOptions2(_ question : QuestionDao) -> NSMutableArray{
        
        
        let optionArray : NSMutableArray = NSMutableArray()
        for a in 0  ..< question.allOptions.count  {
            let optionDao : OptionDao = question.allOptions.object(at: a) as! OptionDao
            let selected = self.selectedQuestionBank.object(forKey: question.question_id) as? SelectedCellData
            
            if optionDao.option_type == "radio" {
                //println("radio are \(optionDao.allExraOptions.count)")
                for b in 0  ..< optionDao.allExraOptions.count  {
                    let dividedOption : DividedQuestion = DividedQuestion()
                    dividedOption.question = question
                    dividedOption.option = optionDao
                    
                    
                    let extraOption : ExtraOption =  optionDao.allExraOptions.object(at: b) as! ExtraOption
                    //  println("CODEEE \(optionDao.violation_code)")
                    dividedOption.optionTitle = extraOption.value
                    dividedOption.extraOption = extraOption
                    optionArray.add(dividedOption)
                    //println(extraOption.value)
                    if selected != nil {
                        if  selected?.optionSelected == 1
                        {
                            
                            extraOption.is_selected = 0
                            
                            
                        }
                        else {
                            extraOption.is_selected = 0
                            
                        }
                        
                        
                        
                        
                        
                        
                    }
                    else {
                        
                      //  print("Question \(question.question_id) selected \(question.is_selected)")
                        if question.is_selected != 1 {
                            if self.selectAll == 1 && question.is_selected == 0 && a == 0  {
                                if (self.allSelectedQuestions.object(forKey: question.question_id) != nil && self.usersSelectedQuestions.object(forKey: question.question_id) == nil)  {
                                }
                                else {
                                    extraOption.is_selected = 1
                                    
                                    self.usersSelectedQuestions.setObject(question, forKey: question.question_id as NSCopying)
                                    self.allSelectedQuestions.removeObject(forKey: question.question_id)
                                    
                                    print(extraOption.value)
                                }
                            }
                            else if self.selectAll == 0 && a == 0 {
                                if (self.allSelectedQuestions.object(forKey: question.question_id) != nil && self.usersSelectedQuestions.object(forKey: question.question_id) == nil)  {
                                }
                                else {
                                    extraOption.is_selected = 0
                                    self.usersSelectedQuestions.removeObject(forKey: question.question_id)
                                    self.allSelectedQuestions.removeObject(forKey: question.question_id)
                                }
                            }
                        }
                    }
                    
                    // extraOption.is_selected = 1
                }
            }
            
        }// end of the
        
        // println("size with \(optionArray.count)")
        return  optionArray
        
        
        
        
        
    }
    
    func divideOptions(_ question : QuestionDao) -> NSMutableArray{
        
        // as you from webservice , warning , request to attend does not have extra options and radio , dropdown has extra option so we need to convert array into consistant format so that we can show data
        
        let optionArray : NSMutableArray = NSMutableArray()
        for a in 0  ..< question.allOptions.count  {
            let optionDao : OptionDao = question.allOptions.object(at: a) as! OptionDao
            if optionDao.option_type == "warning"
            {
                let dividedOption : DividedQuestion = DividedQuestion()
                dividedOption.question = question
                dividedOption.option = optionDao
                if optionDao.option_label != nil {
                    dividedOption.optionTitle = optionDao.option_label
                    
                }
                else {
                    
                    
                    dividedOption.optionTitle = "Warning"
                }
                optionArray.add(dividedOption)
                
            }
            
            if optionDao.option_type == "request_to_attend"{
                let dividedOption : DividedQuestion = DividedQuestion()
                dividedOption.question = question
                dividedOption.option = optionDao
                // println(dividedOption.option.is_selected)
                if optionDao.option_label != nil {
                    dividedOption.optionTitle = optionDao.option_label
                }
                else {
                    dividedOption.optionTitle = "Request to attend"
                }
                optionArray.add(dividedOption)
                
            }
            
            
            if optionDao.option_type == "radio" {
                //println("radio are \(optionDao.allExraOptions.count)")
                for b in 0  ..< optionDao.allExraOptions.count  {
                    let dividedOption : DividedQuestion = DividedQuestion()
                    dividedOption.question = question
                    dividedOption.option = optionDao
                    
                    
                    let extraOption : ExtraOption =  optionDao.allExraOptions.object(at: b) as! ExtraOption
                    //  println("CODEEE \(optionDao.violation_code)")
                    dividedOption.optionTitle = extraOption.value
                    dividedOption.extraOption = extraOption
                    optionArray.add(dividedOption)
                    //println(extraOption.value)
                }
            }
            else if optionDao.option_type == "drop_down" {
                
                let dividedOption : DividedQuestion = DividedQuestion()
                dividedOption.question = question
                dividedOption.option = optionDao
                // print("extra option count \(optionDao.allExraOptions.count)", terminator: "")
                
                for aa in 0  ..< optionDao.allExraOptions.count  {
                    let eOption = optionDao.allExraOptions.object(at: aa) as! ExtraOption
                    if eOption.is_selected != nil {
                        if eOption.is_selected == 1 {
                            dividedOption.option.is_selected = 1
                        }
                    }
                }
                if optionDao.option_label == "" || optionDao.option_label == nil {
                    dividedOption.optionTitle = "Dropdown"
                }
                else{
                    dividedOption.optionTitle = optionDao.option_label
                }
                optionArray.add(dividedOption)
                
            }
            else if optionDao.option_type == "date" {
                let dividedOption : DividedQuestion = DividedQuestion()
                dividedOption.question = question
                dividedOption.option = optionDao
                dividedOption.optionTitle = optionDao.option_description
                optionArray.add(dividedOption)
            }
            
            
        }// end of the
        
        // println("size with \(optionArray.count)")
        return  optionArray
        
        
        
        
        
        
        
    }
    
    func setupRadiobtncell(_ cell:RadioBtnTableViewCell , option1 : OptionDao , question :QuestionDao , rowIndex : Int)-> RadioBtnTableViewCell {
        
        // if option1.option_type == "radio"{
        
        cell.notesBtn.questionid = Int(question.question_id)
        
        cell.notesBtn.addTarget(self, action: #selector(QuestionListViewController.saveNotes(_:)), for: UIControlEvents.touchUpInside)
        cell.cameraBtn.addTarget(self, action: #selector(QuestionListViewController.setUpCamera(_:)), for: UIControlEvents.touchUpInside)
        cell.cameraBtn.tag = Int(question.question_id)!
        cell.recordBtn.addTarget(self, action: #selector(QuestionListViewController.startRercording(_:)), for: UIControlEvents.touchUpInside)
        cell.recordBtn.tag = Int(question.question_id)!
        
        
        cell.view1.isHidden = false
        cell.questionTitle.text = question.question_desc
        
        //print(option1.allExraOptions.count)
        if option1.allExraOptions.count > 0 {
            let extraOption1 : ExtraOption = option1.allExraOptions.object(at: 0) as! ExtraOption
            cell.title1.text = extraOption1.value
            cell.view1.isHidden = false
            
            cell.radio1.questionid = Int(question.question_id)
            cell.radio1.question = question
            
            cell.radio1.option_id = Int(extraOption1.extra_optionId)
            
            cell.radio1.tag = 1;
            
            cell.radio1.rowIndex = rowIndex
            cell.radio1.addTarget(self, action: #selector(QuestionListViewController.resetRadioBtn(_:)), for: UIControlEvents.touchUpInside)
            
        }
        
        if option1.allExraOptions.count > 1 {
            let extraOption1 : ExtraOption = option1.allExraOptions.object(at: 1) as! ExtraOption
            cell.title2.text = extraOption1.value
            cell.view2.isHidden = false
            cell.radio2.tag = 2;
            cell.radio2.question = question
            cell.radio2.questionid = Int(question.question_id)
            cell.radio2.option_id = Int(extraOption1.extra_optionId)
            cell.radio2.rowIndex = rowIndex
            cell.radio2.addTarget(self, action: #selector(QuestionListViewController.resetRadioBtn(_:)), for: UIControlEvents.touchUpInside)
        }
        
        if option1.allExraOptions.count > 2 {
            let extraOption1 : ExtraOption = option1.allExraOptions.object(at: 2) as! ExtraOption
            cell.title3.text = extraOption1.value
            cell.view3.isHidden = false
            cell.radio3.questionid = Int(question.question_id)
            cell.radio3.question = question
            cell.radio3.tag = 3;
            
            cell.radio3.option_id = Int(extraOption1.extra_optionId)
            cell.radio3.rowIndex = rowIndex
            cell.radio3.addTarget(self, action: #selector(QuestionListViewController.resetRadioBtn(_:)), for: UIControlEvents.touchUpInside)
        }
        
        if option1.allExraOptions.count > 3 {
            let extraOption1 : ExtraOption = option1.allExraOptions.object(at: 3) as! ExtraOption
            cell.title4.text = extraOption1.value
            cell.view4.isHidden = false
            cell.radio4.tag = 4;
            cell.radio4.question = question
            
            cell.radio4.questionid = Int(question.question_id)
            cell.radio4.option_id = Int(extraOption1.extra_optionId)
            cell.radio4.rowIndex = rowIndex
            cell.radio4.addTarget(self, action: #selector(QuestionListViewController.resetRadioBtn(_:)), for: UIControlEvents.touchUpInside)
        }
        
        // }
        return cell
        
    }
    
    func resetDictionaries(_ question : QuestionDao){
        self.selectedQuestionBank.removeObject(forKey: question.question_id)
        self.allSelectedQuestions.removeObject(forKey: question.question_id)
        trackSelectedQuestions.removeObject(forKey: question.question_id)
        recordButtonsDictionary.removeObject(forKey: question.question_id)
        self.allSelectedQuestions.removeObject(forKey: question.question_id)
        self.violations.removeObject(forKey: question.question_id)
        self.allImages.removeObject(forKey: question.question_id)
        
        self.notes.removeObject(forKey: question.question_id)
        self.audio.removeObject(forKey: question.question_id)
        indexPathBank.removeObject(forKey: question.question_id)
        
        
    }
    
    func resetRadioBtn2(_ button : ADButton) {
        self.searchField.resignFirstResponder()
        print(button.tag)
        if button.tag >= 1000 {
            return
            
        }
        
        
        let cell : RadioBtnTableViewCell = self.questionsTable.cellForRow(at: IndexPath(row: button.rowIndex, section: self.expandedIndex > -1 ? self.expandedIndex : 0)) as! RadioBtnTableViewCell
        cell.cameraBtn.isHidden = true
        cell.recordBtn.isHidden = true
        cell.notesBtn.isHidden = true
        cell.nolbl.isHidden = true
        cell.reddot.isHidden = true
        
        cell.amountTextField.isHidden = true
        cell.amountTextField.activity_code = nil

        
        self.selectedQuestionBank.removeObject(forKey: button.question.question_id)
        let selected : SelectedCellData = SelectedCellData()
        selected.optionSelected = 1
        selected.questiontitle = button.question.question_desc
        
        if button.tag == 1 {
            cell.radio2.setImage(UIImage(named:"toggle"), for: UIControlState())
            
               cell.radio2.valueSelect = 0
            
            cell.radio3.setImage(UIImage(named:"toggle"), for: UIControlState())
                      
                         cell.radio3.valueSelect = 0
            
            print("value selected \(button.valueSelect)")
            
            if button.valueSelect == 1 {
                cell.radio1.setImage(UIImage(named:"toggle"), for: UIControlState())
                print("remove object")
                //let selected  = self.selectedQuestionBank.objectForKey(button.question.question_id) as! SelectedCellData
                // selected.optionSelected = 0
                selected.optionSelected = 0
                
                cell.notesBtn.setBackgroundImage(UIImage(named: "notesreport"), for: UIControlState())
                cell.cameraBtn.setBackgroundImage(UIImage(named: "cameraiconreport"), for: UIControlState())
                cell.cameraBtn.mediaId = nil
                //////////cell.cameraBtn2.mediaId = nil
                //cell.cameraBtn3.mediaId = nil
                cell.recordBtn.mediaId = nil
                cell.radio1.valueSelect = 0
                button.valueSelect = 0
                selected.optionSelected = 0
                self.resetDictionaries(button.question)
                
                //cell.cameraBtn.setBackgroundImage(img, forState: UIControlState.Normal)
                
                cell.recordBtn.setImage(UIImage(named: "recordiconreport"), for: UIControlState())
                
                //cell.questionTitle.textColor = UIColor.blackColor()
                //self.allImages.removeObjectForKey(button.question.question_id)
                
                
            }
            else {
                
                if cell.radio2.valueSelect == 1 {
                    cell.radio2.setImage(UIImage(named:"toggle"), for: UIControlState())
                    cell.radio2.valueSelect = 0
                    button.valueSelect = 1
                    selected.optionSelected = 1
                    cell.radio1.setImage(UIImage(named:"toggle_on"), for: UIControlState())
                    cell.cameraBtn.isHidden = false
                    //////////cell.cameraBtn2.hidden = false
                    //cell.cameraBtn3.hidden = false
                    cell.recordBtn.isHidden = false
                    cell.notesBtn.isHidden = false
                    
                    self.allSelectedQuestions.setObject(String(button.extraOption.extra_optionId), forKey:String(button.question.question_id) as NSCopying)
                    if cell.radio1.extraOption.valication_code != nil {
                        button.violation_code = cell.radio1.extraOption.valication_code
                        let btn : ADButton = ADButton()
                        btn.question = button.question
                        self.violations.setObject(btn, forKey: button.question.question_id as NSCopying)
                        
                        cell.radio1.setImage(UIImage(named:"toggle_red"), for: UIControlState())
                        cell.barIndicator.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
                        
                        //cell.questionTitle.textColor = UIColor(red: 104/255, green: 0, blue: 0, alpha: 1)
                        
                        selected.questionStatus = 3 // violation
                         
                    }
                    else {
                        self.violations.removeObject(forKey: button.question.question_id)
                        // cell.questionTitle.text = button.question.question_desc
                        //  cell.questionTitle.textColor = UIColor(red: 52/255, green: 40/255, blue: 44/255, alpha: 1.0)
                        cell.barIndicator.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
                        
                        cell.cameraBtn.isHidden = true
                        cell.recordBtn.isHidden = true
                        cell.notesBtn.isHidden = true
                        
                        //////////cell.cameraBtn2.hidden = true
                        //cell.cameraBtn3.hidden = true
                    
                    }
                    
                }
                else {
                    button.valueSelect = 1
                    selected.optionSelected = 1
                    cell.radio1.setImage(UIImage(named:"toggle_on"), for: UIControlState())
                    self.allSelectedQuestions.setObject(String(button.extraOption.extra_optionId), forKey:String(button.question.question_id) as NSCopying)
                    
                    
                    if cell.radio1.extraOption.valication_code != nil {
                        cell.radio1.setImage(UIImage(named:"toggle_red"), for: UIControlState())
                        cell.barIndicator.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
                        cell.cameraBtn.isHidden = false
                        cell.recordBtn.isHidden = false
                        cell.notesBtn.isHidden = false
                        //////////cell.cameraBtn2.hidden = false
                        //cell.cameraBtn3.hidden = false
                        
                        button.violation_code = cell.radio1.extraOption.valication_code
                        
                        let btn : ADButton = ADButton()
                        btn.question = button.question
                        self.violations.setObject(btn, forKey: button.question.question_id as NSCopying)
                        
                        
                        // cell.questionTitle.textColor = UIColor(red: 104/255, green: 0, blue: 0, alpha: 1)
                        
                        
                        
                        selected.questionStatus = 3 // violation
                        
                        
                        
                    }
                    else {
                        self.violations.removeObject(forKey: button.question.question_id)
                        //cell.questionTitle.text = button.question.question_desc
                        //cell.questionTitle.textColor = UIColor(red: 52/255, green: 40/255, blue: 44/255, alpha: 1.0)
                        cell.barIndicator.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
                        
                        if button.extraOption.is_media == "1" {
                            cell.cameraBtn.isHidden = false
                            cell.recordBtn.isHidden = false
                            cell.notesBtn.isHidden =  false
                            
                        }
                        
                    }
                    
                    
                    
                }
                
            }
        } // its first button
            
           else  if button.tag == 3 {
                      cell.radio2.setImage(UIImage(named:"toggle"), for: UIControlState())
                     cell.radio2.valueSelect = 0
                   cell.radio1.setImage(UIImage(named:"toggle"), for: UIControlState())
                        cell.radio1.valueSelect = 0
                    print("value selected \(button.valueSelect)")
                      
                      if button.valueSelect == 1 {
                          cell.radio3.setImage(UIImage(named:"toggle"), for: UIControlState())
                          print("remove object")
                          //let selected  = self.selectedQuestionBank.objectForKey(button.question.question_id) as! SelectedCellData
                          // selected.optionSelected = 0
                          selected.optionSelected = 0
                          
                          cell.notesBtn.setBackgroundImage(UIImage(named: "notesreport"), for: UIControlState())
                          cell.cameraBtn.setBackgroundImage(UIImage(named: "cameraiconreport"), for: UIControlState())
                          cell.cameraBtn.mediaId = nil
                          //////////cell.cameraBtn2.mediaId = nil
                          //cell.cameraBtn3.mediaId = nil
                          cell.recordBtn.mediaId = nil
                          cell.radio3.valueSelect = 0
                          button.valueSelect = 0
                          selected.optionSelected = 0
                          self.resetDictionaries(button.question)
                          
                          //cell.cameraBtn.setBackgroundImage(img, forState: UIControlState.Normal)
                          
                          cell.recordBtn.setImage(UIImage(named: "recordiconreport"), for: UIControlState())
                          
                          //cell.questionTitle.textColor = UIColor.blackColor()
                          //self.allImages.removeObjectForKey(button.question.question_id)
                          
                          
                      }
                      else {
                          
                          if cell.radio2.valueSelect == 1 {
                              cell.radio2.setImage(UIImage(named:"toggle"), for: UIControlState())
                              cell.radio2.valueSelect = 0
                              button.valueSelect = 1
                              selected.optionSelected = 3
                              cell.radio3.setImage(UIImage(named:"toggle_on_yellow"), for: UIControlState())
                              cell.cameraBtn.isHidden = false
                              //////////cell.cameraBtn2.hidden = false
                              //cell.cameraBtn3.hidden = false
                              cell.recordBtn.isHidden = false
                              cell.notesBtn.isHidden = false
                              
                              self.allSelectedQuestions.setObject(String(button.extraOption.extra_optionId), forKey:String(button.question.question_id) as NSCopying)
                              if cell.radio3.extraOption.valication_code != nil {
                                  button.violation_code = cell.radio1.extraOption.valication_code
                                  let btn : ADButton = ADButton()
                                  btn.question = button.question
                                  self.violations.setObject(btn, forKey: button.question.question_id as NSCopying)
                                  
                                  cell.radio3.setImage(UIImage(named:"toggle_red"), for: UIControlState())
                                  cell.barIndicator.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
                                  
                                  //cell.questionTitle.textColor = UIColor(red: 104/255, green: 0, blue: 0, alpha: 1)
                                  
                                  selected.questionStatus = 3 // violation
                                   
                              }
                              else {
                                  self.violations.removeObject(forKey: button.question.question_id)
                                  // cell.questionTitle.text = button.question.question_desc
                                  //  cell.questionTitle.textColor = UIColor(red: 52/255, green: 40/255, blue: 44/255, alpha: 1.0)
                                  cell.barIndicator.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
                                  // SHOW MEDIA FOR WARNINGS
                                
                                  cell.cameraBtn.isHidden = true
                                  cell.recordBtn.isHidden = true
                                  cell.notesBtn.isHidden = true
                                  
                                  //////////cell.cameraBtn2.hidden = true
                                  //cell.cameraBtn3.hidden = true
                              
                              }
                              
                          }
                          else {
                              button.valueSelect = 1
                              selected.optionSelected = 3
                              cell.radio3.setImage(UIImage(named:"toggle_on_yellow"), for: UIControlState())
                              self.allSelectedQuestions.setObject(String(button.extraOption.extra_optionId), forKey:String(button.question.question_id) as NSCopying)
                              
                              
                              if cell.radio3.extraOption.valication_code != nil {
                                  cell.radio3.setImage(UIImage(named:"toggle_red"), for: UIControlState())
                                  cell.barIndicator.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
                                  cell.cameraBtn.isHidden = false
                                  cell.recordBtn.isHidden = false
                                  cell.notesBtn.isHidden = false
                                  //////////cell.cameraBtn2.hidden = false
                                  //cell.cameraBtn3.hidden = false
                                  
                                  button.violation_code = cell.radio1.extraOption.valication_code
                                  
                                  let btn : ADButton = ADButton()
                                  btn.question = button.question
                                  self.violations.setObject(btn, forKey: button.question.question_id as NSCopying)
                                  
                                  
                                  // cell.questionTitle.textColor = UIColor(red: 104/255, green: 0, blue: 0, alpha: 1)
                                  
                                  
                                  
                                  selected.questionStatus = 3 // violation
                                  
                                  
                                  
                              }
                              else {
                                  self.violations.removeObject(forKey: button.question.question_id)
                                  //cell.questionTitle.text = button.question.question_desc
                                  //cell.questionTitle.textColor = UIColor(red: 52/255, green: 40/255, blue: 44/255, alpha: 1.0)
                                  cell.barIndicator.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
                                  cell.cameraBtn.isHidden = false
                                  cell.recordBtn.isHidden = false
                                  cell.notesBtn.isHidden =  false
                                
                                  if button.extraOption.is_media == "1" {
                                      cell.cameraBtn.isHidden = false
                                      cell.recordBtn.isHidden = false
                                      cell.notesBtn.isHidden =  false
                                      
                                  }
                                  
                              }
                              
                              
                              
                          }
                          
                      }
                  } // its first button
            
            
          // end of the third button
            
        else if button.tag == 2 {
            // its button 2
            cell.radio1.setImage(UIImage(named:"toggle"), for: UIControlState())
            cell.radio3.setImage(UIImage(named:"toggle"), for: UIControlState())
            cell.radio1.valueSelect = 0
            cell.radio3.valueSelect = 0
            if button.valueSelect == 1 {
                cell.radio2.setImage(UIImage(named:"toggle"), for: UIControlState())
                print("remove object")
                //let selected  = self.selectedQuestionBank.objectForKey(button.question.question_id) as! SelectedCellData
                // selected.optionSelected = 0
                selected.optionSelected = 0
                 cell.notesBtn.setBackgroundImage(UIImage(named: "notesreport"), for: UIControlState())
                cell.cameraBtn.setBackgroundImage(UIImage(named: "cameraiconreport"), for: UIControlState())
                cell.cameraBtn.mediaId = nil
                //////////cell.cameraBtn2.mediaId = nil
                //cell.cameraBtn3.mediaId = nil
                
                cell.recordBtn.mediaId = nil
                cell.radio2.valueSelect = 0
                button.valueSelect = 0
                self.resetDictionaries(button.question)
                
                //cell.cameraBtn.setBackgroundImage(img, forState: UIControlState.Normal)
                cell.recordBtn.setImage(UIImage(named: "recordiconreport"), for: UIControlState())
                
                //cell.questionTitle.textColor = UIColor.blackColor()
                //self.allImages.removeObjectForKey(button.question.question_id)
                
            }
            else {
                if cell.radio1.valueSelect == 1 {
                    cell.radio1.setImage(UIImage(named:"toggle"), for: UIControlState())
                    cell.radio1.valueSelect = 0
                    cell.radio2.valueSelect = 1
                    selected.optionSelected = 2
                    cell.radio2.setImage(UIImage(named:"toggle_on"), for: UIControlState())
                    self.allSelectedQuestions.setObject(String(button.extraOption.extra_optionId), forKey:String(button.question.question_id) as NSCopying)
                    if cell.radio2.extraOption.valication_code != nil {
                        button.violation_code = cell.radio2.extraOption.valication_code
                        cell.cameraBtn.isHidden = false
                        //////////cell.cameraBtn2.hidden = false
                        //cell.cameraBtn3.hidden = false
                        cell.recordBtn.isHidden = false
                        cell.notesBtn.isHidden = false
                        let btn : ADButton = ADButton()
                        btn.question = button.question
                        self.violations.setObject(btn, forKey: button.question.question_id as NSCopying)
                        cell.radio2.setImage(UIImage(named:"toggle_red"), for: UIControlState())
                        cell.barIndicator.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
                        
                        // cell.questionTitle.textColor = UIColor(red: 104/255, green: 0, blue: 0, alpha: 1)
                        
                        if button.question.violation_code == "8501" || button.question.violation_code == "8502" {
                            cell.amountTextField.isHidden = false
                            cell.amountTextField.activity_code = button.question.violation_code
                             
                        }
                        else {
                            cell.amountTextField.isHidden = true
                            cell.amountTextField.activity_code = nil
                            
                        }
                        selected.questionStatus = 3 // violation
                           }
                    else {
                        self.violations.removeObject(forKey: button.question.question_id)
                        // cell.questionTitle.text = button.question.question_desc
                        //// cell.questionTitle.textColor = UIColor(red: 52/255, green: 40/255, blue: 44/255, alpha: 1.0)
                        cell.barIndicator.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
                        if button.extraOption.is_media == "1" {
                                                  cell.cameraBtn.isHidden = false
                                                  cell.recordBtn.isHidden = false
                                                  cell.notesBtn.isHidden =  false
                                                  
                    }
                    }
                    
                }
                else {
                    cell.radio2.valueSelect = 1
                    selected.optionSelected = 2
                    cell.radio2.setImage(UIImage(named:"toggle_on"), for: UIControlState())
                    self.allSelectedQuestions.setObject(String(button.extraOption.extra_optionId), forKey:String(button.question.question_id) as NSCopying)
                    if cell.radio2.extraOption.valication_code != nil {
                        cell.cameraBtn.isHidden = false
                        cell.recordBtn.isHidden = false
                        cell.notesBtn.isHidden = false
                        //////////cell.cameraBtn2.hidden = false
                        //cell.cameraBtn3.hidden = false
                        
                        cell.radio2.setImage(UIImage(named:"toggle_red"), for: UIControlState())
                        cell.barIndicator.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
                        button.violation_code = cell.radio2.extraOption.valication_code
                        let btn : ADButton = ADButton()
                        btn.question = button.question
                        self.violations.setObject(btn, forKey: button.question.question_id as NSCopying)
                        // self.violations.setObject(button, forKey: button.question.question_id)
                        
                        //cell.questionTitle.textColor = UIColor(red: 104/255, green: 0, blue: 0, alpha: 1)
                        
                        
                        if button.question.violation_code == "8501" || button.question.violation_code == "8502" {
                            cell.amountTextField.isHidden = false
                            cell.amountTextField.activity_code = button.question.violation_code
                                            }
                        else {
                            cell.amountTextField.isHidden = true
                            cell.amountTextField.activity_code = nil
                            }
                        selected.questionStatus = 3 // violation
                        
                    }
                    else {
                        self.violations.removeObject(forKey: button.question.question_id)
                        //cell.questionTitle.text = button.question.question_desc
                        // cell.questionTitle.textColor = UIColor(red: 52/255, green: 40/255, blue: 44/255, alpha: 1.0)
                        cell.barIndicator.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
                        cell.cameraBtn.isHidden = true
                        //////////cell.cameraBtn2.hidden = true
                        //cell.cameraBtn3.hidden = true
                        cell.recordBtn.isHidden = true
                        cell.notesBtn.isHidden = true
                        cell.amountTextField.isHidden = true
                        cell.amountTextField.activity_code = nil
                        
                        if button.extraOption.is_media == "1" {
                            cell.cameraBtn.isHidden = false
                            cell.recordBtn.isHidden = false
                            cell.notesBtn.isHidden = false
                            
                        }  } } } }
        
        
        self.selectedQuestionBank.setObject(selected, forKey: button.question.question_id as NSCopying)
        
        
        self.indexPathBank.setObject(cell, forKey: button.question.question_id as NSCopying)
        
    }// end of the resetRadioBtn2
    
    
    func changeValueInHistory(_ sender : ADButton) {
      
        
        
        //        if sender.radioCell.radio1.extraOption.is_selected == 1 && sender.radioCell.radio1.extraOption.inspector_id != self.appDel.user.user_id  {
//          
//            return
//        }
        
        print(self.appDel.history_task?.inspection_type)
        print(self.appDel.history_task?.task_status)
        
        
        
        if (self.appDel.history_task?.inspection_type)! == "co-inspection" && self.appDel.history_task?.task_status == "notstarted" {
        
        
    if sender.tag == 2 {
            if sender.radioCell.radio1.extraOption.inspector_id == self.appDel.user.user_id  ||  sender.radioCell.radio1.extraOption.inspector_id != nil{
                
                let sAlert = SCLAlertView()
                               sAlert.addButton("Yes", action: {
                       sender.radioCell.radio1.setImage(UIImage(named: "toggle"), for: UIControlState())
                        sender.radioCell.radio2.setImage(UIImage(named: "toggle_red"), for: UIControlState())
                        sender.radioCell.radio2.extraOption.inspector_id = self.appDel.user.user_id
                        
                        sender.radioCell.radio1.valueSelect = 0
                        sender.radioCell.radio2.valueSelect = 1
                        if sender.question.violation_code == "8501" || sender.question.violation_code == "8502" {
                            sender.radioCell.amountTextField.isHidden = false
                            sender.radioCell.amountTextField.activity_code = sender.question.violation_code
                            sender.radioCell.amountTextField.extraOptionId = sender.radioCell.radio2.extraOption.extra_optionId
                            sender.radioCell.amountTextField.question_id = sender.question.question_id
                            }
                        else {
                            sender.radioCell.amountTextField.isHidden = true
                            sender.radioCell.amountTextField.activity_code = nil
                            
                            let downloader = DataDownloader()
                            downloader.delegate = self
                            downloader.iden = "updatequestions"
                            let url = URL(string: Constants.baseURL + "updateInspectionQuestions")
                            
                            if self.appDel.user.user_id != nil && self.appDel.history_task!.id != nil && sender.question.question_id != nil && sender.radioCell.radio2.extraOption.extra_optionId != nil {
                                
                                downloader.sendPostQuestionChange(url!, inspector_id: self.appDel.user.user_id, task_id: self.appDel.history_task!.id!, question_id: sender.question.question_id, extra_option_id: sender.radioCell.radio2.extraOption.extra_optionId!,td_amount: nil)
                            }
                            
                        }

                        })
                sAlert.addButton("Dismiss", action:{})

                sAlert.showCloseButton = false
                sAlert.showEdit("Edit Results", subTitle: "Do you want to change inspection results?")
                
    }
            else {
        
        
         let sAlert = SCLAlertView()
        sAlert.showCloseButton = true
        sAlert.showInfo("Edit Results", subTitle: "You can only edit those results which are submitted by you.")
        }
    }
        else {
           
                
                if sender.radioCell.radio2.extraOption.inspector_id == self.appDel.user.user_id {
            
            let sAlert = SCLAlertView()
            
           
            
            
            sAlert.addButton("Yes", action: {
                
                sender.radioCell.radio2.setImage(UIImage(named: "toggle"), for: UIControlState())
                sender.radioCell.radio1.setImage(UIImage(named: "toggle_on"), for: UIControlState())
                sender.radioCell.radio2.valueSelect = 0
                sender.radioCell.radio1.valueSelect = 1
                sender.radioCell.amountTextField.isHidden = true
                sender.radioCell.amountTextField.activity_code = nil
                sender.radioCell.radio1.extraOption.inspector_id = self.appDel.user.user_id
                
                let downloader = DataDownloader()
                downloader.delegate = self
                downloader.iden = "updatequestions"
                let url = URL(string: Constants.baseURL + "updateInspectionQuestions")
                if self.appDel.user.user_id != nil && self.appDel.history_task!.id != nil && sender.question.question_id != nil && sender.radioCell.radio1.extraOption.extra_optionId != nil {
                    downloader.sendPostQuestionChange(url!, inspector_id: self.appDel.user.user_id, task_id: self.appDel.history_task!.id!, question_id: sender.question.question_id, extra_option_id: sender.radioCell.radio1.extraOption.extra_optionId!,td_amount: nil)
                    
                }
                
                })
            
            sAlert.showCloseButton = false
             sAlert.addButton("Dismiss", action:{ })
                    
            sAlert.showEdit("Edit Results", subTitle: "Do you want to change inspection results?")
            
            
            
            
            
            print("Selected By \(sender.radioCell.radio1.extraOption.inspector_id)")
            print("Current user By \(self.appDel.user.user_id)")
            

          
        
        
        }
                else {
                    
                    
                    let sAlert = SCLAlertView()
                    sAlert.showCloseButton = true
                    sAlert.showInfo("Edit Results", subTitle: "You can only edit those results which are submitted by you.")
        }

            }
        }
    
    } // end of the changeValueInHistory
    
    func changeResult(){
    
    }
    
    @objc func resetRadioBtn(_ button : ADButton){
        //button.question.all
        
        var dontSave : Int = 0
        // disable selection when user is coming from history
        if self.appDel.fromHistoryToResult == 1 {
            self.changeValueInHistory(button)
            return
        }
        if self.appDel.taskDao != nil {
        if self.appDel.taskDao.parent_task_id != nil {
            if self.appDel.show_result == 1 && (self.appDel.taskDao.parent_task_id as! NSString).intValue <= 0 {
                if self.allSelectedQuestions.object(forKey: button.question.question_id) != nil && self.usersSelectedQuestions.object(forKey: button.question.question_id) == nil {
                    print("returning its already selected")
                    return
                }
                
                
            }
        }
        }
        let option : OptionDao = button.option
        
        self.usersSelectedQuestions.setObject(button, forKey: button.question.question_id as NSCopying)
        self.resetRadioBtn2(button)
        return
        
        // print(option.option_type)
        let selected : SelectedCellData = SelectedCellData()
        selected.optionSelected = 1
        selected.questiontitle = button.question.question_desc
        // trackSelectedQuestions is used to track which questions are selected so that it will select not first option  by default
        // trackSelectedQuestions used in resetRadioBtn(to set selected question in dictionary) , setupradiocell(to check if object exits on key)
        
        self.trackSelectedQuestions.setObject("1", forKey: button.question.question_id as NSCopying)
        
        let cell : RadioBtnTableViewCell = self.questionsTable.cellForRow(at: IndexPath(row: button.rowIndex, section: 0)) as! RadioBtnTableViewCell
        // Traverse all buttons in RadioBtnTableViewCell
        for  v in cell.contentView.subviews {
            for v2 in v.subviews {
                if v2.isKind(of: ADButton.self) {
                    print("In kind of class \(v2.tag) button tag \(button.tag) value \(button.valueSelect)")
                    if v2.tag >= 1000 {
                        // ADButton is custom class , there are different types of buttons in one row , for media and selection , so if button has tag >= 1000 means that is media button so dont need to reset it so only two buttons are usefull
                        
                        return
                    }
                    let v1 = v2 as! ADButton
                    //print(v1.tag)
                    
                    if v1.tag == button.tag {
                        // if button is already selected than reset it , and change image to unselected which is toggle
                        if v1.valueSelect == 1 {
                            v1.valueSelect = 0
                            // print("set toggle")
                            //v1.setImage(UIImage(named:"radiobox"), forState: UIControlState.Normal)
                            
                            v1.setImage(UIImage(named:"toggle"), for: UIControlState())
                            print("remove object")
                            //let selected  = self.selectedQuestionBank.objectForKey(button.question.question_id) as! SelectedCellData
                            // selected.optionSelected = 0
                            selected.optionSelected = 0
                            
                            cell.notesBtn.setBackgroundImage(UIImage(named: "notesreport"), for: UIControlState())
                            cell.cameraBtn.setBackgroundImage(UIImage(named: "cameraiconreport"), for: UIControlState())
                            cell.cameraBtn.mediaId = nil
                            cell.recordBtn.mediaId = nil
                            
                            self.resetDictionaries(button.question)
                            
                            //cell.cameraBtn.setBackgroundImage(img, forState: UIControlState.Normal)
                            
                            cell.recordBtn.setImage(UIImage(named: "recordiconreport"), for: UIControlState())
                            
                            //cell.questionTitle.textColor = UIColor.blackColor()
                            //self.allImages.removeObjectForKey(button.question.question_id)
                            
                            
                        }
                        else {
                            v1.valueSelect = 1
                            //print("selecting \(v1.buttonnumber)")
                            selected.optionSelected = v1.buttonnumber
                            
                            //  v1.setImage(UIImage(named:"radio_sel"), forState: UIControlState.Normal)
                            v1.setImage(UIImage(named:"toggle_on"), for: UIControlState())
                            
                            // Alldates is dictionary which is keeping data information so if selected item is warning or drop down tha just hide the
                            if button.option.option_type == "drop_down"  ||  button.option.option_type == "warning"  {
                                self.allDates.removeObject(forKey: button.question.question_id)
                                dontSave = 1
                                
                                self.showDropDown(button)
                            }
                            else {
                                self.calulatedWarnings.removeObject(forKey: button.question.question_id)
                            }
                            
                            
                            if button.option.option_type == "date" ||  button.option.option_type == "request_to_attend" {
                                dontSave = 1
                                self.showDatePicket(button)
                            }
                            if button.option.option_type == "radio"{
                                
                                self.allSelectedQuestions.setObject(String(button.extraOption.extra_optionId), forKey:String(button.question.question_id) as NSCopying)
                                if button.extraOption.valication_code != nil {
                                    self.violations.setObject(button, forKey: button.question.question_id as NSCopying)
                                    
                                    //cell.questionTitle.textColor = UIColor(red: 104/255, green: 0, blue: 0, alpha: 1)
                                    
                                    
                                    selected.questionStatus = 3 // violation
                                    
                                    
                                    
                                }
                                else {
                                    self.violations.removeObject(forKey: button.question.question_id)
                                    //cell.questionTitle.text = button.question.question_desc
                                    //cell.questionTitle.textColor = UIColor(red: 52/255, green: 40/255, blue: 44/255, alpha: 1.0)
                                    
                                    
                                    self.allDates.removeObject(forKey: button.question.question_id)
                                }
                            } // end of the radio
                            
                        }
                    }
                    else {
                        
                        print("Toggle in else")
                        v1.valueSelect = 0
                        // v1.setImage(UIImage(named:"radiobox"), forState: UIControlState.Normal)
                        v1.setImage(UIImage(named:"toggle"), for: UIControlState())
                        
                        
                        
                    }
                    
                    
                }
            }
        }
        if dontSave == 0 {
            self.selectedQuestionBank.setObject(selected, forKey: button.question.question_id as NSCopying)
        }
        
        self.indexPathBank.setObject(cell, forKey: button.question.question_id as NSCopying)
        
        //        cell.radio1.setImage(UIImage(named: ""), forState: UIControlState.Normal)
        //        cell.radio1.setImage(UIImage(named: ""), forState: UIControlState.Normal)
        //        cell.radio1.setImage(UIImage(named: ""), forState: UIControlState.Normal)
        //        cell.radio1.setImage(UIImage(named: ""), forState: UIControlState.Normal)
        //
        
    }
    
    @objc func resetCheckBox(_ button : ADButton){
        if button.valueSelect == 1 {
            button.setImage(UIImage(named: "checkbox"), for: UIControlState())
            button.valueSelect = 0
            var values : String = (self.allSelectedQuestions.object(forKey: String(button.questionid)) as? String)!
            var valuesStr : NSString = NSString(string: values)
            valuesStr = valuesStr.replacingOccurrences(of: String(button.option_id)+",", with: "") as NSString
            values = String(valuesStr)
            self.allSelectedQuestions.setObject(values, forKey: String(button.question.question_id) as NSCopying)
            
            
            
            
        }
        else {
            button.setImage(UIImage(named: "checkbox_sel"), for: UIControlState())
            button.valueSelect = 1
            if(self.allSelectedQuestions.object(forKey: String(button.questionid)) != nil){
                var values : String = (self.allSelectedQuestions.object(forKey: String(button.questionid)) as? String)!
                values = values + "," + String(button.option_id)
                self.allSelectedQuestions.setObject(values, forKey: String(button.questionid) as NSCopying)
                //     println(values)
                
            }
            else {
                self.allSelectedQuestions.setObject(String(button.option_id), forKey: String(button.questionid) as NSCopying)
            }
            
        }
        
    }
    
    @objc func saveNotes(_ sender : ADButton){
        //self.performSegueWithIdentifier("sw_notes", sender: nil)
        //
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "cnt_notesnav") as! UINavigationController
        let cnt : NotesViewController = popoverVC.topViewController as! NotesViewController
        cnt.btn = sender
        if (self.appDel.show_result == 1 && self.allSelectedQuestions.object(forKey: sender.question.question_id) != nil && self.usersSelectedQuestions.object(forKey: sender.question.question_id) == nil) {
            cnt.isEditable = 0
            
        }
        
        
        cnt.notes = self.notes
        if self.appDel.fromHistoryToResult == 1{
            cnt.notesStr = sender.question.notes
        }
        //cnt.notesText.text = self.notes.objectForKey(String(sender.questionid)) as? String
        
        
        cnt.delegate = self
        popoverVC.modalPresentationStyle = .formSheet
        present(popoverVC, animated: true, completion: nil)
        //        let popoverController = popoverVC.popoverPresentationController
        //
        //        popoverController!.sourceView = sender     // popoverController!.sourceRect = sender.frame
        //        popoverController!.permittedArrowDirections = UIPopoverArrowDirection.Up
        //
    }
    func setupCheckBoxCell(_ cell : CheckBoxTableViewCell , option1 : OptionDao , question : QuestionDao) -> CheckBoxTableViewCell{
        if option1.option_type == "checkbox"{
            cell.notesbtm.questionid = Int(question.question_id)
            cell.notesbtm.addTarget(self, action: #selector(QuestionListViewController.saveNotes(_:)), for: UIControlEvents.touchUpInside)
            cell.camerabtn.addTarget(self, action: #selector(QuestionListViewController.setUpCamera(_:)), for: UIControlEvents.touchUpInside)
            cell.camerabtn.tag = Int(question.question_id)!
            cell.micbtn.addTarget(self, action: #selector(QuestionListViewController.startRercording(_:)), for: UIControlEvents.touchUpInside)
            cell.micbtn.tag = Int(question.question_id)!
            
            
            cell.view1.isHidden = false
            cell.questiontitle.text = question.question_desc
            
            print(option1.allExraOptions.count)
            if option1.allExraOptions.count > 0 {
                let extraOption1 : ExtraOption = option1.allExraOptions.object(at: 0) as! ExtraOption
                cell.title1.text = extraOption1.value
                cell.view1.isHidden = false
                
                cell.check1.questionid = Int(question.question_id)
                cell.check1.option_id = Int(extraOption1.extra_optionId)
                
                cell.check1.addTarget(self, action: #selector(QuestionListViewController.resetCheckBox(_:)), for: UIControlEvents.touchUpInside)
                
            }
            
            if option1.allExraOptions.count > 1 {
                let extraOption1 : ExtraOption = option1.allExraOptions.object(at: 1) as! ExtraOption
                cell.title2.text = extraOption1.value
                cell.view2.isHidden = false
                cell.check2.questionid = Int(question.question_id)
                cell.check2.option_id = Int(extraOption1.extra_optionId)
                cell.check2.addTarget(self, action: #selector(QuestionListViewController.resetCheckBox(_:)), for: UIControlEvents.touchUpInside)
                
            }
            
            if option1.allExraOptions.count > 2 {
                let extraOption1 : ExtraOption = option1.allExraOptions.object(at: 2) as! ExtraOption
                cell.title3.text = extraOption1.value
                cell.view3.isHidden = false
                cell.check3.questionid = Int(question.question_id)
                cell.check3.option_id = Int(extraOption1.extra_optionId)
                cell.check3.addTarget(self, action: #selector(QuestionListViewController.resetCheckBox(_:)), for: UIControlEvents.touchUpInside)
                
            }
            
            if option1.allExraOptions.count > 3 {
                let extraOption1 : ExtraOption = option1.allExraOptions.object(at: 3) as! ExtraOption
                cell.title4.text = extraOption1.value
                cell.view4.isHidden = false
                cell.check4.questionid = Int(question.question_id)
                cell.check4.option_id = Int(extraOption1.extra_optionId)
                cell.check1.addTarget(self, action: #selector(QuestionListViewController.resetCheckBox(_:)), for: UIControlEvents.touchUpInside)
                
            }
            
            
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return 100
    //    }
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //println("Question size \(allQuestion.count)")
        if self.isSearching == 1 {
            return self.searchedArry.count
            
            
        }
        
        if self.questionCategories.count > 0 && self.isExpanded == 0 {
            
            return 0
        }
        if self.isExpanded == 1 &&  self.expandedIndex == section {
            
           return self.allQuestion.count
        
        
        }
        
        if self.isExpanded == 1 &&  self.expandedIndex != section {
            
            return 0
            
        }
        
        
        
        
        return allQuestion.count
        
    }
    
    func siteNotreadyTasks(){
        
        let loginUrl = Constants.baseURL + "changeTaskStatus?task_id=" + self.appDel.taskDao.task_id + "&status=unfinished"
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "notready")
        
        
    }
    @objc func countSeconds(){
        // self.timerSecond = timerSecond + 1
        self.appDel.totalSpendSecond = self.appDel.totalSpendSecond + 1
        
        let minutes : Int = (self.appDel.totalSpendSecond / 60)
        let hours : Int = minutes / 60
        
        let second  = (self.appDel.totalSpendSecond % 60)
        
        //        print("Minutes \(minutes)")
        //        print("Hours \(hours)")
        //        print("all seconds\(timerSecond)")
        //
        // let hour = (self.timerSecond / 60)/60
        // let minute = (self.timerSecond/60)
        
        
        self.timerlbl.text = "\(hours):\(minutes):\(second)"
        
    }
    @objc func goBack(){
        self.navigationController?.popToViewController((self.navigationController?.viewControllers[3])!, animated: true)
    }
    
    
    @IBAction func backMethod(_ sender: AnyObject) {
        if self.appDel.fromHistoryToResult != 1 {
            let alert = SCLAlertView()
            alert.showCloseButton = false
            
            alert.addButton(localisation.localizedString(key: "general.yes"), action: {
                if self.appDel.taskDao != nil {
                self.appDel.taskDao.task_status = "Not Started"
                    self.appDel.searchedDriver = ""
                    self.appDel.searchedCar = ""
                    self.appDel.selectedIndividual = nil
                    self.appDel.inspectionByIndividual = 0


               self.appDel.user.status = "Active"
                    
                self.databaseManager.changeOnMyWayStatus(self.appDel.taskDao.task_id, status: self.appDel.taskDao.task_status)
                }
                if self.appDel.totalSpendSecond > 0{
                    
                    
                    
                    self.navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true)
                }
                else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            
            alert.addButton(localisation.localizedString(key: "tasks.dismiss"), action: {
                
                
            })
            alert.showInfo("", subTitle: self.localisation.localizedString(key:"questions.areyousurewanttoexit"))
            
        }
            
        else {
            if self.appDel.totalSpendSecond > 0{
                self.navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true)
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    
    
    
    @IBAction func showCompanyDetail(_ sender: AnyObject) {
        print("Company Detail Pressed")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue!, sender: Any!) {
        print("prepare for segue called")
        if segue.identifier == "sw_showmultiimages" {
        let cnt = segue.destination as! MultiImageViewController
            print(currentBtn.question.allImages.count)
            cnt.multipleImageArray = currentBtn.question.allImages
            cnt.question = currentBtn.question
            cnt.delegate = self
            
        
        }
        else {
         self.company_detail_pressed = 1
        self.appDel.showCompanyDetail = 1
        }
        
    }
    
    func createAdhoc() {
        self.appDel.searchedCompany = self.appDel.taskDao.company
        self.appDel.completedTask = self.appDel.taskDao
        let cnt = self.storyboard?.instantiateViewController(withIdentifier: "cnt_createInspection")
        self.navigationController?.pushViewController(cnt!, animated: true)
        
        
    }

    func deselectAllQuestion(){
        for a in self.allQuestion  {
            if let q = a as? QuestionDao {
                if self.usersSelectedQuestions.object(forKey: q.question_id) != nil {
                
                }
                else {
                self.allSelectedQuestions.removeObjects(forKeys: [q.question_id])
                }
            }
        }
    }
    func setupAllQuestionSelected(){
        for a in self.allQuestion  {
            if let q = a as? QuestionDao {
                if self.allSelectedQuestions.object(forKey: q.question_id) == nil {
                    for b in q.allOptions {
                        if let o = b as? OptionDao {
                            for c in o.allExraOptions  {
                                if let eo = c as? ExtraOption {
                                    if eo.value == "مستوفي" {
                                       // self.allSelectedQuestions.setValue(a.question_id, forKey: eo.extra_optionId)
                                        self.allSelectedQuestions.setValue(eo.extra_optionId, forKey:q.question_id)
                                        
                                       
                                        
                                        //print(self.allSelectedQuestions)
                                    }
                                }
                            }
                        }
                    }
                } // end of the if
                else {
                
                }
            }
        }// end of the for loop
        
        print(self.allSelectedQuestions)

    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.setupRecorder()
        //self.preparePlayer()
        self.warningArray.add("1 Week")
        self.warningArray.add("2 Weeks")
        self.warningArray.add("3 Weeks")
        self.warningArray.add("4 Weeks")
        self.warningArray.add("Open")
        self.searchField.layer.cornerRadius = 4.0
        self.searchView.layer.cornerRadius = 2.0
        self.searchView.layer.borderColor = UIColor.white.cgColor
        self.searchView.layer.borderWidth = 0.5
        self.siteNotReadyBtn.layer.borderWidth = 0.5
        self.siteNotReadyBtn.layer.borderColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0).cgColor
        self.submitBtn.layer.borderWidth = 0.5
        self.submitBtn.layer.borderColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0).cgColor
        
        self.navigationController? .setNavigationBarHidden(true, animated:true)
        
        self.navigationItem.rightBarButtonItem = nil
        self.questionsTable.estimatedRowHeight = 68.0
        self.questionsTable.rowHeight = UITableViewAutomaticDimension
        self.title = ""
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        //let customView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 50))
        //customView.backgroundColor = UIColor.clearColor()
        //self.questionsTable.tableFooterView = customView
        //  self.searchView.backgroundColor = UIColor(patternImage: UIImage(named: "tablebg")!)
        
        if self.appDel.taskDao != nil {
        if self.appDel.taskDao.permitDao != nil {
        self.permitBtn.isHidden = false
        self.companyDetailBtn.isHidden = true
            
        }
        else {
            self.permitBtn.isHidden = true
            self.companyDetailBtn.isHidden = false
            
        }
        }
        else {
            self.permitBtn.isHidden = true
            self.companyDetailBtn.isHidden = false

        }
        
        let date = Date()
        if self.appDel.fromHistoryToResult != 1 && self.appDel.inspectionByIndividual != 1 {
            let currentTime = Int64(date.timeIntervalSince1970 * 1000)
            let unique =  "\(self.appDel.taskDao!.task_id!),\(currentTime)"
            print("Unique 1 \(unique)")
            
            self.appDel.unique = unique
            self.appDel.currentTime = "\(currentTime)"
        }
        
        if self.appDel.selectedIndividual != nil {
            let currentTime = Int64(date.timeIntervalSince1970 * 1000)
            let unique =  "\(0),\(currentTime)"
            print("Unique 2 \(unique)")
            
            self.appDel.unique = unique
            self.appDel.currentTime = "\(currentTime)"
            
        }
        
        
        //        if self.appDel.list_id == nil && tasks.list_id != nil {
        //        self.appDel.list_id = tasks.list_id
        //        }
        //
        
        // self.timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "update", userInfo: nil, repeats: true)
        
        self.appDel.backfromCheckList = 1
        
        self.searchView.layer.cornerRadius = 2.0
        self.searchView.layer.masksToBounds = true
        
        
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
        
        if self.appDel.totalSpendSecond > 0 {
            
            self.navigationController? .setNavigationBarHidden(true, animated:true)
            let backButton = UIButton(type: UIButtonType.custom)
            backButton.addTarget(self, action: #selector(QuestionListViewController.goBack), for: UIControlEvents.touchUpInside)
            backButton.setTitle(localisation.localizedString(key: "questions.back"), for: UIControlState())
            // backButton.setImage(UIImage(named: "backicon"), forState: UIControlState.Normal)
            backButton.sizeToFit()
            let backButtonItem = UIBarButtonItem(customView: backButton)
            self.navigationItem.leftBarButtonItem = backButtonItem
        }
        
        self.siteNotReadyBtn.setTitle(localisation.localizedString(key: "questions.closetask"), for: UIControlState())
        self.selectAllBtn.setTitle(localisation.localizedString(key: "history.selectall"), for: UIControlState())
        self.timeSpentlbl.text = localisation.localizedString(key: "questions.timespent")
        self.submitBtn.setTitle(localisation.localizedString(key: "finalise.finalise"), for: UIControlState())
        self.companyDetailBtn.setTitle(localisation.localizedString(key: "questions.companydetail"), for: UIControlState())
        self.norecordsLbl.text = localisation.localizedString(key: "general.norecordsfound")
        self.searchField.placeholder = localisation.localizedString(key: "questions.searchbyviolationnameorcode")
        
        
        self.questionsTable.setContentOffset(CGPoint(x: -64, y: 0), animated:true)
        //self.questionsTabl.setC
        
        //self.appDel.fromHistoryToResult = 1
        
        //        questions.timespent
        //   self.title = self.appDel.taskDao.task_name
        self.allDropdowns = NSMutableDictionary()
        self.notes = NSMutableDictionary()
        // var strlat : NSString = NSString(format: "%.5f", self.appDel.user.lat)
        // var strlon : NSString = NSString(format: "%.5f", self.appDel.user.lon)
        // self.locationLabel.text = "Your current location lat : \(strlat) , lon: \(strlon)"
        self.audio = NSMutableDictionary()
        self.images = NSMutableDictionary()
        // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "reportbg")!)
        //self.view.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        
        //  self.questionsTable.backgroundColor = UIColor(patternImage: UIImage(named: "tablebg")!)
        self.questionsTable.backgroundColor = UIColor.clear
        
        
        self.allQuestion = NSMutableArray()
        self.allSelectedQuestions = NSMutableDictionary()
        if self.appDel.inspectionByIndividual == 1 {
        self.companyDetailBtn.isHidden = true
        self.siteNotReadyBtn.isHidden = true
            
        }
        
        self.appDel.notesDict = notes
        if self.appDel.taskDao != nil {
            if self.appDel.taskDao.inspection_type != nil && self.appDel.taskDao.waiting_for_audit != nil {
                if self.appDel.taskDao.inspection_type == "co-inspection" && self.appDel.taskDao.waiting_for_audit == "1" {
                    
                    self.siteNotReadyBtn.isHidden = true
                   // self.questionsTable.scrollToBottom(animated: true)
                } // end of the  co-inspection
                
            }
        }
        if self.appDel.isUnlicense == 1 {
            self.siteNotReadyBtn.isHidden = true
        }
        
        self.tasks = self.appDel.taskDao
        if self.appDel.fromHistoryToResult == 1 {
            self.companyDetailBtn.isHidden = true
            self.allQuestion = self.appDel.questions
            self.questionCategories = self.appDel.allQCategories
            self.questionStorageArray = self.appDel.questions
            self.selectAllView.isHidden = true
             if UIDevice.current.userInterfaceIdiom == .pad  {
            self.questionsTable.frame = CGRect(x: 4, y: 73, width: 760, height: 946)
            }
            self.questionsTable.reloadData()
            self.navigationItem.rightBarButtonItem = nil
            self.submitBtn.isHidden = true
            self.timeOuterView.isHidden = true
            self.questionsTable.translatesAutoresizingMaskIntoConstraints = true
            self.siteNotReadyBtn.isHidden = true
            self.appDel.showIndicator = 0
        }
        else {
            //  self.timeOuterView.hidden = false
            
            self.appDel.showIndicator = 1
            if Reachability.connectedToNetwork() {
            
               downloadQuestion()
              //  self.allQuestion = self.databaseManager.fetchQuestionListByQuestionListId(self.appDel.list_id!)
               // self.setupArrays()

            }
            else if self.appDel.inspectionByIndividual == 1 {
             self.allQuestion = self.databaseManager.fetchQuestionListByQuestionListId(self.appDel.list_id!)
                self.questionCategories = self.databaseManager.fetchAllCategoriesBasedonListid(list_id: self.appDel.list_id!)
                
                self.appDel.allQCategories =  self.questionCategories
             self.setupArrays()
            }
            else {
                if self.appDel.is_adhoc_inspection == 1 && self.appDel.list_id != nil {
                    self.allQuestion = self.databaseManager.fetchQuestionListByList_Id(self.appDel.list_id! , task_id: self.appDel.taskDao.task_id)
                    self.questionCategories = self.databaseManager.fetchAllCategoriesBasedonListid(list_id: self.appDel.list_id!)
                    self.appDel.allQCategories =  self.questionCategories
                    
                    
                } // end of the if
                    
                else if self.appDel.taskDao != nil {
                    if self.appDel.taskDao.is_pool == "0" {
                        if self.appDel.taskDao.task_id == "0" {
                         self.allQuestion = self.databaseManager.fetchQuestionListByQuestionListId(self.appDel.list_id!)
                            self.questionCategories = self.databaseManager.fetchAllCategoriesBasedonListid(list_id: self.appDel.list_id!)
                            self.appDel.allQCategories =  self.questionCategories
                        }
                        else {
                        self.allQuestion = self.databaseManager.fetchQuestionList(self.appDel.taskDao.task_id)
                            self.questionCategories = self.databaseManager.fetchAllCategoriesBasedonListid(list_id: self.appDel.list_id!)
                            self.appDel.allQCategories =  self.questionCategories
                        }
                        }
                    else if self.appDel.taskDao.is_pool == "1" {
                        self.allQuestion = self.databaseManager.fetchQuestionListByQuestionListId(self.appDel.list_id!)
                        self.questionCategories = self.databaseManager.fetchAllCategoriesBasedonListid(list_id: self.appDel.list_id!)
                        self.appDel.allQCategories =  self.questionCategories
                    }
                } // end of the else
                
                self.setupArrays()
            }
            self.questionStorageArray = self.allQuestion
        
        }
        
        if self.appDel.fromHistoryToResult == 0 && self.appDel.taskDao != nil {
            if self.appDel.taskDao.task_id != nil {
        if self.appDel.taskDao.task_id == "0" {
            
        //    self.siteNotReadyBtn.isHidden = true
            
            
        }
            }
        }
        
        let headerNib = UINib.init(nibName: "CategoryTableViewHeader", bundle: Bundle.main)
        questionsTable.register(headerNib, forHeaderFooterViewReuseIdentifier: "CategoryTableViewHeader")
        
    
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if questionCategories.count > 0 && self.isSearching == 0 {
        return 50
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone && self.questionCategories.count == 0 {
        return 20
        }
        else {
        return 0
        }
    }
    
    func setupArrays(){
        
        //  self.questionsTable.reloadData()
        
        
      //  for (var i1 = 0 ; i1 < self.allQuestion.count ; i1++) {
            
             for  i1 in 0 ..< self.allQuestion.count  {
            
            let q : QuestionDao = allQuestion.object(at: i1) as! QuestionDao
            //            println(q.question_desc)
            let oarray : NSMutableArray = q.allOptions
            
            for  i2 in 0 ..< oarray.count  {

//                for (var i2 = 0 ; i2 < oarray.count ; i2++) {

                let o : OptionDao = oarray.object(at: i2) as! OptionDao
                let extraOptions  = o.allExraOptions
                
                
                if o.option_type == "drop_down"{
                    self.allDropdowns.setObject(extraOptions, forKey: o.option_id as NSCopying)
                    
                }
                
                
                //for (var i3 = 0 ; i3 < extraOptions.count ; i3 += 1) {
                    for  i3 in 0 ..< extraOptions!.count {
                        
                    
                    
                    var eo : ExtraOption = extraOptions!.object(at: i3) as! ExtraOption
                    //                    println(eo.value)
                    //                    println(eo.extra_optionId)
                    
                    
                }
                
            }
            
        }
    }
    func downloadQuestion(){
        var loginUrl = ""
        let datadownloader:DataDownloader = DataDownloader()
        datadownloader.delegate = self
        self.appDel.showIndicator = 1
        print("Show Result \(self.appDel.show_result)")
        if self.appDel.show_result == 1 {
            if self.appDel.taskDao.parent_task_id == nil {
                self.appDel.taskDao.parent_task_id = "0"
            }
            //print(self.appDel.taskDao.parent_task_id)
            if  (self.appDel.taskDao.parent_task_id as! NSString).intValue > 1 {
                //loginUrl = Constants.baseURL + "getTaskQuestionList?list_id=" + tasks.list_id + "&task_id=" + tasks.task_id + "&user_id=" + self.appDel.user.user_id + "&parent_task_id=\(self.appDel.taskDao.parent_task_id!)"
                loginUrl = "\(Constants.baseURL)getTaskQuestionList?list_id=\(tasks.list_id!)&task_id=\(tasks.task_id!)&user_id=\(self.appDel.user.user_id!)&parent_task_id=\(self.appDel.taskDao.parent_task_id!)"
                
                print(loginUrl)
            }
            else {
                //loginUrl = Constants.baseURL + "getTaskQuestionList?list_id=" + tasks.list_id + "&task_id=" + tasks.task_id + "&show_result=1&user_id=" + self.appDel.user.user_id
                loginUrl = "\(Constants.baseURL)getTaskQuestionList?list_id=\(tasks.list_id!)&task_id=\(tasks.task_id!)&show_result=1&user_id=\(self.appDel.user.user_id!)"
                
                
                
            }
            datadownloader.startDownloader(loginUrl, idn: "question")
        }
        else if self.appDel.selectedIndividual == nil{
            //loginUrl = Constants.baseURL + "getTaskQuestionList?list_id=" + tasks.list_id + "&task_id=" + tasks.task_id+"&user_id=" + self.appDel.user.user_id
            loginUrl = "\(Constants.baseURL)getTaskQuestionList?list_id=\(tasks.list_id!)&task_id=\(tasks.task_id!)&user_id=\(self.appDel.user.user_id!)"
            
            print(loginUrl)
            datadownloader.startDownloader(loginUrl, idn: "question")
            
        }
        else {
            loginUrl = Constants.baseURL + "getQuestionListByListID?listID=" + self.appDel.selectedIndividual!.list_id!
            print(loginUrl)
            datadownloader.startDownloader(loginUrl, idn: "question")

        }
    }
    
    func nodataFound(){
        let alert : UIAlertController = UIAlertController(title: "Alert", message: "List is not available , contact admin", preferredStyle: UIAlertControllerStyle.alert)
        let action1 : UIAlertAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.cancel, handler:{ Void in
           
            self.navigationController?.popViewController(animated: true)
            self.navigationController? .setNavigationBarHidden(true, animated:true)
        })
        alert.addAction(action1)
        self.present(alert, animated: true, completion: nil)
        
    }
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "notready" {
           // self.dontSet = 1
            
           // self.navigationController?.popToRootViewControllerAnimated(true)
            
            return
        }
        if identity == "audio"{
            //             print(data)
            //         let str = NSString(data: data, encoding: NSUTF8StringEncoding)
            //          print("str from audio \(str)")
            //          do {
            //              // var path = NSBundle.mainBundle().pathForResource("ding", ofType: "mp3")
            //              try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            //          } catch _ {
            //          }
            //          do {
            //              try AVAudioSession.sharedInstance().setActive(true)
            //          } catch _ {
            //          }
            //
            //            var error:NSError?
            //            do {
            //                self.onlyAudioPlayer = try AVAudioPlayer(data: data)
            //            } catch let error1 as NSError {
            //                error = error1
            //                self.onlyAudioPlayer = nil
            //            }
            //
            //         //   var audioPlayer = AVAudioPlayer(data: data, error: &error)
            //            print("error :\(error)")
            //            if  self.onlyAudioPlayer != nil {
            //
            //             self.onlyAudioPlayer.prepareToPlay()
            //             self.onlyAudioPlayer.play()
            //            }
            //            else {
            //            print("Player is nil")
            //            }
            
            var error:NSError?
            
            do{
                self.onlyAudioPlayer = try  AVAudioPlayer(data: data as Data)
                self.onlyAudioPlayer.delegate = self
                self.onlyAudioPlayer.play()
                if self.currentBtn != nil {
                    self.currentBtn.setImage(UIImage(named: "pause"), for: UIControlState())
                }// end of the current
                
            }catch let error1 as NSError {
                error = error1
                self.onlyAudioPlayer = nil
                print(error)
            }
            
            
            
            
            return
            
        }
        if identity ==  "image" {
            print("Image downloaded")
            let image = UIImage(data: data as Data)
            if image != nil {
                self.appDel.imageToShow = image
                
                var story : UIStoryboard?
                if UIDevice.current.userInterfaceIdiom == .pad {
                    story = UIStoryboard(name: "Main", bundle: nil)
                }
                else {
                    story = UIStoryboard(name: "Main_iPhone", bundle: nil)
                }

                
                let cnt = story?.instantiateViewController(withIdentifier: "cnt_showImage") as! ShowImageViewController
                //   let cnt : ViolationAssignedViewController = popoverVC.topViewController as! ViolationAssignedViewController
                //    cnt.delegate = self
                
                
                cnt.modalPresentationStyle = .formSheet
                let popoverController = cnt.popoverPresentationController
                
                //popoverController!.sourceView = self.questionsTable
                // popoverController!.barButtonItem = self.submitbtn
                // popoverController!.permittedArrowDirections = UIPopoverArrowDirection.Unknown
                present(cnt, animated: true, completion: nil)
                
                
                
            }
            else {
                print("image is null")
            }
            return
        }
        if identity == "question" {
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
                     print("str from audio \(str)")
            self.appDel.showIndicator = 0
            let parser : JsonParser = JsonParser()
            parser.show_results = self.appDel.show_result
            
            let array  = parser.parseQuestions(data)
            if array.0.count == 0 {
                self.nodataFound()
                return
                
            }
            self.allQuestion = array.0
            self.questionStorageArray = array.0
            
            if array.1.count > 0 {
            self.questionCategories = array.1
                
            }
            self.questionsTable.reloadData()
            
            if self.appDel.taskDao != nil {
                if self.appDel.taskDao.inspection_type != nil && self.appDel.taskDao.waiting_for_audit != nil {
                    if self.appDel.taskDao.inspection_type == "co-inspection" && self.appDel.taskDao.waiting_for_audit == "1" {
                        
                        self.siteNotReadyBtn.isHidden = true
                        self.questionsTable.scrollToBottom(animated: false)
                       let timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(scrollToTop), userInfo: nil, repeats: false)
                       // questionsTable.setContentOffset(CGPointZero, animated:false)
                        
                    } // end of the  co-inspection
                    
                }
            }

            
            /*
            print(array.count)
            for (var i1 = 0 ; i1 < array.count ; i1++) {
                let q : QuestionDao = array.objectAtIndex(i1) as! QuestionDao
                //            println(q.question_desc)
                let oarray : NSMutableArray = q.allOptions
                
                for (var i2 = 0 ; i2 < oarray.count ; i2++) {
                    let o : OptionDao = oarray.objectAtIndex(i2) as! OptionDao
                    //                println(o.option_label)
                    //                println(o.option_type)
                    //                println(o.option_description)
                    //                println(o.is_required)
                    let extraOptions  = o.allExraOptions
                    
                    
                    if o.option_type == "drop_down"{
                        self.allDropdowns.setObject(extraOptions, forKey: o.option_id)
                        
                    }
                    
             
                    for (var i3 = 0 ; i3 < extraOptions.count ; i3++) {
                        var eo : ExtraOption = extraOptions.objectAtIndex(i3) as! ExtraOption
                        //                    println(eo.value)
                        //                    println(eo.extra_optionId)
                        
                        
                    }
                    
                }
            }
 */
            
        }
        else {
            if identity == "updatequestions" {
            
            
            }
            else {
            let DataStr = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            print(DataStr)
            
            if (DataStr?.range(of: "success") != nil) {
                self.appDel.showIndicator = 0
                self.resultSubmitted = 1
                if self.secondsTimer != nil {
                    self.secondsTimer!.invalidate()
                }
                let alert : UIAlertController = UIAlertController(title: "Alert", message: "Report submitted successfully", preferredStyle: UIAlertControllerStyle.alert)
                let action1 : UIAlertAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.cancel, handler:{ Void in
                   
                    self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(action1)
                self.present(alert, animated: true, completion: nil)
                
            }
            }
            
            
        }
    }
    
    
    @objc func scrollToTop(){
     questionsTable.setContentOffset(CGPoint.zero, animated:false)
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func notesSaved(_ data : String ,  sender : ADButton)
    {
        print("saving \(data) \(sender.questionid)")
        
        if (self.appDel.show_result == 1 && self.allSelectedQuestions.object(forKey: sender.question.question_id) != nil && self.usersSelectedQuestions.object(forKey: sender.question.question_id) == nil) {
            return
        }
        
        
        if data.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            sender.setBackgroundImage(UIImage(named: "notesreport"), for: UIControlState())
       //     self.notes.setObject("", forKey:String( sender.questionid))
       //     self.appDel.notesDict = self.notes
        self.notes.removeObject(forKey: String(sender.questionid!))
        self.appDel.notesDict = self.notes
        }
        else {
            sender.setBackgroundImage(UIImage(named: "not_sel"), for: UIControlState())
            self.notes.setObject(data, forKey:String( sender.questionid!) as NSCopying)
            self.appDel.notesDict = self.notes
        }
        
        //    self.notes.setObject(data, forKey: String(ques)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func checkAllQuestionsAreAdded()-> Bool{
        
        //        for var item : Int = 0 ; item < self.allQuestion.count ; item++ {
        //            let obj : QuestionDao = self.allQuestion.objectAtIndex(item) as! QuestionDao
        //
        //            if self.allSelectedQuestions.objectForKey(String(obj.question_id)) == nil {
        //                print("quesiton not added with \(obj.question_id) \(obj.question_desc)")
        //            return false
        //            }
        //
        //        }
        if self.allSelectedQuestions.count < 1 {
            return false
        }
        
        return true
        
        
    }
    func submitreport(){
        //for var in
        //        if self.violations.count > 0 {
        print(self.allSelectedQuestions)
        print("Select All \(self.selectAll)")
        if self.selectAll == 1 {
            self.setupAllQuestionSelected()
        }

        
        self.appDel.selectedViolation = self.violations
        self.appDel.calculatedWarnings = self.calulatedWarnings
        
        //        //println(self.appDel.selectedViolation.count)
        //          //  self.performSegueWithIdentifier("sw_showresult", sender: nil)
        //
        //            let cnt = storyboard?.instantiateViewControllerWithIdentifier("cnt_violation") as! ViolationAssignedViewController
        //         //   let cnt : ViolationAssignedViewController = popoverVC.topViewController as! ViolationAssignedViewController
        //               cnt.delegate = self
        //
        //
        //            cnt.modalPresentationStyle = .Popover
        //            let popoverController = cnt.popoverPresentationController
        //
        //            popoverController!.sourceView = self.submitBtn
        //           // popoverController!.barButtonItem = self.submitbtn
        //            popoverController!.permittedArrowDirections = UIPopoverArrowDirection.Down
        //            presentViewController(cnt, animated: true, completion: nil)
        //
        //
        //        return
        //
        //        }
        //
        let allkeys = self.allSelectedQuestions.allKeys
        for i in 0  ..< allkeys.count {
            if let q = usersSelectedQuestions.object(forKey: allkeys[i]) as? ADButton {
                if q.buttonnumber == 2 {
                    //print("Question id \(q.question.question_id)")
                   // print("Value selected \(q.valueSelect)")
                   // print(self.appDel.notesDict)
                   // print(q.questionid)
//                    if self.appDel.notesDict.object(forKey: q.question.question_id) == nil {
//                        let alert = UIAlertController(title: "Missing Notes", message: "Please Enter notes for all Violations", preferredStyle: .alert)
//                             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil))
//
//                             self.present(alert, animated: true, completion: nil)
//                    return
//                    }
               
                }
            }
        }
        for i in 0  ..< allkeys.count  {
            if let q = usersSelectedQuestions.object(forKey: allkeys[i]) as? ADButton {
                print(q.valueSelect)
                print(q.buttonnumber)
                if q.question.violation_code == "8501" && self.amount8501 == nil && q.buttonnumber == 2   {
               let alert = UIAlertController(title: "Missing Amount", message: "Enter Amount for Violation 8501", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil))
                    
                    self.present(alert, animated: true, completion: nil)
                return
                }
                
                
                if q.question.violation_code == "8502" && self.amount8502 == nil && q.buttonnumber == 2 {
                    let alert = UIAlertController(title: "Missing Amount", message: "Enter Amount for Violation 8502", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                }

                
                
                if self.amount8501 != nil {
                    if Int(self.amount8501!) != nil {
                        
                                if Int(self.amount8501!)! <= 0 || Int(self.amount8501!.replacingOccurrences(of: " ", with: "")) == nil{
                        let alert = UIAlertController(title: "Missing Amount", message: "Enter Amount for Violation 8501", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        return
                    }
                    
                    else {
                    print("Integer amount for 8501 \(Int(self.amount8501!))")
                    }
                    }
                    else {
                        let alert = UIAlertController(title: "Missing Amount", message: "Enter Amount for Violation 8501", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        return
                    }
                }
                
                if self.amount8502 != nil   {
                    if Int(self.amount8502!) != nil {
                        if Int(self.amount8502!)! <= 0 || Int(self.amount8502!.replacingOccurrences(of: " ", with: ""))  == nil{
                    let alert = UIAlertController(title: "Missing Amount", message: "Enter Amount for Violation 8502", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    return

                    }
                }
                    else {
                        let alert = UIAlertController(title: "Missing Amount", message: "Enter Amount for Violation 8502", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
                
            }
        }
        
        let array : NSMutableArray = NSMutableArray()
        print(self.allSelectedQuestions)
        if self.checkAllQuestionsAreAdded(){
            
            var allkeys = self.allSelectedQuestions.allKeys
            print(notes)
            for i in 0  ..< allkeys.count  {
             let dict = NSMutableDictionary()
                dict.setObject(allkeys[i], forKey: "question_id" as NSCopying)
                dict.setObject(self.allSelectedQuestions.object(forKey: allkeys[i])!, forKey: "extra_option_id" as NSCopying)
                let q_id : String = allkeys[i] as! String;
                
                if self.notes.object(forKey: q_id) != nil {
                    dict.setObject(self.notes.object(forKey: q_id)!, forKey: "notes" as NSCopying)
                }
                else {
                    dict.setObject("", forKey: "notes" as NSCopying)
                }
                
                print("User selected dict \(usersSelectedQuestions)")
                if let q = usersSelectedQuestions.object(forKey: allkeys[i]) as? ADButton {
                    if q.question.violation_code == "8501" && self.amount8501 != nil {
                        //dict.setObject(self.amount8501!, forKey: "td_amount")
                        dict.setObject(Util.getEnglishNo(self.amount8501!), forKey: "td_amount" as NSCopying)

                        
                    }
                    if q.question.violation_code == "8502" && self.amount8502 != nil {
                       // dict.setObject(self.amount8502!, forKey: "td_amount")
                    dict.setObject(Util.getEnglishNo(self.amount8502!), forKey: "td_amount" as NSCopying)
                    
                    }
                }

                
                var mediaStr : String  = ""
                
                
                
                    if let array = self.allImagesBank.object(forKey: allkeys[i]) as? NSMutableArray {
                        // print("Question \(q.question.question_id ) has \(array.count)")
                 //print("There are all images \(q.question.allImages)")
                    for imgcnt in 0  ..< array.count  {
                   if let img1 = array.object(at: imgcnt) as? ImageDao {
                       // print("Image loop \(img1.media_id)")
                    if mediaStr == "" {
                    mediaStr = "\(img1.media_id!)"
                    }
                    else {
                        mediaStr = "\(mediaStr),\(img1.media_id!)"
                    }
                    
                    }
                    }
                    }
                    else {
                    print("No Image Found")
                    
                    
                    }
                    
                
//                
//                if self.allImage.objectForKey(q_id) != nil {
//                    mediaStr = "\(self.allImage.objectForKey(q_id)!)"
//                    //dict.setObject(self.allImage.objectForKey(q_id)!, forKey: "media")
//                }
                
                if self.allVideos.object(forKey: q_id) != nil {
                    if self.allVideos.object(forKey: q_id) != nil {
                        mediaStr = "\(mediaStr),\(self.allVideos.object(forKey: q_id)!)"
                    }
                    else {
                        mediaStr = "\(self.allVideos.object(forKey: q_id)!)"
                    }
                    
                }
                if self.allDates.object(forKey: q_id) != nil {
                    let strdate: String = self.allDates.object(forKey: q_id) as! String
                    dict.setObject(strdate, forKey: "date" as NSCopying)
                    
                }
                else {
                    dict.setObject("", forKey: "date" as NSCopying)
                    
                }
                dict.setObject(mediaStr, forKey: "media" as NSCopying)
                
                
                array.add(dict)
                
                
            }
            
            print(array)
            
            //let data = NSJSONSerialization.dataWithJSONObject(array, options: nil, error: nil)
            //let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
            // println(string)
            var messageStr = ""
            if Reachability.connectedToNetwork() {
                // messageStr = "Do you want to submit inspection?"
                let downloader  = DataDownloader()
                downloader.delegate = self
                self.appDel.showIndicator = 1
                // println(array)
                //  downloader.startSendingPost(array, url:NSURL(string: Constants.saveServay)!, ide: "submit", duration : self.timerSecond)
                self.appDel.allAnsweredArray = array
                self.appDel.tasks_duration = self.appDel.totalSpendSecond
                processTask = 1
                
                
                //self.performSegueWithIdentifier("sw_showcompletion", sender: nil)
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                let story = UIStoryboard(name: "Main", bundle: nil)
                
                let vc = story.instantiateViewController(withIdentifier: "cnt_submit") as! FinishReportViewController
                
                vc.finishDel = self
                vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
                self.present(vc, animated: true, completion: nil)
                }
                else {
                    let story = UIStoryboard(name: "Main_iPhone", bundle: nil)
                    
                    let vc = story.instantiateViewController(withIdentifier: "cnt_submit") as! FinishReportViewController
                    
                    vc.finishDel = self
                    vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
                    self.present(vc, animated: true, completion: nil)
                    
                }
                
                
                
                //                popoverContent.providesPresentationContextTransitionStyle = true;
                //                popoverContent.definesPrese_ntationContext = true;
                //
                //             popoverContent.modalPresentationStyle = UIModalPresentationStyle.Custom;
                
                
                //          self.presentViewController(popoverContent, animated: true, completion: nil)
                
                
                return
                
                
            }
            else {
                messageStr = "Do you want to save inspection? , It will be sync automatically once internet is available"
            }
            
            if Reachability.connectedToNetwork() {
                
            }
            else
            {
                
                
                //                let downloader  = DataDownloader()
                //                let urlData = downloader.offlineGetrequestPost(array, url:NSURL(string: Constants.saveServay)!, ide: "submit")
                //
                //                self.userDefault.setObject(urlData, forKey: self.appDel.taskDao.task_id)
                //                var  allTasks = self.userDefault.objectForKey("tasks") as? String
                //                if allTasks == nil {
                //                    self.userDefault.setObject(self.appDel.taskDao.task_id, forKey: "tasks")
                //                }
                //                else {
                //                    allTasks = "\(allTasks!),\(self.appDel.taskDao.task_id)"
                //                    self.userDefault.setObject(allTasks, forKey: "tasks")
                //                    self.userDefault.synchronize()
                //                }
                //                self.userDefault.synchronize()
                //
                //                self.databaseManager.changeStatus(self.appDel.taskDao.task_id)
                //                //self.navigationController?.popViewControllerAnimated(true)
                //
                self.appDel.allAnsweredArray = array
                self.appDel.tasks_duration = self.appDel.totalSpendSecond
                let story : UIStoryboard?
                if UIDevice.current.userInterfaceIdiom == .pad {
                 story = UIStoryboard(name: "Main", bundle: nil)
                }
                else {
                    story = UIStoryboard(name: "Main_iPhone", bundle: nil)
                    
                }
                let vc = story!.instantiateViewController(withIdentifier: "cnt_submit") as! FinishReportViewController
                vc.finishDel = self
                vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
                self.present(vc, animated: true, completion: nil)
                
                
                
                //self.performSegueWithIdentifier("sw_showcompletion", sender: nil)
                
                
            }
            
            //            let alert : UIAlertController = UIAlertController(title: "Alert", message: messageStr, preferredStyle: UIAlertControllerStyle.Alert)
            //            let action1 : UIAlertAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {
            //           
            //                if Reachability.connectedToNetwork() {
            //                let downloader  = DataDownloader()
            //                downloader.delegate = self
            //                self.appDel.showIndicator = 1
            //               // println(array)
            //                  //  downloader.startSendingPost(array, url:NSURL(string: Constants.saveServay)!, ide: "submit", duration : self.timerSecond)
            //                    self.appDel.allAnsweredArray = array
            //                    self.appDel.tasks_duration = self.timerSecond
            //                    self.performSegueWithIdentifier("sw_showcompletion", sender: nil)
            //
            //
            //                }
            //                else {
            //
            //
            //
            //
            //                    let downloader  = DataDownloader()
            //                   let urlData = downloader.offlineGetrequestPost(array, url:NSURL(string: Constants.saveServay)!, ide: "submit")
            //
            //                    self.userDefault.setObject(urlData, forKey: self.appDel.taskDao.task_id)
            //                    var  allTasks = self.userDefault.objectForKey("tasks") as? String
            //                    if allTasks == nil {
            //                        self.userDefault.setObject(self.appDel.taskDao.task_id, forKey: "tasks")
            //                    }
            //                    else {
            //                        allTasks = "\(allTasks!),\(self.appDel.taskDao.task_id)"
            //                        self.userDefault.setObject(allTasks, forKey: "tasks")
            //                        self.userDefault.synchronize()
            //                    }
            //                    self.userDefault.synchronize()
            //
            //                    self.databaseManager.changeStatus(self.appDel.taskDao.task_id)
            //                   //self.navigationController?.popViewControllerAnimated(true)
            //                    self.performSegueWithIdentifier("sw_showcompletion", sender: nil)
            //
            //
            //                }
            //
            //            })
            //            alert.addAction(action1)
            //            let action2 : UIAlertAction = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.Cancel, handler:nil)
            //            alert.addAction(action2)
            //            self.presentViewController(alert, animated: true, completion: nil)
            
            
            
            
            //            if Reachability.connectedToNetwork(){}
            //            else{
            //                let alert : UIAlertController = UIAlertController(title: localisation.localizedString(key: "searchcompany.pleasecheckinternetconnection"), message: "", preferredStyle: UIAlertControllerStyle.Alert)
            //                let action1 : UIAlertAction = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.Cancel, handler: nil)
            //                alert.addAction(action1)
            //                self.presentViewController(alert, animated: true, completion: nil)
            //                return
            //                //self.presentViewController(alert, animated: true, completion: nil)
            //            }
            //
        }
            
            
        else {
            let alert : UIAlertController = UIAlertController(title: localisation.localizedString(key: "questions.cantsubmit"), message:localisation.localizedString(key: "question.Must select atleast one checklist item . You can choose to ‘Close’ task if you can not perform the inspection"), preferredStyle: UIAlertControllerStyle.alert)
            let action1 : UIAlertAction = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action1)
            self.present(alert, animated: true, completion: nil)
            // Show Alert
            
        }
        
        
        
        
    }
    
    func dateDeletced(_ date : Date , button : ADButton){
        print("Date selected \(date)")
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let str : String = formatter.string(from: date)
        print(str)
        self.allDates.setObject(str, forKey: String(button.question.question_id) as NSCopying)
        
        //  self.violations.setObject(button.option, forKey: button.question.question_id)
        self.allSelectedQuestions.setObject(button.option.option_id, forKey:String(button.question.question_id) as NSCopying)
        button.radioCell.questionTitle.text = button.question.question_desc + "(Date : \(str))"
        button.radioCell.questionTitle.textColor = UIColor(red: 52/255, green: 40/255, blue: 44/255, alpha: 1.0)
        if button.option.violation_code != "" &&  button.option.violation_code != nil
        {
            self.violations.setObject(button.option, forKey: button.question.question_id as NSCopying)
        }
        else {
            self.violations.removeObject(forKey: button.question.question_id)
        }
        let selected = SelectedCellData()
        selected.optionSelected = button.buttonnumber
        selected.questionStatus = 1
        selected.questiontitle = button.question.question_desc + "(Date : \(str))"
        self.selectedQuestionBank.setObject(selected, forKey: button.question.question_id as NSCopying)
        
        
    }
    
    func createMultipart(_ filename : String , q : QuestionDao , imageData : Data! , type : String){
        // use SwiftyJSON to convert a dictionary to JSON
        
        // let myUrl = NSURL(string: "http://einspection.net/api/saveMedia");
        let myUrl = URL(string: Constants.kUploadMedia);
        
        if imageData != nil{
            var request = URLRequest(url: myUrl!)
            
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
            print(request.url)
            
            var task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                //println("Response: \(response)")
             
                DispatchQueue.main.async {
                PKHUD.sharedHUD.hide(animated: true)
                
                ANLoader.hide()
                }
                if error != nil
                {
                    print(error?.localizedDescription)
                }
                else
                {
                    //Converting data to String
                    let responseStr:NSString = NSString(data:data!, encoding:String.Encoding.utf8.rawValue)!
                    print("Returning url \(responseStr)")
                    let parser =  JsonParser()
                    let str = parser.parseMedia(data!)
                    if str != "error"{
                        if type == "audio" {
                            self.allVideos.setValue(str, forKey: q.question_id)
                            
                        }
                        else {
                            
                            let dao = ImageDao()
                            dao.image_id = "\(q.allImages.count + 1)"
                            dao.q_id = q.question_id
                            print("settings up image for \(dao.q_id) and image \(str)")
                            dao.image = UIImage(data: imageData!)
                            dao.media_id = str
                            q.allImages.add(dao)
                            self.allImagesBank.setObject(q.allImages, forKey: q.question_id as NSCopying)
                            
                            
                            DispatchQueue.main.async(execute: {
                            self.currentBtn.radioCell.reddot.isHidden = false
                            self.currentBtn.radioCell.nolbl.text =  "\(q.allImages.count)"
                            self.currentBtn.radioCell.nolbl.isHidden = false
                                
                            //self.allImage.setValue(str, forKey: q.question_id)
                            })
                            
                        }
                    }
                }
                
                
                
            })
            
            task.resume()
            
            
//            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler:{(response:URLResponse?, responseData:Data?, error: NSError?)  in
//                PKHUD.sharedHUD.hide(animated: true)
//
//                if error != nil
//                {
//                    print(error!.description)
//                }
//                else
//                {
//                    //Converting data to String
//                    let responseStr:NSString = NSString(data:responseData!, encoding:String.Encoding.utf8.rawValue)!
//                    print("Returning url \(responseStr)")
//                    let parser =  JsonParser()
//                    let str = parser.parseMedia(responseData!)
//                    if str != "error"{
//                        if type == "audio" {
//                            self.allVideos.setValue(str, forKey: q.question_id)
//
//                        }
//                        else {
//
//                            let dao = ImageDao()
//                            dao.image_id = "\(q.allImages.count + 1)"
//                            dao.q_id = q.question_id
//                                print("settings up image for \(dao.q_id) and image \(str)")
//                            dao.image = UIImage(data: imageData!)
//                            dao.media_id = str
//                            q.allImages.add(dao)
//                            self.allImagesBank.setObject(q.allImages, forKey: q.question_id as NSCopying)
//
//
//
//                            self.currentBtn.radioCell.reddot.isHidden = false
//                            self.currentBtn.radioCell.nolbl.text =  "\(q.allImages.count)"
//                            self.currentBtn.radioCell.nolbl.isHidden = false
//                            //self.allImage.setValue(str, forKey: q.question_id)
//
//                        }
//                    }
//                }
//            } as! (URLResponse?, Data?, Error?) -> Void)
//
//
            
            //  var returnData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
            
            // var returnString = NSString(data: returnData!, encoding: NSUTF8StringEncoding)
            
            // println("returnString \(returnString)")
            
            self.questionsTable.reloadData()
        }
        else {
            print("data is null")
        }
        
    }
    func readyToSubmit() {
        
        let array : NSMutableArray = NSMutableArray()
                if self.checkAllQuestionsAreAdded(){
            
            var allkeys = self.allSelectedQuestions.allKeys
            print(notes)
            for i in 0  ..< allkeys.count  {
                let dict = NSMutableDictionary()
                dict.setObject(allkeys[i], forKey: "question_id" as NSCopying)
                if let q = usersSelectedQuestions.object(forKey: allkeys[i]) as? QuestionDao {
                    if q.violation_code == "8501" && self.amount8501 != nil {
                    dict.setObject(Util.getEnglishNo(self.amount8501!), forKey: "td_amount" as NSCopying)
                      //  dict.setObject(self.amount8501!, forKey: "td_amount")
   
                    }
                    if q.violation_code == "8502" && self.amount8502 != nil {
                   dict.setObject(Util.getEnglishNo(self.amount8502!), forKey: "td_amount" as NSCopying)
                   //  dict.setObject(self.amount8502!, forKey: "td_amount")
                    }
                }
                
                dict.setObject(self.allSelectedQuestions.object(forKey: allkeys[i])!, forKey: "extra_option_id" as NSCopying)
                let q_id : String = allkeys[i] as! String;
                
                if self.notes.object(forKey: q_id) != nil {
                    dict.setObject(self.notes.object(forKey: q_id)!, forKey: "notes" as NSCopying)
                }
                else {
                    dict.setObject("", forKey: "notes" as NSCopying)
                }
                var mediaStr : String  = ""
                
                if self.allImage.object(forKey: q_id) != nil {
                    mediaStr = "\(self.allImage.object(forKey: q_id)!)"
                    //dict.setObject(self.allImage.objectForKey(q_id)!, forKey: "media")
                }
                
                
                
                if self.allVideos.object(forKey: q_id) != nil {
                    if self.allImage.object(forKey: q_id) != nil {
                        mediaStr = "\(mediaStr),\(self.allVideos.object(forKey: q_id)!)"
                    }
                    else {
                        mediaStr = "\(self.allVideos.object(forKey: q_id)!)"
                    }
                    
                }
                if self.allDates.object(forKey: q_id) != nil {
                    let strdate: String = self.allDates.object(forKey: q_id) as! String
                    dict.setObject(strdate, forKey: "date" as NSCopying)
                    
                }
                else {
                    dict.setObject("", forKey: "date" as NSCopying)
                    
                }
                dict.setObject(mediaStr, forKey: "media" as NSCopying)
                
                
                array.add(dict)
            }
            
            //let data = NSJSONSerialization.dataWithJSONObject(array, options: nil, error: nil)
            //let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
            // println(string)
            //            let alert : UIAlertController = UIAlertController(title: "Alert", message: "Do you want to submit inspection?", preferredStyle: UIAlertControllerStyle.Alert)
            //            let action1 : UIAlertAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {
            //               
            if Reachability.connectedToNetwork() {
                self.appDel.showIndicator = 1
                let downloader  = DataDownloader()
                downloader.delegate = self
                // println(array)
                
                downloader.startSendingPost(array, url:URL(string: Constants.saveServay)!, ide: "submit" , duration : self.timerSecond)
                
            }
            else {
                self.userDefault.set(array, forKey: self.appDel.taskDao.task_id)
                var  allTasks = self.userDefault.object(forKey: "tasks") as? String
                if allTasks == nil {
                    userDefault.set(self.appDel.taskDao.task_id, forKey: "tasks")
                }
                else {
                    allTasks = "\(allTasks) , \(self.appDel.taskDao.task_id)"
                    userDefault.set(allTasks, forKey: "tasks")
                    userDefault.synchronize()
                }
                self.userDefault.synchronize()
            }
            //
            //            })
            //            alert.addAction(action1)
            //            let action2 : UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil)
            //            alert.addAction(action2)
            //            
            //            
            //            
            //            
            //            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
            
            
        else {
            let alert : UIAlertController = UIAlertController(title: "Alert", message: "Please fill all questions", preferredStyle: UIAlertControllerStyle.alert)
            let action1 : UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action1)
            self.present(alert, animated: true, completion: nil)
            // Show Alert
            
        }
        
        
    }
    
    //MARK:- TEXTFIELD DELEGATE METHODS
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == searchField {
        self.searchedArry = NSMutableArray()
        self.isSearching = 0
        textField.resignFirstResponder()
        self.questionsTable.reloadData()
        }
        return true
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if textField == self.searchField {
        self.searchedArry = NSMutableArray()
        if textField.text! == "" {
            self.isSearching = 0
            self.questionsTable.reloadData()
            return true
            
        }
        
        for  question in self.allQuestion   {
            if let q = question as? QuestionDao {
            print(q.question_desc)
            print(self.searchField.text! )
            
                if ((q.question_desc as! NSString).contains(self.searchField.text!)) || ((q.question_desc_en as! NSString).contains(self.searchField.text!))  {
                self.searchedArry.add(question)
            }
            }
            }
        self.isSearching = 1
        
        self.questionsTable.reloadData()
        
        }
        
        
        
        return true
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("End Editting \(textField.text)")
        if textField == searchField {
        if textField.text! == "" {
            self.isSearching = 0
            self.questionsTable.reloadData()
            //  return true
            
        }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == searchField {
        self.searchedArry = NSMutableArray()
        
        for  question in self.allQuestion   {
            if let q = question as? QuestionDao {
                print(q.question_desc)
                print(self.searchField.text! + string)
                print(string)
                print(q.violation_code)
                if q.violation_code != nil {
                    if (q.question_desc as! NSString).contains(self.searchField.text! + string) || (q.violation_code  as! NSString).contains(self.searchField.text! + string) || (q.question_desc_en as! NSString).lowercased.contains(self.searchField.text!.lowercased() + string.lowercased())  {
                        self.searchedArry.add(question)
                        
                    }
                }
                else if (q.question_desc as! NSString).contains(self.searchField.text! + string) || (q.question_desc_en as! NSString).lowercased.contains(self.searchField.text!.lowercased() + string.lowercased()){
                    self.searchedArry.add(question)
                }
            }
            if self.searchedArry.count == 0 {
                self.norecordsLbl.isHidden = false
                
            }
            else {
                self.norecordsLbl.isHidden = true
                
            }
            self.isSearching = 1
            self.expandedIndex = -1
            self.questionsTable.reloadData()
            
            
        }
        }
        else {
            if textField.isKind(of: MarginTextField.self) {
            print("Yes its margin textfield")
                if let marginText = textField as? MarginTextField {
                    if (marginText.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) == "" && marginText.text! == "0" {
                    return true
                    }
                    
                    if Int(marginText.text!) == 0 {
                    return true
                    }
                    
                    
                    if marginText.activity_code != nil {
                        if marginText.activity_code ==  "8501" {
                            if string == "" {
                                self.amount8501 = nil
                                
                            }
                            else {
                            self.amount8501 = marginText.text! + string
                            }
                            print("shouldChangeCharactersInRange 8501 AMOUNT \(self.amount8501) str \(string) textfield \(textField.text)")
                        }
                        if marginText.activity_code == "8502" {
                            
                            if string == "" {
                            self.amount8502 = nil
                            
                            }
                            else {
                            self.amount8502 = marginText.text! + string
                                print("8502 AMOUNT \(self.amount8502)")
                            }
                            
                        } // end of the 8502
                    } // end of the if
                   // print(marginText.text! + string )
                }
                
            }
        
        }
        return true
        
    }
    func imageAdded(_ images: NSMutableArray) {
        self.currentBtn.question.allImages = images
        self.allImagesBank.setObject(images, forKey: currentBtn.question.question_id as NSCopying)
        
       
        if let qq = self.usersSelectedQuestions.object(forKey: self.currentBtn.question.question_id)  as? ADButton{
        qq.question.allImages = images
       // print("Added for \(qq.question.question_id)")
        }
        
        if images.count <= 0 {
            
        
        self.currentBtn!.radioCell.reddot.isHidden = true
            self.currentBtn!.radioCell.nolbl.isHidden = true
        }
        else {
        self.currentBtn!.radioCell.nolbl.isHidden = false
            
        self.currentBtn!.radioCell.nolbl.text = "\(images.count)"
        }
    }
    func taskSaved(_ response: NSString) {
        //if response.containsString("success"){
        //  self.navigationController?.popToViewController((self.navigationController?.viewControllers[2])!,animated: true)
        //if self.appDel.is_adhoc_inspection == 1 {
        if self.appDel.taskDao != nil {
        self.databaseManager.changeStatus(self.appDel.taskDao.task_id)
        }
        self.navigationController?.popToRootViewController(animated: true)
        //}
    }
    
    
}

public extension UIScrollView {
    
    public func scrollToBottom(animated: Bool) {
        let rect = CGRect(x: 0, y: contentSize.height - bounds.size.height, width: bounds.size.width, height: bounds.size.height)
        scrollRectToVisible(rect, animated: animated)
    }
    
}

