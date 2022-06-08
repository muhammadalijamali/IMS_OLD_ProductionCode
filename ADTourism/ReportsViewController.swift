//
//  ReportsViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 8/24/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class ReportsViewController: UIViewController,EPieChartDataSource, MainJsonDelegate {
    var data : NSArray?
    
    @IBOutlet weak var avgtaskdurationline: UIView!
    
    @IBOutlet weak var reportTitle: UILabel!
    @IBOutlet weak var averageTaskView: UIView!
    @IBOutlet weak var taskReportslbl: UILabel!
    @IBOutlet weak var avgOnMyWaylbl: UILabel!
    @IBOutlet weak var onmywayDurationlbl: UILabel!
    
    @IBOutlet weak var timeReports: UILabel!
    @IBOutlet weak var avg_task_lbl: UILabel!
    @IBOutlet weak var averageTaskDuration: UILabel!
    @IBOutlet weak var chart1View: UIView!
    var ePieChart1 : EPieChart?
    var ePieChart2 : EPieChart?
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var report : ReportDao = ReportDao()
    var localisation : Localisation!
    
    

    @IBOutlet weak var chart2View: UIView!
    @IBAction func goBack(_ sender: AnyObject) {
    self.navigationController?.popViewController(animated: true)
        
    }
    
    func setupDownloader(){
    
        if Reachability.connectedToNetwork() {
            let loginUrl = Constants.baseURL + "getInspectorGeneralReport?inspector_id=" + self.appDel.user.user_id
            print(loginUrl)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "report")
            
            
            
        } // end

    }
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "report" {
        
        let parser = JsonParser()
         let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
          print("Str \(str)")
            
         self.report = parser.parseReports(data)
            if self.report.avg_on_my_way_duration == nil {
            self.onmywayDurationlbl.text = "00:00:00"
            }
            else {
            
         print("not started \(report.notstarted) avg_on_my_way_duration \(self.report.avg_on_my_way_duration)" )
            let (h,m,s) = secondsToHoursMinutesSeconds(Int(self.report.avg_on_my_way_duration!)!)
                let str = String(format: "%02d:%02d:%02d", h,m,s)

                self.onmywayDurationlbl.text = str
            }
            
            
            if self.report.avg_task_duration == nil {
                self.onmywayDurationlbl.text = "00:00:00"
                
            }
            else {
                print("not started \(report.notstarted) avg_on_my_way_duration \(self.report.avg_task_duration)" )
                let (h,m,s) = secondsToHoursMinutesSeconds(Int(self.report.avg_task_duration!)!)
                let str = String(format: "%02d:%02d:%02d", h,m,s)
                self.averageTaskDuration.text = str
            }
            self.setupValues()

        }
        
    }
    
    func secondsToHoursMinutesSeconds (_ seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func setupValues(){
    
//        var temp = NSMutableArray()
//        for a in 0  ..< 50 {
//            var rand = arc4random() % 100
//            var eColumnDatamModel = EColumnDataModel(label: "\(a)", value: Float(rand), index: a, unit: "Min")
//            temp.addObject(eColumnDatamModel)
//        }
//        
//        var dataArray = NSArray(array: temp)
//        self.data = dataArray
//        let echart = EColumnChart(frame: CGRectMake(40, 100, 750, 900))
//        echart.normalColumnColor = UIColor.purpleColor()
//        echart.columnsIndexStartFromLeft = true
        //echart.delegate = self
        //echart.dataSource = self
        // self.view.addSubview(echart)
        
        print("Not Started \(self.report.notstarted)")
        let totaltasks = Double(self.report.notstarted!)! + Double(self.report.completed!)! + Double(self.report.closed!)! + Double(self.report.active!)!
        let pendingColor = UIColor(red: 230/255, green: 79/255, blue: 59/255, alpha: 1.0)
         let compTask = Double(self.report.completed!)! + Double(self.report.closed!)!
        var piechart:EPieChartDataModel
        if CGFloat(NSString(string: self.report.notstarted!).doubleValue) == 0 {
        // piechart = EPieChartDataModel(budget: CGFloat(totaltasks), current: CGFloat(NSString(string: self.report.notstarted!).doubleValue)  , estimate:CGFloat(compTask), type : 0)
            piechart = EPieChartDataModel(budget: CGFloat(totaltasks), current: CGFloat(compTask) , estimate:CGFloat(NSString(string: self.report.notstarted!).doubleValue) , type : 0)
            
        }
        else {
        
        
        
            
            piechart = EPieChartDataModel(budget: CGFloat(totaltasks), current: CGFloat(compTask) , estimate:CGFloat(NSString(string: self.report.notstarted!).doubleValue) , type : 0)
            

        }
        
        
      //  let piechart = EPieChartDataModel(budget: 1, current: CGFloat(
        //    NSString(string: self.report.notstarted!).doubleValue), estimate:   CGFloat(NSString(string: self.report.completed!).doubleValue))
        
        
        if ((ePieChart1 == nil))
      
        {
            //EPieChart *ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(100, 150, 150, 150)];
            let taskColor = UIColor(red: 230/255, green: 79/255, blue: 59/255, alpha: 1.0)

            
            ePieChart1 = EPieChart(frame:CGRect(x: 0, y: 0, width: 280 ,height: 280),ePieChartDataModel : piechart,budgetTitle : localisation.localizedString(key:"reports.performed") , secondValueTitle : localisation.localizedString(key:"reports.pending") ,graphColor:taskColor, detail : localisation.localizedString(key:"reports.details"))
            
            
            //EPieChart(frame: <#T##CGRect#>, ePieChartDataModel: <#T##EPieChartDataModel!#>)
            ePieChart1?.frontPie.currentColor = UIColor(red: 230/255, green: 79/255, blue: 59/255, alpha: 1.0)

            ePieChart1?.frontPie.budgetColor = UIColor(red: 199/255, green: 198/255, blue: 201/255, alpha: 1.0)
            
            ePieChart1?.frontPie.estimateColor = UIColor(red: 230/255, green: 79/255, blue: 59/255, alpha: 1.0)
            
            //ePieChartDataModel:ePieChartDataModel];
        }
        
        ePieChart1!.budgetTitle = "Performed"
        
        ePieChart1!.center = CGPoint(x: self.chart1View.bounds.midX, y: self.chart2View.bounds.midY);
        ePieChart1!.motionEffectOn = true
        ePieChart1!.dataSource = self
        
        self.chart1View.addSubview(ePieChart1!)
        if self.report.avg_inactive_duration != nil && self.report.avg_inactive_duration != nil {
            print("avg_active_duration \(CGFloat(Double(self.report.avg_active_duration!)!)/60)")
            
        let totalTime  = CGFloat(Double(self.report.avg_active_duration!)!)/60 + CGFloat(Double(self.report.avg_inactive_duration!)!)/60
        print("Total Time \(totalTime)")
        print("Inactive \(CGFloat(Double(self.report.avg_inactive_duration!)!)/60)")
            print("Active \(CGFloat(Double(self.report.avg_active_duration!)!)/60)")
            
            
        //let piechart2 = EPieChartDataModel(budget: 10, current: 6, estimate: 5)
            
        //let piechart2 = EPieChartDataModel(budget: totalTime, current: CGFloat(Double(self.report.avg_active_duration!)!)/60, estimate: CGFloat(Double(self.report.avg_inactive_duration!)!)/60 , type : 1)
            
           
            let piechart2 = EPieChartDataModel(budget: totalTime, current:CGFloat(Double(self.report.avg_active_duration!)!)/60 , estimate: CGFloat(Double(self.report.avg_inactive_duration!)!)/60 , type : 1)
            
          //  let piechart2 = EPieChartDataModel(budget: totalTime, current:CGFloat(Double(self.report.avg_inactive_duration!)!)/60 , estimate: CGFloat(Double(self.report.avg_active_duration!)!)/60 , type : 1)
            
            piechart.type = 1
        
        
        if ((ePieChart2 == nil))
        {
            //EPieChart *ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(100, 150, 150, 150)];
            let timeColor = UIColor(red: 74/255, green: 186/255, blue: 176/255, alpha: 1.0)
            
            
            ePieChart2 = EPieChart(frame:CGRect(x: 0, y: 0, width: 280 ,height: 280),ePieChartDataModel : piechart2,budgetTitle : localisation.localizedString(key: "task.active") , secondValueTitle : localisation.localizedString(key:"reports.inactive") , graphColor : timeColor ,detail: localisation.localizedString(key:"reports.details"))
            
            //EPieChart(frame: <#T##CGRect#>, ePieChartDataModel: <#T##EPieChartDataModel!#>)
//            ePieChart2?.frontPie.currentColor = UIColor(red: 199/255, green: 198/255, blue: 201/255, alpha: 1.0)
//            ePieChart2?.frontPie.estimateColor = UIColor(red: 74/255, green: 186/255, blue: 176/255, alpha: 1.0)
//            ePieChart2?.frontPie.budgetColor = UIColor(red: 199/255, green: 198/255, blue: 201/255, alpha: 1.0)
            
            ePieChart2?.frontPie.currentColor = UIColor(red: 74/255, green: 186/255, blue: 176/255, alpha: 1.0)
            
            ePieChart2?.frontPie.budgetColor = UIColor(red: 199/255, green: 198/255, blue: 201/255, alpha: 1.0)
            
            ePieChart2?.frontPie.estimateColor = UIColor(red: 74/255, green: 186/255, blue: 176/255, alpha: 1.0)
            
//            
            //ePieChartDataModel:ePieChartDataModel];
        }
        
        ePieChart2!.center = CGPoint(x: self.chart2View.bounds.midX, y: self.chart2View.bounds.midY);
        ePieChart2!.motionEffectOn = true
        ePieChart2!.dataSource = self
        ePieChart2!.budgetTitle = "Active"
        
        
        self.chart2View.addSubview(ePieChart2!)
        
        self.chart1View.backgroundColor = UIColor(patternImage: UIImage(named: "reportbox")!)
        self.chart2View.backgroundColor = UIColor(patternImage: UIImage(named: "reportbox")!)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBarHidden = false
       // self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.isNavigationBarHidden = true
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
        
        
        self.reportTitle.text = localisation.localizedString(key: "reports.reports")
        
        
        self.timeReports.text = localisation.localizedString(key: "reports.timereports")
        
        self.taskReportslbl.text = localisation.localizedString(key: "reports.taskreports")
        
        
        self.avg_task_lbl.text = localisation.localizedString(key: "reports.averagetaskduration")
        
        self.avgOnMyWaylbl.text = localisation.localizedString(key: "reports.averageonmyway")
        
        self.view.bringSubview(toFront: self.averageTaskView)
        
        self.view.bringSubview(toFront: self.avg_task_lbl)
        self.view.bringSubview(toFront: self.avgtaskdurationline)
        
        self.view.bringSubview(toFront: self.averageTaskDuration)

        
        
        self.setupDownloader()
        /*
        "reports.timereports" = "Time Reports";
        "reports.taskreports" = "Task Reports";
        "reports.active" = "Active";
        "reports.inactive" = "In Active";
        "reports.averageonmyway" = "Average 'On My Way' duration";
        "reports.pending" = "Pending";
        "reports.performed"="Performed";
        "reports.averagetaskduration" = "Average Task duration";
    */
        
        
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func numberOfColumnsInEColumnChart(eColumnChart: EColumnChart!) -> Int {
        return (self.data?.count)!
    }
    
    func numberOfColumnsPresentedEveryTime(eColumnChart: EColumnChart!) -> Int {
        return 7
        
    }
 */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func backView(for ePieChart: EPieChart!) -> UIView! {
        return UIView()
        
    }
    
    
//    func eColumnChart(eColumnChart: EColumnChart!, valueForIndex index: Int) -> EColumnDataModel! {
//        if index >= data?.count || index < 0 {
//            return nil
//        }
//        return data?.objectAtIndex(index) as! EColumnDataModel
//    }
//    
//    func highestValueEColumnChart(eColumnChart: EColumnChart!) -> EColumnDataModel! {
//        
//        let maxDataModel : EColumnDataModel = data![0] as! EColumnDataModel
//        return maxDataModel
//        
//        
//    }


}
