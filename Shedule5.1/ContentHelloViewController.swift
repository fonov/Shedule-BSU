//
//  ContentHelloViewController.swift
//  Shedule5.1
//
//  Created by CSergey on 20.03.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class ContentHelloViewController: UIViewController {
    
    var contindex: Int!
    var contarray: NSArray!
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.shedule")!
    let nc = NSNotificationCenter.defaultCenter()
    
    @IBOutlet weak var labelview: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imgview: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var startview: UIView!
    @IBOutlet weak var bttext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if contarray[0] as! String == "ContentViewController"{
            img.image = UIImage(named: String((contarray[1] as! NSArray)[0]))
            label.text = String((contarray[1] as! NSArray)[1])
            imgview.backgroundColor = (contarray[1] as! NSArray)[2] as? UIColor
            startview.hidden = true
        }
        if contarray[0] as! String == "StartViewController"{
            startview.hidden = false
        }
        let topBorder: CALayer = CALayer()
        topBorder.frame = CGRectMake(0.0, 0.0, view.frame.size.width, 2.0)
        topBorder.backgroundColor = UIColor.lightGrayColor().CGColor
        labelview.layer.addSublayer(topBorder)
        
        label.layer.shadowOffset = CGSize(width: 10, height: 20)
        label.layer.shadowOpacity = 0.3
        label.layer.shadowRadius = 6
        
        if let _ = defaults.objectForKey("hidehellovc"){
        bttext.setTitle("Скрыть", forState: .Normal)
        }else{
        bttext.setTitle("Начать пользоваться", forState: .Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startshedule(sender: AnyObject) {
        if let _ = defaults.objectForKey("hidehellovc"){
            nc.postNotificationName("funcreturnhellosetting", object: nil)
        }else{
            defaults.setObject(true, forKey: "hidehellovc")
            defaults.synchronize()
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc = mainStoryboard.instantiateViewControllerWithIdentifier("MainShedule") as! UITabBarController
            UIApplication.sharedApplication().keyWindow?.rootViewController = vc;
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
