//
//  SettingLocalNotification.swift
//  Shedule5.1
//
//  Created by CSergey on 06.04.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SettingLocalNotification: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var sswipe: UISwitch!
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.shedule")!
    let nc = NSNotificationCenter.defaultCenter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        finit()
    }
    
    @IBAction func swipeaction(sender: UISwitch) {
        if limitation().check{
        if defaults.objectForKey("SheduleSettingLocalNotification") != nil{
        if let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        {
            if settings.types.contains([.Alert, .Badge])
            {
                defaults.setObject(sender.on, forKey: "SheduleSettingLocalNotification")
                defaults.synchronize()
            }
            else
            {
                if sender.on == true{
                defaults.setObject(false, forKey: "SheduleSettingLocalNotification")
                defaults.synchronize()
                nc.postNotificationName("funcinstructionaboutnotLocalNotification", object: nil)
                sswipe.on = false
                }else{
                    defaults.setObject(sender.on, forKey: "SheduleSettingLocalNotification")
                    defaults.synchronize()
                }
                
                print("case 2")
            }
        }
        }
        if defaults.objectForKey("SheduleSettingLocalNotification") == nil{
            nc.postNotificationName("funcinstructionaboutLocalNotification", object: nil)
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            defaults.setObject(sender.on, forKey: "SheduleSettingLocalNotification")
            defaults.synchronize()
        }
    }else{
    nc.postNotificationName("funcalertinfoaboutlimits", object: nil, userInfo:["title": label.text!])
    sswipe.on = false
    }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
