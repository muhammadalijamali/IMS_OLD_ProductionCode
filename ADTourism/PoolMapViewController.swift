//
//  PoolMapViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 6/13/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit
import MapKit
import CoreGraphics

class PoolMapViewController: UIViewController , MKMapViewDelegate , MainJsonDelegate, UIGestureRecognizerDelegate , UITextFieldDelegate {

    var localisation : Localisation!
    
    @IBOutlet weak var expiredOnlySwitch: UISwitch!
    @IBOutlet weak var expiredOnlylbl: UILabel!
    var expiredParameters : String = ""
    
    
    @IBAction func showOnlyExpired(_ sender: UISwitch) {
        if sender.isOn {
            self.expiredParameters = "&show_expired_licenses=yes"
        }
        else {
            self.expiredParameters = ""
            
        }
    }
    
    var urgency : Int = 0
    let LOWCOLOR : UIColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
    let MEDIUMCOLOR : UIColor =  UIColor(red:246/255 , green: 142/255, blue: 90/255, alpha: 1.0)
    let HIGHCOLOR : UIColor =  UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
    
    
    @IBAction func showPriority(_ sender: AnyObject) {
    
        let alert = SCLAlertView()
        alert.showCloseButton = false
        //  alert.showCircularIcon = false
        
        let high = alert.addButton(self.localisation.localizedString(key: "tasks.high"),tag: 150 , action: {
           
            self.urgency = 3 // NON DTCM
            //self.typeLbl.text = self.localisation.localizedString(key: "tasks.high")
            self.priorityBtn.setTitle(self.localisation.localizedString(key: "tasks.high"), for: UIControlState())
            self.priorityBtn.layer.borderColor = self.HIGHCOLOR.cgColor
            self.priorityBtn.layer.borderWidth = 1.0
            self.priorityBtn.setTitleColor(UIColor.black, for: UIControlState())
            if self.circle != nil {
                self.drawCircleMethod(self)
            }
            else if self.polygon != nil {
               
            self.createPolyline()
            
            }
            
        } )
        
        high.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
        
        let mediumColor = UIColor(red:246/255 , green: 142/255, blue: 90/255, alpha: 1.0)
        
        alert.addButton(self.localisation.localizedString(key: "tasks.medium"),tag : 100, action: {
           
            self.urgency = 2 // NON DTCM
            //self.priorityBtn.text = self.localisation.localizedString(key: "tasks.medium")
            self.priorityBtn.layer.borderColor = self.MEDIUMCOLOR.cgColor
            self.priorityBtn.layer.borderWidth = 1.0
            self.priorityBtn.setTitleColor(UIColor.black, for: UIControlState())
            
            self.priorityBtn.setTitle(self.localisation.localizedString(key: "tasks.medium"), for: UIControlState())
            if self.circle != nil {
                self.drawCircleMethod(self)
            }
            else if self.polygon != nil {
                
                self.createPolyline()
            }
            
            
        } )
        
        
        
        
        let low = alert.addButton(self.localisation.localizedString(key: "tasks.low"),tag: 50 ,action: {
           
            self.urgency =  1 // DTCM
            //self.typeLbl.text = self.localisation.localizedString(key: "tasks.low")
            self.priorityBtn.layer.borderColor = self.LOWCOLOR.cgColor
            self.priorityBtn.layer.borderWidth = 1.0
            self.priorityBtn.setTitleColor(UIColor.black, for: UIControlState())
            
            self.priorityBtn.setTitle(self.localisation.localizedString(key: "tasks.low"), for: UIControlState())
            if self.circle != nil {
                self.drawCircleMethod(self)
            }
            else if self.polygon != nil {
                
                self.createPolyline()
            }
            
        } )
        
        low.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
        
        
        
        
        
        // alert.ad
        
        alert.addButton(localisation.localizedString(key: "questions.cancel"),tag:250 , action: {
           
            
        })
        
        alert.showInfo(localisation.localizedString(key: "tasks.priority"), subTitle: "")
    }
    
    @IBOutlet weak var priorityBtn: UIButton!
    
    @IBOutlet weak var kmSliderView: UIView!
    @IBOutlet weak var reddot: UIImageView!
    var point_1 :CLLocationCoordinate2D?
    
    var point_2 :CLLocationCoordinate2D?
    
    var point_3 :CLLocationCoordinate2D?
    
    var point_4 :CLLocationCoordinate2D?
    
