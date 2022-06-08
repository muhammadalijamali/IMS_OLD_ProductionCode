//
//  NotificationsViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 4/17/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource, MainJsonDelegate {
    @IBOutlet weak var deleteAllBtn: UIButton!
    
    
    @IBAction func deleteAllMethod(_ sender: AnyObject) {
    self.deleteNotification("")
    }
    var notificationsArray : NSMutableArray = NSMutableArray()
    var localisation : Localisation!

    @IBAction func menuButtonClicked(_ sender: AnyObject) {
    self.revealViewController().revealToggle(animated: true)
    }
    @IBOutlet weak var notificationsLbl: UILabel!
    var appDel : AppDelegate!

    @IBOutlet weak var notificationsTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
//        notificationsArray.addObject("")
//        notificationsArray.addObject("")
//        notificationsArray.addObject("")
//        notificationsArray.addObject("")
//        notificationsArray.addObject("")
//        
        
        self.navigationController?.isNavigationBarHidden = true
        //self.title = "history.notifications"
        self.appDel = UIApplication.shared.delegate as! AppDelegate
         self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
        self.notificationsLbl.text = localisation.localizedString(key: "history.notifications")
        self.deleteAllBtn.setTitle(localisation.localizedString(key: "settings.deleteAll"), for: UIControlState())
        self.setupNotificationsDownloader()
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())


        // Do any additional setup after loading the view.
    }

    func setupNotificationsDownloader(){
        if Reachability.connectedToNetwork() {
            self.appDel.showIndicator = 1
        let loginUrl = Constants.baseURL + "getNotifications?user_id=" + self.appDel.user.user_id
        print(loginUrl)
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "notif")
        }

    }
    
    func deleteNotification(_ notif_id : String){
        let loginUrl = Constants.baseURL + "markAsReadNotifications?user_id=" + self.appDel.user.user_id + "&notification_id=" + notif_id
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "delete")
        
    }
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        //print(str)
        
        if identity == "notif" {
            let parser = JsonParser()
            self.notificationsArray = parser.parseNotif(data)
            //print(self.notificationsArray.count)
            self.notificationsTable.reloadData()
        }
        else if identity == "delete" {
            if str!.contains("success") {
            self.setupNotificationsDownloader()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_notification")
        if let notif = self.notificationsArray.object(at: indexPath.row) as? NotifDao {
            let lbl = cell?.viewWithTag(100) as! UILabel
            if self.appDel.selectedLanguage == 1 {
                lbl.text = notif.msg
            }
            else {
                lbl.text = notif.msg_ar
                
            }
            if indexPath.row % 2 == 0 {
                cell?.contentView.backgroundColor  = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
            }
            else {
                cell?.contentView.backgroundColor  = UIColor.white
            }
            let btn = cell?.viewWithTag(200) as? UIButton
            btn?.tag = indexPath.row
            btn?.addTarget(self, action: #selector(NotificationsViewController.deleteNotifInc(_:)), for: UIControlEvents.touchUpInside)
            

            

        }
        else if let dao = self.notificationsArray.object(at: indexPath.row) as? TaskDao {
        //let dao = self.notificationsArray.objectAtIndex(indexPath.row) as! TaskDao
        let lbl = cell?.viewWithTag(100) as! UILabel
        if self.appDel.selectedLanguage == 1 {
        lbl.text = dao.message
        }
        else {
            lbl.text = dao.msg_ar
            
        }
        if indexPath.row % 2 == 0 {
        cell?.contentView.backgroundColor  = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        }
        else {
            cell?.contentView.backgroundColor  = UIColor.white
        }
        }
        let btn = cell?.viewWithTag(200) as? UIButton
        btn?.tag = indexPath.row
        btn?.addTarget(self, action: #selector(NotificationsViewController.deleteNotif(_:)), for: UIControlEvents.touchUpInside)
        return cell!
    
        
        }
    @objc func deleteNotifInc(_ sender : UIButton) {
       // if ((self.notificationsArray.object(at: sender.tag) as AnyObject).isMember(of: NotifDao) {
        if (self.notificationsArray.object(at: sender.tag) as AnyObject) is NotifDao {
            let dao = self.notificationsArray.object(at: sender.tag) as! NotifDao
        
        self.deleteNotification(dao.notif_id!)
        }
        else {
            let dao = self.notificationsArray.object(at: sender.tag) as! TaskDao
            
            self.deleteNotification(dao.notif_id!)
        }
    }
    @objc func deleteNotif(_ sender : UIButton) {
        let dao = self.notificationsArray.object(at: sender.tag) as! TaskDao
     
        self.deleteNotification(dao.notif_id!)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dao = self.notificationsArray.object(at: indexPath.row) as? TaskDao {
        if dao.company.company_id != nil {
          self.appDel.taskDao = dao
        self.performSegue(withIdentifier: "sw_notiftocompany", sender: nil)
        
        }
        }
        else if let notif = self.notificationsArray.object(at: indexPath.row) as? NotifDao {
            if notif.incidentDao!.inspectorID == self.appDel.user.user_id {
            self.appDel.notifDao = notif
        self.appDel.showIncidentMedia = 2
            let vc : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "cnt_createincidentcnt"))!
            vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
            self.present(vc, animated: true, completion: nil)
            }
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
