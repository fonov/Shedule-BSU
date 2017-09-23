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
    let defaults: UserDefaults = UserDefaults(suiteName: "group.com.shedule")!
    let nc = NotificationCenter.default
    
    @IBOutlet weak var labelview: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imgview: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var startview: UIView!
    @IBOutlet weak var bttext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if contarray[0] as! String == "ContentViewController"{
            img.image = UIImage(named: String(describing: (contarray[1] as! NSArray)[0]))
            label.text = String(describing: (contarray[1] as! NSArray)[1])
            imgview.backgroundColor = (contarray[1] as! NSArray)[2] as? UIColor
            startview.isHidden = true
        }
        if contarray[0] as! String == "StartViewController"{
            startview.isHidden = false
        }
        let topBorder: CALayer = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: 2.0)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        labelview.layer.addSublayer(topBorder)
        
        label.layer.shadowOffset = CGSize(width: 10, height: 20)
        label.layer.shadowOpacity = 0.3
        label.layer.shadowRadius = 6
        
        if let _ = defaults.object(forKey: "hidehellovc"){
        bttext.setTitle("Скрыть", for: UIControlState())
        }else{
        bttext.setTitle("Начать пользоваться", for: UIControlState())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startshedule(_ sender: AnyObject) {
        if let _ = defaults.object(forKey: "hidehellovc"){
            nc.post(name: Notification.Name(rawValue: "funcreturnhellosetting"), object: nil)
        }else{
            defaults.set(true, forKey: "hidehellovc")
            defaults.synchronize()
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainShedule") as! UITabBarController
            UIApplication.shared.keyWindow?.rootViewController = vc;
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
