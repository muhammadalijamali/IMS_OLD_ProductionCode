//
//  FullMapViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 2/6/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit
import MapKit
class FullMapViewController: UIViewController {

    @IBOutlet weak var drivingBtn: UIButton!
    var localisation : Localisation!
    @IBAction func drivingMethod(_ sender: AnyObject) {
        if taskDao != nil {
            if taskDao?.permitDao != nil {
                if taskDao!.permitDao!.lat != nil && taskDao!.permitDao!.lon != nil {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?saddr=\(self.appDel.user.lat),\(self.appDel.user.lon)&daddr=\(self.taskDao!.permitDao!.lat!),\(taskDao!.permitDao!.lon!)")!)
            //  self.openMapForPlace()
        } else {
            NSLog("Can't use Google Maps");
            let urlstr : String = "http://maps.google.com/maps?saddr=\(self.appDel.user.lat),\(self.appDel.user.lon)&daddr=\(self.taskDao!.permitDao!.lat),\(self.taskDao!.permitDao!.lon)"
            UIApplication.shared.openURL(URL(string: urlstr)!)
            
        }
                }// end of the lat/lon nill check
            }// end of the permitDao
            
        }// end of the task dao
        
        }
    
    @IBOutlet weak var fullMap: MKMapView!
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var taskDao : TaskDao?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.openMapForPlace()
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
        self.drivingBtn.setTitle(localisation.localizedString(key: "company.driving"), for: UIControlState())
        
        
        self.setupPin()
        
        // Do any additional setup after loading the view.
    }
    
    func setupPin(){
        
        var oneLoc : CLLocationCoordinate2D?
        
        if self.taskDao!.permitDao!.lat != nil && self.taskDao!.permitDao!.lat != "0.00000000" {
            let companylocation = CLLocationCoordinate2DMake((self.taskDao!.permitDao!.lat! as NSString).doubleValue, (self.taskDao!.permitDao!.lon! as NSString).doubleValue)
            // Drop a pin
            //print("Task priority \(task.priority)")
            
            let dropPin = ColorPointAnnotation()
            dropPin.task = self.taskDao
            dropPin.imageName = "pingreen"
            
            
            
            dropPin.coordinate = companylocation
            
            dropPin.title = self.taskDao!.company.company_name
            
            fullMap.addAnnotation(dropPin)
            
            
            
            
            oneLoc = companylocation
            
        }
        
        if oneLoc != nil {
            let region = MKCoordinateRegionMakeWithDistance(oneLoc!, 5000, 5000)
            self.fullMap.setRegion(region, animated: true)
        }
        
        
    }
    

    
    func openMapForPlace() {
        
        let lat1 : NSString = taskDao!.permitDao!.lat!  as NSString
        let lng1 : NSString = taskDao!.permitDao!.lon! as NSString
        
        
        let latitute:CLLocationDegrees =  lat1.doubleValue
        let longitute:CLLocationDegrees =  lng1.doubleValue
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        
        let mapItem = MKMapItem(placemark: placemark)
        if self.taskDao!.permitDao!.sub_venue != nil {
            mapItem.name = "\(self.taskDao!.permitDao!.sub_venue!)"
            
        }
        else {
        mapItem.name = "\(self.taskDao!.company.company_name!)"
        }
        mapItem.openInMaps(launchOptions: options)
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
