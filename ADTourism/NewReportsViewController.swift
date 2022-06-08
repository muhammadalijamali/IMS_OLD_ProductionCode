//
//  NewReportsViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 11/13/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class NewReportsViewController: UIViewController,XYPieChartDelegate,XYPieChartDataSource,SessionDataDelegate , UITableViewDelegate, UITableViewDataSource,DateSelectorDelegate {

    @IBOutlet weak var endDateBtn: ADButton!
    @IBOutlet weak var startDatebtn: ADButton!
    @IBOutlet weak var startDatelbl: UILabel!
    @IBOutlet weak var avglbl: UILabel!
    @IBOutlet weak var visitlbl: UILabel!
    @IBOutlet weak var activeInactivelbl: UILabel!
    @IBOutlet weak var assignedTasklbl: UILabel!
    @IBOutlet weak var avgTable: UITableView!
    @IBOutlet weak var outerAverage: UIView!
    @IBOutlet weak var selectedVisitColor: UIView!
    @IBOutlet weak var selectedVisitlbl: UILabel!
    @IBOutlet weak var outerVisitView: UIView!
    @IBOutlet weak var outerActiveInactiveView: UIView!
    @IBOutlet weak var selectedActivelabel: UILabel!
    @IBOutlet weak var selectedActiveColor: UIView!
    @IBOutlet weak var dateOuter: UIView!
    @IBOutlet weak var taskOuterView: UIView!
    @IBOutlet weak var task_color: UIView!
    @IBOutlet weak var statuslbl: UILabel!
    @IBOutlet weak var visitChart: XYPieChart!
    var openedSection : Int = 0
    
    var firstDate : Date?
    var secondDate : Date?
    var whichDate : Int = 0
    
    var mainDao : MainDashbaordDao?
    var localisation : Localisation!
    
    @IBOutlet weak var endDatelbl: UILabel!
    
    @IBAction func startDateMethod(_ sender: ADButton) {
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        let menuViewController: DateSelectorViewController = storyboard.instantiateViewController(withIdentifier: "cnt_date") as! DateSelectorViewController
        menuViewController.delegate = self
        menuViewController.button = (sender )
        self.whichDate = 0
        self.appDel.calenderHisyoty = 1
        
        
        
        menuViewController.modalPresentationStyle = .popover
        //menuViewController.preferredContentSize = CGSizeMake(50, 100)
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .any
        // popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = (sender as UIButton)
        
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
    
    @IBAction func endDateMethod(_ sender: ADButton) {
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        let menuViewController: DateSelectorViewController = storyboard.instantiateViewController(withIdentifier: "cnt_date") as! DateSelectorViewController
        menuViewController.delegate = self
        menuViewController.button = (sender )
        self.whichDate = 1
        self.appDel.calenderHisyoty = 1
        
        
        
        menuViewController.modalPresentationStyle = .popover
        //menuViewController.preferredContentSize = CGSizeMake(50, 100)
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .any
        // popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = (sender as UIButton)
        
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
    
    
    
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var totalTasks_array : NSMutableArray = NSMutableArray()
    var allColors : NSMutableArray = NSMutableArray()
    var allVisitsArray : NSMutableArray = NSMutableArray()
    
    
  
    @IBOutlet weak var taskStatusPie: XYPieChart!
    @IBOutlet weak var reportTitle: UILabel!
    @IBAction func goBack(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBOutlet weak var active_inactive_chart: XYPieChart!
    var active_inactive_array : NSMutableArray = NSMutableArray()
    var colorArray : NSMutableArray = NSMutableArray()
    var task_status_array : NSMutableArray = NSMutableArray()
    var task_status_color : NSMutableArray = NSMutableArray()
    var visitArray : NSMutableArray = NSMutableArray()
    var visitColorArray : NSMutableArray = NSMutableArray()
    
    
    
    @IBOutlet weak var active_inactive: XYPieChart!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupReportDownloder()
        self.localisation = Localisation()
        
        
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
            
            //  self.userTextField.textAlignment = NSTextAlignment.Right
            // self.passwordField.textAlignment = NSTextAlignment.Right
            
            
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            
            
        }
        
        //"chat.selectuser" = "Select user to start chat";
        
        //"chat.chat" = "Chat";
    

        //self.active_inactive_array.addObject(CGFloat(20.0))
        //self.active_inactive_array.addObject(CGFloat(40.0))
        self.colorArray.add(UIColor(red: 88/255, green: 196/255, blue: 190/255, alpha: 1.0))
        self.colorArray.add(UIColor(red: 137/255, green: 200/255, blue:233/255 , alpha: 1.0))
        self.colorArray.add(UIColor(red: 244/255, green: 179/255, blue:80/255 , alpha: 1.0))
        self.colorArray.add(UIColor(red: 155/255, green: 89/255, blue:182/255 , alpha: 1.0))
        self.colorArray.add(UIColor(red: 237/255, green: 101/255, blue:75/255 , alpha: 1.0))
        self.colorArray.add(UIColor(red: 44/255, green: 62/255, blue:78/255 , alpha: 1.0))
        self.colorArray.add(UIColor(red: 108/255, green: 122/255, blue:137/255 , alpha: 1.0))
        self.colorArray.add(UIColor(red: 210/255, green: 82/255, blue:127/255 , alpha: 1.0))
        self.colorArray.add(UIColor(red: 255/255, green: 201/255, blue:102/255 , alpha: 1.0))
        self.colorArray.add(UIColor(red: 255/255, green: 153/255, blue:153/255 , alpha: 1.0))
        self.colorArray.add(UIColor(red: 210/255, green: 82/255, blue:127/255 , alpha: 1.0))
        self.colorArray.add(UIColor(red: 155/255, green: 89/255, blue:182/255 , alpha: 1.0))
        self.colorArray.add(UIColor(red: 210/255, green: 82/255, blue:127/255 , alpha: 1.0))
        self.colorArray.add(UIColor(red: 88/255, green: 196/255, blue: 190/255, alpha: 1.0))
        
        self.taskOuterView.layer.borderWidth = 0.5
        /*
        "reports.Assigned Tasks " = "Assigned Tasks";
        "reports.activeinactive" = "Active/InActive Hours";
        "reports.visits" = "Visits";
        "reports.Average Time" = "Average Time";
         */
        
        self.assignedTasklbl.text = localisation.localizedString(key: "reports.Assigned Tasks")
        self.activeInactivelbl.text = localisation.localizedString(key: "reports.activeinactive")
        self.visitlbl.text = localisation.localizedString(key: "reports.visits")
        self.avglbl.text = localisation.localizedString(key: "reports.Average Time")
        //"tasks.startdate" = "Start Date";
        //"tasks.enddate" = "End Date";
        self.startDatelbl.text = localisation.localizedString(key: "tasks.startdate")
        self.endDatelbl.text = localisation.localizedString(key: "tasks.enddate")
        self.startDatebtn.setTitle(localisation.localizedString(key: "tasks.startdate"), for: UIControlState())
        self.endDateBtn.setTitle(localisation.localizedString(key: "tasks.enddate"), for: UIControlState())
        self.reportTitle.text = localisation.localizedString(key: "reports.reports")
        
        
        
        
        
        
        self.taskOuterView.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0).cgColor
        self.dateOuter.layer.borderWidth = 0.5
        self.dateOuter.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0).cgColor
        
        self.outerActiveInactiveView.layer.borderWidth = 0.5
        self.outerActiveInactiveView.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0).cgColor
        
        self.outerVisitView.layer.borderWidth = 0.5
        self.outerVisitView.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0).cgColor
        
        
      
        self.outerAverage.layer.borderWidth = 0.5
        self.outerAverage.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0).cgColor
        
        
        
        