    @IBOutlet weak var taskListBtn: UIButton!
    @IBAction func showTaskList(_ sender: AnyObject) {
    self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBOutlet weak var taskCountlbl: UILabel!
    let del : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func zoomSliderMethod(_ sender: UISlider) {
        /*
        var region:MKCoordinateRegion  = self.locationMapView.region
        var span:MKCoordinateSpan  = locationMapView.region.span
        
        if self.oldValue < Double(sender.value) {
        span.latitudeDelta/=Double(sender.value);
        span.longitudeDelta/=Double(sender.value);
        }
        else {
            span.latitudeDelta*=Double(sender.value);
            span.longitudeDelta*=Double(sender.value);
            
        }
        region.span=span;
        locationMapView.setRegion(region, animated: true)
        self.oldValue = Double(sender.value)
        */
        
        let miles = Double(sender.value)
        let delta = miles / 80.0
        
        
        var currentRegion = self.locationMapView.region
        currentRegion.span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        self.locationMapView.region = currentRegion
        
        //travelRadius.text = "\(Int(round(miles))) miles"
        
        //let (lat, long) = (currentRegion.center.latitude, currentRegion.center.longitude)
       // currentLocationLabel.text = "Current location: \(lat), \(long))"
        
        
        
        
    }
    @IBOutlet weak var zoomSlider: UISlider!
    @IBOutlet weak var areaTextField: UITextField!
    @IBOutlet weak var activityCodeTextField: BiggerMarginTextField!
    @IBOutlet weak var sliderView: UISlider!
    var oldValue : Double = 0.0
    @IBOutlet weak var locationMapView: MKMapView!
    var allTasks : NSMutableArray = NSMutableArray()
    
    var circle:MKCircle?
    var radius : Float = 1.0
    var originalPoint : CGPoint?
    var isAllowedToMove : Bool = false
    
    var cgPoint : CLLocationCoordinate2D?
    
    var polygonConstact : Double =  2/110.0
    
    var polygon : MKPolygon?
    

    
    var drawWhat : Int = 0  // 1 for cirlce 2 for polygon
    
    @IBAction func moveSlider(_ sender: AnyObject) {
        
        print("Slider value \(self.sliderView.value)")
        self.locationMapView.removeAnnotations(self.locationMapView.annotations)
        
        self.radius = round(self.sliderView.value)
        //self.radius = self.sliderView.value
        
        self.kmlbl.text = "\(self.radius) km"
        
        if drawWhat == 1 {
        self.drawCircleMethod(self.view)
        }
        else if drawWhat == 2{
         self.polygonConstact = Double(self.sliderView.value / 110)
            
        self.createPolyline()
         self.setupSquareDownloader()
        }
       
        
        
    }
    
    
    @IBOutlet weak var kmlbl: UILabel!
    
    func setupPins(){
        
               var oneLoc : CLLocationCoordinate2D?
        
        for item in self.allTasks {
            if let task = item as? TaskDao {
                if task.company_lat != nil && task.company_lon != nil {
                }
                else {
                    continue
                }
                if (task.company_lat! as NSString).intValue >= -84 && (task.company_lon! as NSString).intValue <= 84 && (task.company_lat! as NSString).intValue >= -179 && (task.company_lon! as NSString).intValue <= 179{
                    
                    
                    if task.company_lat != nil && task.company_lon != "0.00000000" {
                        let companylocation = CLLocationCoordinate2DMake((task.company_lat! as NSString).doubleValue, (task.company_lon! as NSString).doubleValue)
                        // Drop a pin
                        //print("Task priority \(task.priority)")
                        
                        let dropPin = ColorPointAnnotation()
                        dropPin.task = task
                        dropPin.imageName = "pingreen"
                        //  print("Lat: \(task.company.lat)")
                        // print("Lon: \(task.company.lon)")
                        
                        
                        
                        
                        dropPin.coordinate = companylocation
                        
                        dropPin.title = task.company_name
                        
                        locationMapView.addAnnotation(dropPin)
                        
                        
                        
                        
                        oneLoc = companylocation
                        
                    }
                }
            }
        }
        
        if oneLoc != nil {
            
          //  let region = MKCoordinateRegionMakeWithDistance(oneLoc!, 9000, 9000)
            
          //  self.locationMapView.setRegion(region, animated: true)
        }
        
        
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        let reuseId = "pin"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if anView == nil {
            anView = MKAnnotationView(annotation:annotation , reuseIdentifier: reuseId)
        }
        
        
        let deleteButton = ADButton(type: UIButtonType.contactAdd)
        deleteButton.frame.size.width = 44
        deleteButton.frame.size.height = 44
        
        let detailButton = ADButton(type: UIButtonType.infoDark)
        detailButton.frame.size.width = 44
        
        
        detailButton.frame.size.height = 44
        
        anView!.leftCalloutAccessoryView = detailButton
        
        if let ann = annotation as? ColorPointAnnotation {
            
            deleteButton.annotation = annotation
            deleteButton.taskDao = ann.task
            deleteButton.addTarget(self, action: #selector(PoolMapViewController.grabTheTask(_:)), for: UIControlEvents.touchUpInside)
            
            
            detailButton.taskDao = ann.task
            detailButton.addTarget(self, action: #selector(PoolMapViewController.showCompanyDetail(_:)), for: UIControlEvents.touchUpInside)
            

            //deleteButton.backgroundColor = UIColor.redColor()
            
        }
        
        anView!.rightCalloutAccessoryView = deleteButton
        
        
        if let anon = annotation as? ColorPointAnnotation {
            //print("setting up print")
            anView!.image =  UIImage(named: anon.imageName)
            if anon.task?.priority == "3" {
                anView!.image = UIImage(named: "pinred")
                
                //  pinView.pinColor = MKPinAnnotationColor.Red
                
            }
            else if anon.task?.priority == "2" {
                anView!.image = UIImage(named: "pinorange")
                
                // pinView.pinColor = MKPinAnnotationColor.Green
            }
            else if anon.task?.priority == "1"{
                anView!.image = UIImage(named: "pingreen")
                
                
                //   pinView.pinColor = MKPinAnnotationColor.Purple
                
            }
            else {
                //  pinView.pinColor = MKPinAnnotationColor.Red
                
                
            }
        }
        
        
        // anView = pinView
        anView!.canShowCallout = true
        
        
        return anView
    }

    
    @objc func showCompanyDetail(_ sender : ADButton){
    
        self.del.fromHistoryToResult = 1
        
        let cnt = self.storyboard!.instantiateViewController(withIdentifier: "cnt_companydetail") as! CompanyViewController
      let history = TaskHistoryDao()
        history.company_id = sender.taskDao.company_id
        
        cnt.history = history
        
        
        self.navigationController?.pushViewController(cnt, animated: true)
        
        //cnt_companydetail
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationMapView.delegate = self
        self.locationMapView.delegate = self
        self.title = ""
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(PoolMapViewController.respondPanGesture(_:)))
        self.locationMapView.addGestureRecognizer(gesture)
        
        self.localisation = Localisation()
        
        if self.del.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
            
            //  self.userTextField.textAlignment = NSTextAlignment.Right
            // self.passwordField.textAlignment = NSTextAlignment.Right
            
            
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            
            
        }
        self.priorityBtn.setTitle(localisation.localizedString(key: "tasks.priority"), for: UIControlState())
        self.activityCodeTextField.placeholder = localisation.localizedString(key: "tasks.activtiycode")
        self.areaTextField.placeholder = localisation.localizedString(key: "company.area")
        self.expiredOnlylbl.text = localisation.localizedString(key: "pool.expired")

        //self.sliderView.set
 //       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PoolMapViewController.showSingleTap(_:)))
 //       self.locationMapView.addGestureRecognizer(tapGesture)
//        let loc : CLLocationCoordinate2D? = CLLocationCoordinate2D(
//            latitude: locationMapView.userLocation.coordinate.latitude,
//            longitude: locationMapView.userLocation.coordinate.longitude)
//    
//        
//
        
        if self.del.userLocation != nil {
            let region = MKCoordinateRegionMakeWithDistance( self.del.userLocation!, 5000, 5000)
            self.locationMapView.setRegion(region, animated: true)
        }
        
       self.taskCountlbl.text =  "\(self.del.taskCount)"
        self.view.bringSubview(toFront: self.zoomSlider)
        
        
        
        // Do any additional setup after loading the view.
    }
    func showSingleTap(_ sender : UITapGestureRecognizer){
    print("Tap")
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if drawWhat == 1 {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor(red: 0, green: 0, blue: 252, alpha: 1.0)
            circle.fillColor = UIColor(red: 0, green: 0, blue: 252, alpha: 0.1)
            circle.lineWidth = 1
            //print("rendering circle done")
            return circle
        }
        else {
        let polygon = MKPolygonRenderer(overlay: overlay)
            polygon.strokeColor = UIColor(red: 0, green: 0, blue: 252, alpha: 1.0)
            polygon.fillColor = UIColor(red: 0, green: 0, blue: 252, alpha: 0.1)
            polygon.lineWidth = 1
           // print("rendering polygon done")

            return polygon
            
        }
        
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    fileprivate var mapChangedFromUserInteraction = false
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        if (mapChangedFromUserInteraction) {
            // user changed map region
            print("sdsd")
        }
    }
    
    fileprivate func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = self.locationMapView.subviews[0]
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizerState.began || recognizer.state == UIGestureRecognizerState.ended ) {
                    if self.circle != nil && self.drawWhat == 1 {
                    let point = recognizer.location(in: self.locationMapView)
                    let tap : CLLocationCoordinate2D = self.locationMapView.convert(point, toCoordinateFrom: self.locationMapView)
                    let tapLocation : CLLocation = CLLocation(latitude: tap.latitude, longitude: tap.longitude)
                    
                    // got CLLocation
                    
                    let originalCoordinate : CLLocationCoordinate2D = self.circle!.coordinate   // get old coordinates
                    
                    let originalLocation : CLLocation = CLLocation(latitude: originalCoordinate.latitude, longitude: originalCoordinate.longitude)
                    if tapLocation.distance(from: originalLocation) > self.circle!.radius {
                        self.locationMapView.isScrollEnabled = true
                        print("Away from the radius \(self.circle!.radius) and \(tapLocation.distance(from: originalLocation))")
                        //self.isAllowedToMove = false
                    }
                    else if tapLocation.distance(from: originalLocation) < circle!.radius{
                        self.isAllowedToMove = true
                        self.originalPoint = self.locationMapView.convert(originalCoordinate, toPointTo: recognizer.view)
                        print("In the circle")
                        self.locationMapView.isScrollEnabled = false
                    }
                    
                    }
                    else if drawWhat == 2 && self.polygon != nil {
                        let touchLocation = recognizer.location(in: self.locationMapView)
                        
                        let locationCoordinate = locationMapView.convert(touchLocation, toCoordinateFrom: self.locationMapView)
                        
                        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
                        
                        
                            
                            let polygonView = MKPolygonRenderer(overlay: self.polygon as! MKOverlay)
                            
                            let mapPoint = MKMapPointForCoordinate(locationCoordinate)
                            
                            let circlePoint = polygonView.point(for: mapPoint)
                            
                          //  let mapCoordinateIsInCircle : Bool = CGPathContainsPoint(polygonView.path, nil, circlePoint, false)
                        let mapCoordinateIsInCircle : Bool = polygonView.path.contains(circlePoint)
                        
                        
                        
                        
                            if mapCoordinateIsInCircle{
                                print("Yes, is within index --> ")
                                self.locationMapView.isScrollEnabled = false
                            }
                            else{
                                print("NO")
                                self.locationMapView.isScrollEnabled = true
                            }
                                         }
                    return true
                }
            }
        }
        return false
    }


    
    @objc func respondPanGesture(_ sender : UIPanGestureRecognizer){
       // self.locationMapView.scrollEnabled = false
//        let panView : MKMapView? = sender.view as? MKMapView
//        if panView == nil {
//        
//        print("Not PanView")
//        }
//        else {
//            for overlay in panView!.overlays {
//            //  let v = panView.viewfor
//            }
//            print("Pan View")
//        }
//        
        //print("Draw What \(self.drawWhat)")
       // print("Pan is working")
        if self.drawWhat == 1 && self.circle != nil {
        if sender.state == UIGestureRecognizerState.began{
                       let point = sender.location(in: self.locationMapView)
            if self.isAllowedToMove == true {
            self.locationMapView.removeAnnotations(self.locationMapView.annotations)
            }
            
            // CGPoint , where it is panned
            
           // print("Begin")
            //self.locationMapView.scrollEnabled = true
            // as its pan so stop the scrolling
            let tap : CLLocationCoordinate2D = self.locationMapView.convert(point, toCoordinateFrom: self.locationMapView)
            //convert locationMapView to CLLocationCoordinate2D
            
            let tapLocation : CLLocation = CLLocation(latitude: tap.latitude, longitude: tap.longitude)
            
            // got CLLocation
            
            let originalCoordinate : CLLocationCoordinate2D = self.circle!.coordinate   // get old coordinates 
            
            let originalLocation : CLLocation = CLLocation(latitude: originalCoordinate.latitude, longitude: originalCoordinate.longitude)
            // get original location from CLLocationCoordinate2D
            
              self.originalPoint = self.locationMapView.convert(originalCoordinate, toPointTo: sender.view)
              // get originalpoint from 
            
            print("Circle radius \(self.circle!.radius) ")
            if tapLocation.distance(from: originalLocation) > self.circle!.radius {
                self.locationMapView.isScrollEnabled = true
                print("Away from the radius \(self.circle!.radius) and \(tapLocation.distance(from: originalLocation))")
                //self.isAllowedToMove = false
                self.isAllowedToMove = false
            }
            else if tapLocation.distance(from: originalLocation) < circle!.radius{
                self.originalPoint = self.locationMapView.convert(originalCoordinate, toPointTo: sender.view)
                self.isAllowedToMove = true
                self.locationMapView.isScrollEnabled = false
                //sender.enabled = false
                //sender.enabled = true
            }
           
        } // end of the begin state
        if (sender.state == UIGestureRecognizerState.changed) {
           if self.isAllowedToMove {
                print("Changed")
                
                let translation = sender.translation(in: sender.view)
                let newPoint = CGPoint(x: originalPoint!.x + translation.x, y: originalPoint!.y + translation.y)
                let newCoordinate = locationMapView.convert(newPoint, toCoordinateFrom: sender.view)
                self.cgPoint = newCoordinate
                //let circle2 = MKCircle(centerCoordinate: newCoordinate, radius: radius)
                let rad = CLLocationDistance(self.radius * 1000)
                
                let circle2 = MKCircle(center: newCoordinate, radius: rad)
            
                self.locationMapView.add(circle2)
                self.locationMapView.remove(circle!)
                self.circle = circle2
            

            
                // self.locationMapView.scrollEnabled = true
            } // end if isAllowedToMove
            }
            if sender.state == UIGestureRecognizerState.ended && isAllowedToMove == true {
          
                print("Endededdedddd the circle")
            print("Radius \(circle?.radius)")
            //self.mapViewRegionDidChangeFromUserInteraction()
            print("lat/lon \(circle!.coordinate.latitude)")
            print("lat/lon \(circle!.coordinate.longitude)")
            self.setupCircleDownloader()
            }
        }
        else {
            if sender.state == UIGestureRecognizerState.began{
                let point = sender.location(in: self.locationMapView)
                print("Begin")
                //self.locationMapView.scrollEnabled = false
                let tap : CLLocationCoordinate2D = self.locationMapView.convert(point, toCoordinateFrom: self.locationMapView)
                let tapLocation : CLLocation = CLLocation(latitude: tap.latitude, longitude: tap.longitude)
                let originalCoordinate : CLLocationCoordinate2D = self.cgPoint!
                
                let originalLocation : CLLocation = CLLocation(latitude: originalCoordinate.latitude, longitude: originalCoordinate.longitude)
                self.originalPoint = self.locationMapView.convert(originalCoordinate, toPointTo: sender.view)
                self.originalPoint = self.locationMapView.convert(originalCoordinate, toPointTo: sender.view)
                
                let touchLocation = sender.location(in: self.locationMapView)
                
                let locationCoordinate = locationMapView.convert(touchLocation, toCoordinateFrom: self.locationMapView)
                
                print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
                
                
                
                let polygonView = MKPolygonRenderer(overlay: self.polygon as! MKOverlay)
                
                let mapPoint = MKMapPointForCoordinate(locationCoordinate)
                
                let circlePoint = polygonView.point(for: mapPoint)
                
                //let mapCoordinateIsInCircle : Bool = CGPathContainsPoint(polygonView.path, nil, circlePoint, false)
                let mapCoordinateIsInCircle : Bool = polygonView.path.contains(circlePoint)
                
                
                if mapCoordinateIsInCircle{
                    print("Yes, is within index --> ")
                    self.isAllowedToMove = true
                    self.locationMapView.isScrollEnabled = false

                    
                }
                else{
                    print("NO")
                    self.locationMapView.isScrollEnabled = true
                    self.isAllowedToMove = false

                }

                

//                if tapLocation.distanceFromLocation(originalLocation) > self.circle!.radius {
//                    self.locationMapView.scrollEnabled = false
//                    //self.isAllowedToMove = false
//                }
//                else if tapLocation.distanceFromLocation(originalLocation) < circle!.radius{
//                    self.originalPoint = self.locationMapView.convertCoordinate(originalCoordinate, toPointToView: sender.view)
//                    self.isAllowedToMove = true
//                }
            
            } // end of the begin state
            else if (sender.state == UIGestureRecognizerState.changed) {
                 if self.isAllowedToMove {
               // print("Changed")
                //self.locationMapView.scrollEnabled = false

                let translation = sender.translation(in: sender.view)
                let newPoint = CGPoint(x: originalPoint!.x + translation.x, y: originalPoint!.y + translation.y)
                let newCoordinate = locationMapView.convert(newPoint, toCoordinateFrom: sender.view)
                self.cgPoint = newCoordinate
                //let circle2 = MKCircle(centerCoordinate: newCoordinate, radius: radius)
//                let rad = CLLocationDistance(self.radius * 1000)
//                
//                let circle2 = MKCircle(centerCoordinate: newCoordinate, radius: rad)
//                
//                self.locationMapView.addOverlay(circle2)
//                self.locationMapView.removeOverlay(circle!)
//                self.circle = circle2
//                // self.locationMapView.scrollEnabled = true
                    self.createPolyline()
                    
                } // end if isAllowedToMove
                
                       }
             if sender.state == UIGestureRecognizerState.ended {
                self.setupSquareDownloader()

            }
            
        } // end of  the what else
        
        
        if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.failed || sender.state == UIGestureRecognizerState.cancelled {
            //self.locationMapView.scrollEnabled = false
            self.isAllowedToMove = false
        }
    }

    
    
    @IBAction func squareMethod(_ sender: AnyObject) {
//        let center = CLLocationCoordinate2D(
//            latitude: locationMapView.userLocation.coordinate.latitude,
//            longitude: locationMapView.userLocation.coordinate.longitude)
//
//        let rad = CLLocationDistance(10000)
//        
//        
//        self.circle = MKCircle(centerCoordinate: center, radius: rad)
//        self.locationMapView.addOverlay(circle!)
 
        
        self.kmSliderView.isHidden = false
        
        self.createPolyline()
        self.setupSquareDownloader()
        print("Polygon is drawn")
        
    }
    
    @IBAction func clearMethod(_ sender: AnyObject) {
        if self.circle != nil {
        self.locationMapView.remove(self.circle!)
        }
        if self.polygon != nil {
        self.locationMapView.remove(self.polygon!)
        }
         self.kmSliderView.isHidden = true
            self.radius = 1
               self.circle = nil
          self.sliderView.value = 2.0
         self.locationMapView.isScrollEnabled = true
         self.kmlbl.text = "2km"
         self.cgPoint = nil
        self.activityCodeTextField.text = ""
        self.activityCodeTextField.resignFirstResponder()
        
        self.areaTextField.text = ""
        self.allTasks = NSMutableArray()
        self.locationMapView.removeAnnotations(self.locationMapView.annotations)
        self.drawWhat = 0
        self.urgency = 0
        self.del.selectedUrgency = 0
        self.priorityBtn.setTitle(localisation.localizedString(key: "tasks.priority"), for: UIControlState())
        self.priorityBtn.layer.borderColor = UIColor.clear.cgColor
        
        
    }
    
    func setEnglishNumbersFromArabic()-> String{
        var searchStr : NSString = self.activityCodeTextField.text! as NSString
        
        searchStr  = searchStr.replacingOccurrences(of: "١", with: "1") as NSString
        searchStr = searchStr.replacingOccurrences(of: "٢", with: "2") as NSString
        searchStr = searchStr.replacingOccurrences(of: "٣", with: "3") as NSString
        searchStr = searchStr.replacingOccurrences(of: "٤", with: "4") as NSString
        searchStr = searchStr.replacingOccurrences(of: "٥", with: "5") as NSString
        searchStr = searchStr.replacingOccurrences(of: "٦", with: "6") as NSString
        searchStr = searchStr.replacingOccurrences(of: "٧", with: "7") as NSString
        searchStr = searchStr.replacingOccurrences(of: "٨", with: "8") as NSString
        searchStr = searchStr.replacingOccurrences(of: "٩", with: "9") as NSString
        searchStr = searchStr.replacingOccurrences(of: "٠", with: "0") as NSString
         return searchStr as String
        
    }
    
    func createPolyline() {
        if self.circle != nil {
            self.locationMapView.remove(self.circle!)
        }
        if self.cgPoint != nil {
            
        }
        else {
            self.cgPoint = CLLocationCoordinate2D(
                latitude: locationMapView.userLocation.coordinate.latitude,
                longitude: locationMapView.userLocation.coordinate.longitude)
        }
        self.drawWhat = 2
         //self.locationMapView.scrollEnabled = false

        //let point1 = CLLocationCoordinate2DMake(-73.761105, 41.017791);
        
        let point1 = CLLocationCoordinate2DMake(cgPoint!.latitude, cgPoint!.longitude);
       // print("Point 1 \(point1)")
        //let point2 = CLLocationCoordinate2DMake(-73.760701, 41.019348);
        let point2 = CLLocationCoordinate2DMake(cgPoint!.latitude , cgPoint!.longitude + polygonConstact);
       //   print("Point 2 \(point2)")
        
        let point3 = CLLocationCoordinate2DMake(cgPoint!.latitude + polygonConstact, cgPoint!.longitude + polygonConstact);
     //   let point3 = CLLocationCoordinate2DMake(-73.757201, 41.019267);
        // print("Point 3 \(point3)")
        
       // let point4 = CLLocationCoordinate2DMake(-73.757482, 41.016375);
          let point4 = CLLocationCoordinate2DMake(cgPoint!.latitude + polygonConstact,cgPoint!.longitude);
        
        //print("Point 4 \(point4)")
        //let point5 = CLLocationCoordinate2DMake(-73.761105, 41.017791);
        let point5 = CLLocationCoordinate2DMake(locationMapView.userLocation.coordinate.latitude, locationMapView.userLocation.coordinate.longitude);
        self.drawWhat = 2
        self.point_1 = point1
        self.point_2 = point2
        self.point_3 = point3
        self.point_4 = point4
        
        
        var points: [CLLocationCoordinate2D]
        points = [point1, point2, point3, point4]
        //points = [point4, point3, point2, point1]
        
        
        //let geodesic = MKGeodesicPolyline(coordinates: &points[0], count: 5)
        if self.polygon != nil {
        self.locationMapView.remove(self.polygon!)
        }
        self.polygon = MKPolygon(coordinates: &points, count: 4)
        self.locationMapView.add(self.polygon!)
        //self.locationMapView.addOverlay(geodesic)
        
//        UIView.animateWithDuration(1.5, animations: { () ->
//            let span = MKCoordinateSpanMake(0.01, 0.01)
//            let region1 = MKCoordinateRegion(center: point1, span: span)
//            self.locationMapView.setRegion(region1, animated: true)
//        })
    
    }
    
    
    @IBOutlet weak var squareBtn: UIButton!
    
    @IBAction func drawCircleMethod(_ sender: AnyObject) {
        if self.circle != nil {
        self.locationMapView.remove(self.circle!)
        self.locationMapView.removeAnnotations(self.locationMapView.annotations)
        }
        if self.polygon != nil {
            self.locationMapView.remove(self.polygon!)
        }
        
        self.kmSliderView.isHidden = false
        self.locationMapView.isScrollEnabled = false
        self.drawWhat = 1
        let center : CLLocationCoordinate2D?
        if self.cgPoint != nil {
            center = self.cgPoint
        }
        else {
         center = CLLocationCoordinate2D(
            latitude: locationMapView.userLocation.coordinate.latitude,
            longitude: locationMapView.userLocation.coordinate.longitude)
        }
        
        let rad = CLLocationDistance(self.radius * 1000)
        
        self.circle = MKCircle(center: center!, radius: rad)
        self.locationMapView.add(circle!)
        self.setupCircleDownloader()
        print("Circle is drawn")
        
    }
    func setupCircleDownloader(){
        if Reachability.connectedToNetwork() {
            print("Radius \(circle?.radius)")
            //self.del.showIndicator = 0
             self.locationMapView.removeAnnotations(self.locationMapView.annotations)
            print("lat/lon \(circle!.coordinate.latitude)")
            print("lat/lon \(circle!.coordinate.longitude)")
            
            
            let poolURL = Constants.baseURL+"searchPoolTaskByByRadius?radius=\(circle!.radius - 200)&lat=\(circle!.coordinate.latitude)&lng=\(circle!.coordinate.longitude)&company_address=\(self.areaTextField.text!)&activity_code=\(self.setEnglishNumbersFromArabic())&priority=\(self.urgency)&inspectorID=\(self.del.user.user_id!)\(self.expiredParameters)"
            
            
            //let poolURL = Constants.baseURL + "getPoolTasksByActivityCode?activity_id=" + self.del.selectedActivityCode!.id!
            
            print(poolURL)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(poolURL, idn: "circle")
            
            
            
        } // end of the Reachability

        
    }
    
    func setupSquareDownloader(){
        if Reachability.connectedToNetwork()  && self.point_1 != nil{
           // print("Radius \(circle?.radius)")
            //self.del.showIndicator = 0
            self.locationMapView.removeAnnotations(self.locationMapView.annotations)
           // print("lat/lon \(circle!.coordinate.latitude)")
           // print("lat/lon \(circle!.coordinate.longitude)")
            
            
            let poolURL = Constants.baseURL + "searchPoolTaskByBySquare?swLat=\(self.point_3!.latitude)&seLat=\(self.point_1!.latitude)&swLng=\(self.point_1!.longitude)&seLng=\(self.point_3!.longitude)&company_address=\(self.areaTextField.text!)&activity_code=\(self.setEnglishNumbersFromArabic())&priority=\(self.urgency)&inspectorID=\(self.del.user.user_id!)\(self.expiredParameters)"
            
            
            //let poolURL = Constants.baseURL + "getPoolTasksByActivityCode?activity_id=" + self.del.selectedActivityCode!.id!
            
           // print(poolURL)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(poolURL, idn: "circle")
            
            
            
        } // end of the Reachability
        
        
    }

    
    @objc func grabTheTask(_ sender : ADButton) {
        if sender.taskDao.task_id != nil  {
            if Reachability.connectedToNetwork() {
                let poolURL = Constants.baseURL + "saveInspectorGrabbedTask?inspector_id=\(self.del.user.user_id!)&task_id=\(sender.taskDao.task_id!)"
            
                //let poolURL = Constants.baseURL + "getPoolTasksByActivityCode?activity_id=" + self.del.selectedActivityCode!.id!
                self.del.showIndicator = 1
                
                print(poolURL)
                
                let downloader : DataDownloader = DataDownloader()
                downloader.delegate = self
                downloader.startDownloader(poolURL, idn: "grab")
                self.locationMapView.removeAnnotation(sender.annotation!)
                
                
            } // end of the Reachability
            
        }
        
    }

    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "circle" {
          //  let str : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
          //  print(str)
        let parser = JsonParser()
        self.allTasks = parser.poolParseTasks(data)
        self.setupPins()
        //self.del.showIndicator = 0
        }
        else if identity == "grab"{
       // self.setupCircleDownloader()
        self.del.taskCount += 1
            UIView.animate(withDuration: 0.5 ,
                                       animations: {
                                        self.taskCountlbl.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
                                        self.reddot.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
                                        

                                        
                                        
                },
                                       completion: { finish in
                                        UIView.animate(withDuration: 0.3, animations: {
                                            self.taskCountlbl.transform = CGAffineTransform.identity
                                            
                                            self.reddot.transform = CGAffineTransform.identity
                                            
                                        })
            })
           SessionDataDownloader().setupPermitURL()
            
         self.taskCountlbl.text = "\(self.del.taskCount)"
        }
    }
    @IBOutlet weak var drawCircle: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:-
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK:- UITEXTField delgate methods
    func setupOnlyAddressDownloader(){
        if Reachability.connectedToNetwork() {
            self.allTasks = NSMutableArray()
            self.locationMapView.removeAnnotations(self.locationMapView.annotations)
            
            let poolURL = Constants.baseURL+"searchPoolTaskByByRadius?radius=&lat=&lng=&company_address=\(self.areaTextField.text!)&activity_code=\(self.setEnglishNumbersFromArabic())&priority=\(self.urgency)&inspectorID=\(self.del.user.user_id!)"
            
            //let poolURL = Constants.baseURL + "getPoolTasksByActivityCode?activity_id=" + self.del.selectedActivityCode!.id!
            
            print(poolURL)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(poolURL, idn: "circle")
            
            
            
        } // end of the Reachability
        

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if drawWhat == 0 {
            //self.activityCodeTextField.resignFirstResponder()
            textField.resignFirstResponder()
        self.setupOnlyAddressDownloader()
            
        }
        else if drawWhat == 1 {
            self.activityCodeTextField.resignFirstResponder()
            
        self.drawCircleMethod(self)
        }
        else if drawWhat == 2 {
        self.createPolyline()
            self.activityCodeTextField.resignFirstResponder()
            
         self.setupSquareDownloader()
        }
        
        
        
        return  true
        
    }
    

}
