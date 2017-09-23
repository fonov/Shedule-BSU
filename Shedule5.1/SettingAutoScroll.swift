//
//  SettingAutoScroll.swift
//  Shedule5.1
//
//  Created by CSergey on 12.03.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SettingAutoScroll: UITableViewCell {

    let defaults: UserDefaults = UserDefaults(suiteName: "group.com.shedule")!
    let nc = NotificationCenter.default
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var scrollswitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        finit()
    }
    
    @IBAction func eventswitch(_ sender: UISwitch) {
        if limitation().check{
        if defaults.object(forKey: "SheduleSettingAutoScroll") == nil{
        nc.post(name: Notification.Name(rawValue: "funcinstructionaboutautoscroll"), object: nil)
        }
        defaults.set(sender.isOn, forKey: "SheduleSettingAutoScroll")
        defaults.synchronize()
        }else{
            nc.post(name: Notification.Name(rawValue: "funcalertinfoaboutlimits"), object: nil, userInfo:["title": label.text!])
            scrollswitch.isOn = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func finit(){
        label.text = "Автоматическая прокрутка расписания"
        if let flag = defaults.object(forKey: "SheduleSettingAutoScroll"){
            scrollswitch.isOn = flag as! Bool
        }else{
            scrollswitch.isOn = false
        }
    }

}