//        visitArray.addObject(CGFloat(10.0))
//        visitArray.addObject(CGFloat(10.0))
//        visitArray.addObject(CGFloat(10.0))
//        visitArray.addObject(CGFloat(10.0))
//        visitArray.addObject(CGFloat(10.0))
//        
//        visitArray.addObject(CGFloat(50.0))
//        
//        
//      
//        
//        active_inactive_chart.delegate = self
//        active_inactive_chart.dataSource = self
//        active_inactive_chart.startPieAngle = CGFloat(M_PI_2)
//        active_inactive_chart.showPercentage = false
//        active_inactive_chart.labelShadowColor = UIColor.blueColor()
//        //self.active_inactive_chart.isUserInteractionEnabled = true
//        self.active_inactive_chart.animationSpeed = 2.0
//        active_inactive_chart.reloadData()
//        
//        self.task_status_array.addObject(CGFloat(20.0))
//        self.task_status_array.addObject(CGFloat(30.0))
//        self.task_status_array.addObject(CGFloat(50.0))
        
//        self.task_status_color.addObject(UIColor(red: 250/255, green: 163/255, blue: 144/255, alpha: 1.0))
//        self.task_status_color.addObject(UIColor(red: 144/255, green: 250/255, blue:187/255 , alpha: 1.0))
//        self.task_status_color.addObject(UIColor(red: 200/255, green: 200/255, blue:187/255 , alpha: 1.0))
//        
 
        
        
        
        
        
//        self.visitChart.delegate = self
//        visitChart.dataSource = self
//        visitChart.startPieAngle = CGFloat(M_PI_2)
//        visitChart.showPercentage = true
//        visitChart.labelShadowColor = UIColor.blueColor()
//        //self.active_inactive_chart.isUserInteractionEnabled = true
//        self.visitChart.animationSpeed = 2.0
//        visitChart.reloadData()
//        
//        
        
        
        
        // Do any additional setup after loading the view.
    }

    // MARK:-
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mainDao == nil {
        return 0
        }
        
        
