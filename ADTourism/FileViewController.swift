//
//  FileViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 9/19/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class FileViewController: UIViewController, SessionDelegate,SessionDataDelegate {

    @IBOutlet weak var adhocBtn: PermitBtn!
    @IBAction func openAdhoc(_ sender: UIButton) {
    
    }
    @IBOutlet weak var loadingAlert: UILabel!
    @IBOutlet weak var pdfWebView: UIWebView!
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var currentVisible : Int = 0 // 0 not visible 1 visible
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.currentVisible = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.currentVisible = 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        let targetURL = NSURL(string:Constants.downloadUrl + self.appDel.selectedPermit!.url!)!
//        print(targetURL)
        self.pdfWebView.isHidden = true
        if Reachability.connectedToNetwork() {
        self.setupPermitUrl()
            
        }
        else {
            if self.appDel.selectedPermit != nil {
                if self.appDel.selectedPermit!.permitID != nil {
            let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentDirectoryPath:String = path[0]
            let folderPath =  documentDirectoryPath + "/permits/\(self.appDel.selectedPermit!.permitID!).pdf"
            if FileManager.default.fileExists(atPath: folderPath) {
            let url = URL(string: folderPath)
            let request = URLRequest(url: url!)
            
            
            self.pdfWebView.isHidden = false
            self.loadingAlert.isHidden = true
            pdfWebView.loadRequest(request)
                print("Loading file at \(folderPath)")
            }
            else {
            //print("File Not Found \(folderPath)")
            }
        }
            }
        }
        self.navigationController? .setNavigationBarHidden(false, animated:true)

        // Do any additional setup after loading the view.
    }
    func setupPermitUrl(){
        if self.appDel.selectedPermit != nil {
            if self.appDel.selectedPermit!.permitID != nil && self.appDel.selectedPermit!.ReportID != nil {
                
        let session = SessionDataDownloader()
        session.del = self
        let loginUrl = "\(Constants.baseURL)downloadPermitByPermitNo?permitNo=\(self.appDel.selectedPermit!.permitID!)&ReportID=\(self.appDel.selectedPermit!.ReportID!)"
        
        print(loginUrl)
        
        session.setupSessionDownload(loginUrl, session_id: String(describing: Date().addingTimeInterval(1970)))
            }
        }
        
    }
    func dataDownloader(_ data: Data) {
        let parser  = JsonParser()
        let urlstr = parser.parsePermitUrl(NSMutableData(data: data))
        if urlstr != nil {
            print(urlstr)
        self.setupFileDownload(urlstr!)
        }
    }
    
    func setupFileDownload(_ urlStr : String){
          let fileSession = SessionFileDownLoader()
        fileSession.del = self
       // print(self.appDel.selectedPermit!.url)
        
        
        fileSession.permitDao = self.appDel.selectedPermit
        
        fileSession.setupSessionDownload("\(Constants.downloadUrl)\(urlStr)")
                
            
            
            
            self.appDel.setupProgressbar()
                
        
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateProgress(_ progress: Float, identity: String) {
      
         self.appDel.progressBar.setProgress(progress, animated: true)
        
    }
    func fileDownload( _ url : URL){
        self.appDel.removeprogressbar()
        let request = URLRequest(url: url)
       
        self.pdfWebView.isHidden = false 
        self.loadingAlert.isHidden = true
         pdfWebView.loadRequest(request)
        if self.currentVisible == 0 {
        let alert = SCLAlertView()
        alert.addButton("View File", action: {
       
            
           
            print("File url \(url)")
                UIApplication.shared.openURL(url)
            //
            //cnt_generalfile
            let cnt = self.storyboard?.instantiateViewController(withIdentifier: "cnt_generalfile") as! GeneralFileViewController
            cnt.loadurl = url
            //self.presentViewController(cnt, animated: true, completion: nil)
            self.appDel.removeprogressbar()
            self.getTopViewController().present(cnt, animated: true, completion: nil)
            
            
            

        })
        alert.showInfo("Permit Downloaded", subTitle: "")
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

    func getTopViewController() -> UIViewController {
        var topViewController = UIApplication.shared.delegate!.window!!.rootViewController!
        while (topViewController.presentedViewController != nil) {
            topViewController = topViewController.presentedViewController!
        }
        return topViewController
    }
}
