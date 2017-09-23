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
    let defaults: UserDefaults = UserDefaults(suiteName: "group.com.shedule")!
    let nc = NotificationCenter.default
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        finit()
    }
    
    @IBAction func swipeaction(_ sender: UISwitch) {
        if limitation().check{
        if defaults.object(forKey: "SheduleSettingLocalNotification") != nil{
        if let settings = UIApplication.shared.currentUserNotificationSettings
        {
            if settings.types.contains([.alert, .badge])
            {
                defaults.set(sender.isOn, forKey: "SheduleSettingLocalNotification")
                defaults.synchronize()
            }
            else
            {
                if sender.isOn == true{
                defaults.set(false, forKey: "SheduleSettingLocalNotification")
                defaults.synchronize()
                nc.post(name: Notification.Name(rawValue: "funcinstructionaboutnotLocalNotification"), object: nil)
                sswipe.isOn = false
                }else{
                    defaults.set(sender.isOn, forKey: "SheduleSettingLocalNotification")
                    defaults.synchronize()
                }
                
                print("case 2")
            }
        }
        }
        if defaults.object(forKey: "SheduleSettingLocalNotification") == nil{
            nc.post(name: Notification.Name(rawValue: "funcinstructionaboutLocalNotification"), object: nil)
            let settings = UIUserNotificationSettings(types: [.alert, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            defaults.set(sender.isOn, forKey: "SheduleSettingLocalNotification")
            defaults.synchronize()
        }
    }else{
    nc.post(name: Notification.Name(rawValue: "funcalertinfoaboutlimits"), object: nil, userInfo:["title": label.text!])
    sswipe.isOn = false
    }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