//        if section == 0 || section == 1 {
//            return self.mainDao!.task_report_array.count + 1 // one cell for section
//        }
//        else  {
//            return self.mainDao!.avg_daily_active_inactiveArray.count + 1
//            
//        } // end of the else
        
        
            return 3
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
       
        return 50
    }
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//        
//    }
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        
//        let uiview = UIView(frame: CGRectMake(0, 0, 300, 100))
//       uiview.backgroundColor = UIColor.whiteColor()
//        if section ==  0 {
//        let titleLabel = UILabel(frame: CGRectMake(210, 0, 200, 50))
//        titleLabel.text = localisation.localizedString(key: "tasks.onmyway")
//        titleLabel.font = UIFont(name: "DroidArabicKufi", size: 15.0)
//            
//        titleLabel.textColor = UIColor.darkGrayColor()
//            uiview.addSubview(titleLabel)
//            
//         let button = UIButton(frame: CGRectMake(230, 03, 200, 50))
//         button.setImage(UIImage(named: "arrowdown"), forState: UIControlState.Normal)
//          uiview.addSubview(button)
//            let valueLabel = UILabel(frame: CGRectMake(10, 0, 200, 50))
//            valueLabel.text = localisation.localizedString(key: "tasks.onmyway")
//            valueLabel.font = UIFont(name: "DroidArabicKufi", size: 15.0)
//            if mainDao != nil {
//                     var (h,m,s) = secondsToHoursMinutesSeconds(Int(mainDao!.avg_time!.avg_on_way_duration!)!)
//                    valueLabel.text = "\( localisation.localizedString(key: "reports.Average Time")):(\(h):\(m):\(s))"
//
//            
//            valueLabel.textColor = UIColor.darkGrayColor()
//            uiview.addSubview(valueLabel)
//            }
//            
//       
//            
//            
//        }
//        
//        
//        if section ==  1 {
//            let titleLabel = UILabel(frame: CGRectMake(200, 0, 200, 50))
//            titleLabel.text = localisation.localizedString(key: "reports.Assigned Tasks")
//            titleLabel.font = UIFont(name: "DroidArabicKufi", size: 15.0)
//            
//            titleLabel.textColor = UIColor.darkGrayColor()
//            uiview.addSubview(titleLabel)
//            
//            let button = UIButton(frame: CGRectMake(230, 03, 200, 50))
//            button.setImage(UIImage(named: "arrowdown"), forState: UIControlState.Normal)
//             uiview.addSubview(button)
//            let valueLabel = UILabel(frame: CGRectMake(10, 0, 200, 50))
//            valueLabel.text = localisation.localizedString(key: "reports.Assigned Tasks")
//            valueLabel.font = UIFont(name: "DroidArabicKufi", size: 15.0)
//            if mainDao != nil {
//            var (h,m,s) = self.secondsToHoursMinutesSeconds(Int(mainDao!.avg_time!.avg_task_duration!)!)
//            valueLabel.text = "\( localisation.localizedString(key: "reports.Average Time")):(\(h):\(m):\(s))"
//            }
//
//            
//            
//            
//                                
//                
//                valueLabel.textColor = UIColor.darkGrayColor()
//                uiview.addSubview(valueLabel)
//            
//            
//            
//            
//            
//        }
//        if section ==  2 {
//            let titleLabel = UILabel(frame: CGRectMake(200, 0, 200, 50))
//            titleLabel.text = localisation.localizedString(key: "task.active")
//            titleLabel.font = UIFont(name: "DroidArabicKufi", size: 15.0)
//            
//            titleLabel.textColor = UIColor.darkGrayColor()
//            uiview.addSubview(titleLabel)
//            
//            let button = UIButton(frame: CGRectMake(230, 03, 200, 50))
//            button.setImage(UIImage(named: "arrowdown"), forState: UIControlState.Normal)
//            uiview.addSubview(button)
//            let valueLabel = UILabel(frame: CGRectMake(10, 0, 200, 50))
//            valueLabel.text = localisation.localizedString(key: "task.active")
//            valueLabel.font = UIFont(name: "DroidArabicKufi", size: 15.0)
//            if mainDao != nil {
//                var (h,m,s) = secondsToHoursMinutesSeconds(Int(mainDao!.total_average_activeInActvie!.active!)!)
//                valueLabel.text = "\( localisation.localizedString(key: "reports.Average Time")):(\(h):\(m):\(s))"
//                
//                
//                valueLabel.textColor = UIColor.darkGrayColor()
//                uiview.addSubview(valueLabel)
//            }
//            
//            
//            
//            
//        }
//
//        
//
//        return uiview
//        
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selee")
        print(indexPath.row)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
