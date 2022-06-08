//
//  EnlargeIncidentImageViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 6/2/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

protocol IncidentMediaDelegate {
    func deleteImage();
    
}
class EnlargeIncidentImageViewController: UIViewController {
    var makeEnlargedImage : UIImage?
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var del : IncidentMediaDelegate?
    
    
    @IBAction func closeMethod(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var enlargedImage: UIImageView!
    var enlargeImage : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.appDel.showIncidentMedia == 1  {
         self.deleteBtn.isHidden = true
        }
//        if self.appDel.incidentEnlargeImage != nil {
//        self.enlargedImage.image = self.appDel.incidentEnlargeImage
//        }
        // Do any additional setup after loading the view.
        if enlargeImage != nil {
        self.enlargedImage.image = enlargeImage
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
       // self.viewWillAppear(animated)
       // self.view.superview!.layer.cornerRadius = 0;
        
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteImageMethod(_ sender: AnyObject) {
    self.appDel.incidentEnlargeImage = nil
        self.del?.deleteImage()
    self.dismiss(animated: true, completion: nil)
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
