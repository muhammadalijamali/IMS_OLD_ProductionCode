//
//  MakaniViewController.swift
//  ADTourism
//
//  Created by MACBOOK on 10/30/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit
@objc protocol MakaniDelegate{
    @objc optional func makaniCodeDetected(_ code: String)
}

class MakaniViewController: UIViewController,UITableViewDataSource,UITableViewDelegate , QRCodeDelegate , MainJsonDelegate {
   var del = UIApplication.shared.delegate as! AppDelegate
    var makaniArray : NSMutableArray = NSMutableArray()
    var fromTask : Int = 0 // 0 means not from task listing 1 means from task listing
    var appdel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var localisation : Localisation!
    var deleteIndexPath : IndexPath?
    

    @IBOutlet weak var makaniTable: UITableView!
    var makaniDel : MakaniDelegate?
    
    @IBAction func saveMakani(_ sender: UIButton) {
        if self.makaniTextfield.text == "" {
            self.del.selectedMakani = nil
            self.dismiss(animated: true, completion: nil)
        return
        }
        if fromTask == 1 {
        self.del.selectedMakani = self.makaniTextfield.text
        self.dismiss(animated: true, completion: nil)
        }
        else if fromTask == 0 {
        setupAddMakani()
        
        }
    }
    @objc func openMakaniMap(_ sender : MakaniBtn){
        if Reachability.isConnectedNetwork() {
            let makanistr = Constants.baseURL + "getMakaniDetailByNumber?makani_no=" + sender.makani!
            print(makanistr)
             self.appdel.showIndicator = 1
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(makanistr, idn: "openMakani")
        }

    }
    
    @IBOutlet weak var makaniTextfield: UITextField!
    @IBAction func exit(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
    }
//    override func viewWillAppear(animated: Bool) {
//        self.preferredContentSize =  CGSizeMake(300, 105)
//
//    }
//    
    
    func setupAddMakani(){
        
        for a in 00 ..< self.appdel.taskDao.company.makani.count {
            let makaniDao = self.appdel.taskDao.company.makani.object(at: a) as! MakaniDao
            
            if makaniDao.makani!.replacingOccurrences(of: " ", with: "") == makaniTextfield.text!.replacingOccurrences(of: " ", with: "") {
                self.dismiss(animated: true, completion: nil)
            return
            }
            
            }
        
        
        if Reachability.isConnectedNetwork() {
        let makanistr = Constants.baseURL + "saveMakani?companyID=" + self.appdel.taskDao.company.company_id! + "&makani_no=\(self.makaniTextfield.text!)"
            
        self.appdel.showIndicator = 1
        print(makanistr)
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(makanistr, idn: "saveMakani")
        }
        else {
            let alert = UIAlertController(title: "", message: localisation.localizedString(key: "general.checkinternet"), preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        
        }
    }
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "saveMakani" {
        self.dismiss(animated: true, completion: nil)
        }
        else if identity == "openMakani" {
            let Str = String(data: data as Data, encoding: String.Encoding.utf8)
            print(Str)
              let parser = JsonParser()
           //   print(parser.parseMakaniData(data))
         let result = parser.parseMakaniData(data)
            if result != "error" {
            let resultArray = result?.components(separatedBy: ",")
                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                    UIApplication.shared.openURL(URL(string:
                        "comgooglemaps://?saddr=\(self.appdel.user.lat!),\(self.appdel.user.lon!)&daddr=\(resultArray![0]),\(resultArray![1])")!)
                    //  self.openMapForPlace()
                } else {
                    NSLog("Can't use Google Maps");
                    let urlstr : String = "https://maps.google.com/maps?saddr=\(self.appdel.user.lat!),\(self.appdel.user.lon!)&daddr=\(resultArray![0]),\(resultArray![1])"
                    UIApplication.shared.openURL(URL(string: urlstr)!)
                    
                }
                
   
            }
        }
        else if identity == "deleteMakani" {
            if self.deleteIndexPath != nil {
            //self.makaniTable.beginUpdates()
          //  self.makaniTable.deleteRowsAtIndexPaths([self.deleteIndexPath!], withRowAnimation: .Automatic)
            self.appdel.taskDao.company.makani.removeObject(at: self.deleteIndexPath!.row)
              self.makaniTable.reloadData()
           // self.makaniTable.endUpdates()
            }
        
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        self.deleteIndexPath = indexPath
        let makani = self.appdel.taskDao.company.makani.object(at: indexPath.row) as! MakaniDao
            if makani.makani != nil {
        self.setupDeleteMakani(makani.makani!)
            }
        }
    }
    
    func setupDeleteMakani(_ makani : String){
        if Reachability.isConnectedNetwork() {
        let makanistr = Constants.baseURL + "deleteMakani?companyID=" + self.appdel.taskDao.company.company_id! + "&makani_no=\(makani)"
        
        self.appdel.showIndicator = 1
        print(makanistr)
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(makanistr, idn: "deleteMakani")
        }
    }
    
    @IBAction func scanTheQRCode(_ sender: UIButton) {
        let cnt = storyboard?.instantiateViewController(withIdentifier: "cnt_sqcodescan") as! QRCodeViewController
        cnt.del = self
        self.present(cnt, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.makaniTable.editing = true
       
        if del.selectedMakani != nil {
            if del.selectedMakani != "" {
        self.makaniTextfield.text = self.del.selectedMakani!
        }
        }
        
        self.localisation = Localisation()
        
        
        if self.appdel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
            
            //  self.userTextField.textAlignment = NSTextAlignment.Right
            // self.passwordField.textAlignment = NSTextAlignment.Right
            
            
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            
            
        }
        

        
        
/*
        makaniArray.addObject("121212 1333113")
        makaniArray.addObject("121212 1333113")
        makaniArray.addObject("121212 1333113")
        makaniArray.addObject("121212 1333113")
 */
        
        
        // Do any additional setup after loading the view.
    }
    // Mark: UITableView Data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.fromTask == 0 {
        return self.appdel.taskDao.company.makani.count
        }
        else {
        return 0
        }
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_makani")
        let makani = self.appdel.taskDao.company.makani.object(at: indexPath.row) as! MakaniDao
        
        let label = cell?.contentView.viewWithTag(100) as! UILabel
        
        let btn = cell?.contentView.viewWithTag(105) as! MakaniBtn
        btn.makani = makani.makani
        btn.addTarget(self, action:#selector(MakaniViewController.openMakaniMap(_:)), for: UIControlEvents.touchUpInside)
        label.text = makani.makani
        
    return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func adaptivePresentationStyleForPresentationController(_ controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func codeDetected(_ code: String) {
        self.makaniTextfield.text = code.components(separatedBy: "=").last
        //self.makaniTextfield.text = code
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