//        var cell = tableView.dequeueReusableCellWithIdentifier("cell_reportavgvaluecell") as! AvgTitleTableViewCell
//        cell.establishmentName.text = ""
//        cell.establishmentDate.text = ""
//        cell.averageTimelbl.text = ""
//        cell.establishmentName.hidden = false
//        
//        
//        if indexPath.section == 0 { // avg on my way
//            if indexPath.row == 0 {
//             cell = tableView.dequeueReusableCellWithIdentifier("cell_reportavgtitlecell") as! AvgTitleTableViewCell
//                /*
//                "reports.Assigned Tasks" = "Assigned Tasks";
//                "reports.activeinactive" = "Active/InActive Hours";
//                "reports.visits" = "Visits";
//                "reports.Average Time" = "Average Time";
//               */
//               cell.establishmentName.text = localisation.localizedString(key: "tasks.company")
//               cell.establishmentDate.text = localisation.localizedString(key: "reports.date")
//               cell.averageTimelbl.text = localisation.localizedString(key: "reports.Average Time")
//                
//                
//
//                
//                
//
//                
//            } // end of the index path
//            else {
//               // cell = tableView.dequeueReusableCellWithIdentifier("cell_reportavgvaluecell") as! AvgTitleTableViewCell
//                let avg = mainDao!.task_report_array.objectAtIndex(indexPath.row - 1) as! DashbaordTask_Report
//                if avg.company_name != nil {
//                cell.establishmentName.text = avg.company_name!
//                }
//                if avg.completed_date != nil {
//                cell.establishmentDate.text = avg.completed_date!
//                }
//                if avg.taskDuration != nil {
//                cell.averageTimelbl.text = avg.taskDuration!
//                }
//                
//                
//            }
//            
//            
//        }
//        else
//        if indexPath.section == 1 { // avg task performed
//            
//            if indexPath.row == 0 {
//                // cell = tableView.dequeueReusableCellWithIdentifier("cell_reportavgtitlecell") as! AvgTitleTableViewCell
//                /*
//                 "reports.Assigned Tasks" = "Assigned Tasks";
//                 "reports.activeinactive" = "Active/InActive Hours";
//                 "reports.visits" = "Visits";
//                 "reports.Average Time" = "Average Time";
//                 */
//                cell.establishmentName.text = localisation.localizedString(key: "tasks.company")
//                cell.establishmentDate.text = localisation.localizedString(key: "reports.date")
//                cell.averageTimelbl.text = localisation.localizedString(key: "reports.Average Time")
//                
//                
//                
//                
//                
//                
//                
//            } // end of the index path
//            else {
//               // cell = tableView.dequeueReusableCellWithIdentifier("cell_reportavgvaluecell") as! AvgTitleTableViewCell
//                let avg = mainDao!.task_report_array.objectAtIndex(indexPath.row - 1) as! DashbaordTask_Report
//                if avg.company_name != nil {
//                cell.establishmentName.text = avg.company_name!
//                }
//                if avg.completed_date != nil {
//                cell.establishmentDate.text = avg.completed_date!
//                }
//                if avg.onWayDuration != nil {
//                 cell.averageTimelbl.text = avg.onWayDuration!
//                }
//                else {
//                 cell.averageTimelbl.text = "0"
//                }
//                
//            }
//            
//
//        
//        }
//        else
//            
//        if indexPath.section == 2 { //  avg active 
//            
//            if indexPath.row == 0 {
//               //  cell = tableView.dequeueReusableCellWithIdentifier("cell_reportavgtitlecell") as! AvgTitleTableViewCell
//                /*
//                 "reports.Assigned Tasks" = "Assigned Tasks";
//                 "reports.activeinactive" = "Active/InActive Hours";
//                 "reports.visits" = "Visits";
//                 "reports.Average Time" = "Average Time";
//                 */
//                cell.establishmentName.text = localisation.localizedString(key: "tasks.company")
//               cell.establishmentName.hidden = true
//                cell.establishmentDate.text = localisation.localizedString(key: "reports.date")
//                cell.averageTimelbl.text = localisation.localizedString(key: "reports.Average Time")
//                
//                
//                
//                
//                
//                
//                
//            } // end of the index path
//            else {
//               // cell = tableView.dequeueReusableCellWithIdentifier("cell_reportavgvaluecell") as! AvgTitleTableViewCell
//                let avg = mainDao!.avg_daily_active_inactiveArray.objectAtIndex(indexPath.row - 1) as! DashbaordAverageActiveInActive
//                
//                cell.establishmentName.hidden = true
//                cell.establishmentDate.text = avg.date!
//                cell.averageTimelbl.text = avg.active!
//                
//                
//                
//            }
//            
//            
//
//        
//        }
//        return cell
//
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_reportcell") as! ReportTableViewCell
        
        if indexPath.row == 0 {
            
        cell.avgTitle.text = localisation.localizedString(key: "tasks.onmyway")
            if mainDao != nil {
                if mainDao!.avg_time != nil {
                    if mainDao!.avg_time!.avg_on_way_duration != nil {
                        
           var (h,m,s) = secondsToHoursMinutesSeconds(Int(mainDao!.avg_time!.avg_on_way_duration!)!)
            cell.avgValye.text = "\( localisation.localizedString(key: "reports.Average Time")):(\(h):\(m):\(s))"
                }
                }
                }
            
        }
        
        if indexPath.row == 1 {
            
            cell.avgTitle.text = localisation.localizedString(key: "reports.Assigned Tasks")
            
            //cell.avgValye.text = mainDao!.avg_time!.avg_task_duration!
            if mainDao != nil {
                if mainDao!.avg_time != nil {
                    if  mainDao!.avg_time!.avg_task_duration != nil {
            var (h,m,s) = secondsToHoursMinutesSeconds(Int(mainDao!.avg_time!.avg_task_duration!)!)
            cell.avgValye.text = "\( localisation.localizedString(key: "reports.Average Time")):(\(h):\(m):\(s))"
                }
                }
            }
            
        }
        if indexPath.row == 2 {
            
            cell.avgTitle.text = localisation.localizedString(key: "task.active")
            
            //cell.avgValye.text = mainDao!.total_average_activeInActvie!.active!
            if mainDao != nil {
                if mainDao!.total_average_activeInActvie != nil {
                    if mainDao!.total_average_activeInActvie!.active != nil {
            var (h,m,s) = secondsToHoursMinutesSeconds(Int(mainDao!.total_average_activeInActvie!.active!)!)
            cell.avgValye.text = "\(localisation.localizedString(key: "reports.Average Time")):(\(h):\(m):\(s))"
                    }
                    }
            }
        }
        return cell
    
    }
    
    
    func setupReportDownloder(){
        if self.firstDate != nil && self.secondDate != nil {
            self.mainDao = nil
            let formater : DateFormatter = DateFormatter()
            formater.dateFormat = "YYYY-MM-dd"
            formater.locale = Locale(identifier: "en_US")
            

            let session = SessionDataDownloader()
            session.del = self
            let loginUrl = "\(Constants.baseURL)getInspectorDashboardReport?inspector_id=\(self.appDel.user!.user_id!)&start_date=\(formater.string(from: self.firstDate!))&end_date=\(formater.string(from: self.secondDate!))"
            
            print(loginUrl)
            
            session.setupSessionDownload(loginUrl, session_id: String(describing: Date().addingTimeInterval(1970)))
            
        }
        else {
            self.mainDao = nil
            let session = SessionDataDownloader()
            session.del = self
            let loginUrl = Constants.baseURL + "getInspectorDashboardReport?inspector_id=" + self.appDel.user!.user_id
            print(loginUrl)
            
            session.setupSessionDownload(loginUrl, session_id: String(describing: Date().addingTimeInterval(1970)))
        }
        

    
    }
    
    func setupVisits(){
        self.selectedActivelabel.text = ""
        self.selectedActiveColor.backgroundColor = UIColor.clear
        if mainDao != nil {
            
            if mainDao!.categories != nil {
                var totalCount : Int = 0
                self.visitArray = NSMutableArray()
                
                for a in 0 ..< mainDao!.categories!.count {
                    
                    let category = mainDao!.categories?.object(at: a) as! DashbaordCategories
                   // print("Count \(category.task_count!) for category \(category.type_name!)")
                    
                    
                    totalCount = totalCount + Int(category.task_count!)!
                    
                }//  end of the for loop
                print("Total Count \(totalCount)")
            
            for a in 0 ..< mainDao!.categories!.count {
                let category = mainDao!.categories?.object(at: a) as! DashbaordCategories
                let percent = Float(category.task_count!)! / Float(totalCount) * 100
                print("percent \(percent)")
                self.visitArray.add(percent)
            }
            }
                    self.visitChart.delegate = self
                    visitChart.dataSource = self
                    visitChart.startPieAngle = CGFloat(M_PI_2)
                    visitChart.showPercentage = true
                    visitChart.labelShadowColor = UIColor.blue
                    //self.active_inactive_chart.isUserInteractionEnabled = true
                    self.visitChart.animationSpeed = 1.0
                    visitChart.reloadData()
            
        }// end of the mainDao
        
        
    
    }
    
    func dataDownloader(_ data: Data) {
        let parser = JsonParser()
        let mainDao = parser.parseMainDashbaord(NSMutableData(data: data))
        self.mainDao = mainDao
     //   print("Avg on My Way \(self.mainDao!.avg_time!.avg_on_way_duration)")
        self.setupTaskCharts()
        self.setupActiveInactiveChart()
        self.setupVisits()
        self.avgTable.reloadData()
        print("Avg daily \(self.mainDao!.avg_daily_active_inactiveArray.count)")
       print("Task reports \(self.mainDao!.avg_daily_active_inactiveArray.count)")
        
        //print("Not Started:\(mainDao.dashbaordTask!.notstarted!)")
        //print("completed:\(mainDao.dashbaordTask!.completed!)")
        //print("Active:\(mainDao.dashbaordTask!.active!)")
        
    
        
    }
    
    func setupActiveInactiveChart(){
        active_inactive_array = NSMutableArray()
        self.active_inactive_chart.reloadData()
        self.selectedActivelabel.text = ""
        self.selectedActiveColor.backgroundColor = UIColor.clear
        
        if self.mainDao != nil {
            
            if self.mainDao!.dashbaordHours != nil {
                if self.mainDao!.dashbaordTask!.active == nil {
                self.mainDao!.dashbaordHours!.active =  "0"
                }
                
                if self.mainDao!.dashbaordHours!.inactive == nil{
                    self.mainDao!.dashbaordHours!.inactive =  "0"
                    
                }
                
                if self.mainDao!.dashbaordHours!.active != nil && self.mainDao!.dashbaordHours!.inactive != nil {
    let active = round(Float(self.mainDao!.dashbaordHours!.active!)!)
    let inactive = round(Float(self.mainDao!.dashbaordHours!.inactive!)!)
    if active == 0.0 && inactive == 0.0 {
    return
    }
   let total  =  active + inactive
   let activePercentage = ((active/total) * 100)
   print("Active Pecentage \(round(activePercentage))")
   
   let inactivePercentage = ((inactive/total) * 100)

        print("InActive Pecentage \(round(inactivePercentage))")
  
                    
   self.active_inactive_array.add(activePercentage)
   self.active_inactive_array.add(inactivePercentage)
   active_inactive_chart.delegate = self
   active_inactive_chart.dataSource = self
   active_inactive_chart.startPieAngle = CGFloat(M_PI_2)
   active_inactive_chart.showPercentage = false
    active_inactive_chart.labelShadowColor = UIColor.blue
                            //self.active_inactive_chart.isUserInteractionEnabled = true
    self.active_inactive_chart.animationSpeed = 1.0
    active_inactive_chart.reloadData()
                 
                    
                    
                    
     
                    
                    
                    
                    
                    
                
                }
                
        }
    } // end of the main dao nil
    } // end of the function
    
    
    func setupTaskCharts(){
    //
    //
        task_status_array = NSMutableArray()
        self.taskStatusPie.reloadData()
        self.selectedActiveColor.backgroundColor = UIColor.clear
        self.selectedActivelabel.text = ""
        
        
        
        if self.mainDao != nil {
            if self.mainDao!.dashbaordTask != nil {
                if self.mainDao!.dashbaordTask!.notstarted == nil {
                self.mainDao!.dashbaordTask!.notstarted = "0"
                }
                if self.mainDao!.dashbaordTask!.completed == nil  {
                self.mainDao!.dashbaordTask!.completed = "0"
                }
                
                if self.mainDao!.dashbaordTask!.closed == nil {
                self.mainDao!.dashbaordTask!.closed = "0"
                }
                
                
                
                if self.mainDao!.dashbaordTask!.notstarted != nil && self.mainDao!.dashbaordTask!.completed != nil {
    let notstarted = Float(self.mainDao!.dashbaordTask!.notstarted!)
    let completed  = Float(self.mainDao!.dashbaordTask!.completed!)
    let closed = Float(self.mainDao!.dashbaordTask!.closed!)
                    
    var total = notstarted! + completed!
          total = total + closed!
                    
                    
                    
        print(100*completed!/total)
        
        if notstarted == 0.0 && completed == 0.0{
        return
        }
    let competedPercentage = ((completed!/total) * 100)
    print("Total \(total)Percentage: \(competedPercentage) completed : \(completed!)")
    
                    let closedPercentage = ((closed!/total) * 100)
                    
                    
        
        let notstartedProgress = Float(((notstarted!/total) * 100))
                    
        print("Total \(total)Not started Percentage: \(notstartedProgress) notstarted : \(notstarted!)")
        
        self.task_status_array = NSMutableArray()
        
        self.task_status_array.add(notstartedProgress)
        self.task_status_array.add(competedPercentage)
        self.task_status_array.add(closedPercentage)
                    
                    
        self.taskStatusPie.delegate = self
        taskStatusPie.dataSource = self
       // taskStatusPie.labelShadowColor = UIColor.clearColor()
        taskStatusPie.startPieAngle = CGFloat(M_PI_2)
        taskStatusPie.showPercentage = true
        taskStatusPie.labelShadowColor = UIColor.blue
        //self.active_inactive_chart.isUserInteractionEnabled = true
        self.taskStatusPie.animationSpeed = 1.0
        taskStatusPie.reloadData()
        }
            }
    
    }
    }
    
    
    
    func numberOfSlices(in pieChart: XYPieChart!) -> UInt {
        if pieChart == taskStatusPie {
        return UInt(self.task_status_array.count)
        }
        else if pieChart == visitChart {
        return UInt(self.visitArray.count)
        }
        return UInt(self.active_inactive_array.count)

    }
    func pieChart(_ pieChart: XYPieChart!, colorForSliceAt index: UInt) -> UIColor! {
        if pieChart == active_inactive_chart {
            if index ==  0 {
            return UIColor(red: 244/255, green: 179/255, blue:80/255 , alpha: 1.0)
                
            }
            else {
                return UIColor(red: 237/255, green: 101/255, blue:75/255 , alpha: 1.0)
                
            }
            
        }
        if pieChart == taskStatusPie {
            if index == 0 {
            return UIColor(red: 244/255, green: 196/255, blue:190/255 , alpha: 1.0)
            }
            else if index == 1 {
                return UIColor(red: 137/255, green: 200/255, blue:233/255 , alpha: 1.0)
            
            }
            else {
            return UIColor(red: 44/255, green: 62/255, blue:78/255 , alpha: 1.0)
                
            }
            
        }
        if Int(index) > self.colorArray.count {
        return self.colorArray.object(at: 0) as! UIColor
        }
        return self.colorArray.object(at: Int(index)) as! UIColor
        
    }
    func pieChart(_ pieChart: XYPieChart!, valueForSliceAt index: UInt) -> CGFloat {

        if pieChart == taskStatusPie {
           print(index)
           print(self.task_status_array.object(at: Int(index)))
           let val = self.task_status_array.object(at: Int(index)) as AnyObject
            
        return CGFloat(val as! NSNumber)
        }
        else if pieChart == visitChart {
        return CGFloat((self.visitArray.object(at: Int(index)) as AnyObject) as! NSNumber)
        }
        
        
        return CGFloat((self.active_inactive_array.object(at: Int(index)) as AnyObject) as! NSNumber)

    }
   
    
    func pieChart(_ pieChart: XYPieChart!, didSelectSliceAt index: UInt) {
        if pieChart == taskStatusPie {
            print("Value by selecting Pie Chart is \(self.task_status_array.object(at: Int(index)))")
            
            var value = String(format:"%.1f" ,Float(self.task_status_array.object(at: Int(index)) as! NSNumber))
            if index ==  0 {
                 self.task_color.backgroundColor = UIColor(red: 244/255, green: 196/255, blue:190/255 , alpha: 1.0)
                
                
                
                value = "Not stared (\(mainDao!.dashbaordTask!.notstarted!)) \(value) %"
            }
            else if index == 1{
                self.task_color.backgroundColor = UIColor(red: 137/255, green: 200/255, blue:233/255 , alpha: 1.0)
                
                
                
             value = "Completed (\(mainDao!.dashbaordTask!.completed!)) \(value) %"
            }
            else {
                self.task_color.backgroundColor = UIColor(red: 137/255, green: 200/255, blue:233/255 , alpha: 1.0)
                
                
                
                value = "Closed (\(mainDao!.dashbaordTask!.closed!)) \(value) %"
                
            }
        self.statuslbl.text = value
        //let color = self.colorArray.objectAtIndex(Int(index)) as! UIColor
        //self.statuslbl.backgroundColor = color
        //self.task_color.backgroundColor = color
            
        }
        if pieChart == active_inactive_chart {
            var value = String(round(self.active_inactive_array.object(at: Int(index)) as! Float))
            
            if index == 0 {
                var (h,m,s) = secondsToHoursMinutesSeconds(Int(mainDao!.dashbaordHours!.active!)!)
                

            value = "\(localisation.localizedString(key: "task.active")) (\(h):\(m):\(s)) \(value)%"
            }
            else {
                var (h,m,s) = secondsToHoursMinutesSeconds(Int(mainDao!.dashbaordHours!.inactive!)!)
                
//reports.inactive
                value = "\(localisation.localizedString(key: "reports.inactive")) (\(h):\(m):\(s)) \(value)%"

                
            }
            
            
            self.selectedActivelabel.text = value
            if index ==  0 {
                self.selectedActiveColor.backgroundColor = UIColor(red: 244/255, green: 179/255, blue:80/255 , alpha: 1.0)
                
            }
            else {
                self.selectedActiveColor.backgroundColor = UIColor(red: 237/255, green: 101/255, blue:75/255 , alpha: 1.0)
                
            }
            //let color = self.colorArray.objectAtIndex(Int(index)) as! UIColor
            //self.statuslbl.backgroundColor = color
            //self.selectedActiveColor.backgroundColor = color
            
        }
        if pieChart == visitChart {
            var value = String(round(self.visitArray.object(at: Int(index)) as! Float))
            let category = self.mainDao!.categories!.object(at: Int(index)) as! DashbaordCategories
             let color = self.colorArray.object(at: Int(index)) as! UIColor
            self.selectedVisitColor.backgroundColor = color
            self.selectedVisitlbl.text = "\(category.type_name!)(\(category.task_count!)) \(value)%"
            
        
        }
    }
    func secondsToHoursMinutesSeconds (_ seconds : Int) -> (Int, Int, Int) {
        
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func dateDeletced(_ date: Date, button: ADButton) {
        let formater : DateFormatter = DateFormatter()
        formater.dateFormat = "YYYY-MM-dd"
        formater.locale = Locale(identifier: "en_US")
        
        
        if self.whichDate == 0 {
            self.firstDate = date
            self.startDatebtn.setTitle(formater.string(from: self.firstDate!), for: UIControlState())
            
         }
        else {
            self.endDateBtn.setTitle(formater.string(from: date), for:UIControlState())
            self.secondDate = date
            
      
        }
    self.setupReportDownloder()
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
