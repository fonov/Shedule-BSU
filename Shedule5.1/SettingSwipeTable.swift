//
//  SettingSwipeTable.swift
//  Shedule5.1
//
//  Created by CSergey on 13.03.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SettingSwipeTable: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var swipec: UISwitch!
    let defaults: UserDefaults = UserDefaults(suiteName: "group.com.shedule")!
    let nc = NotificationCenter.default
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        finit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func swipeevent(_ sender: UISwitch) {
        if limitation().check{
        if defaults.object(forKey: "SheduleSettingSwipeTable") == nil{
        nc.post(name: Notification.Name(rawValue: "funcinstructionaboutswitch"), object: nil)
        }
        defaults.set(sender.isOn, forKey: "SheduleSettingSwipeTable")
        defaults.synchronize()
        }else{
            nc.post(name: Notification.Name(rawValue: "funcalertinfoaboutlimits"), object: nil, userInfo:["title": label.text!])
            swipec.isOn = false
        }
    }
    
    func finit(){
        label.text = "Быстрое переключение недель"
        if let flag = defaults.object(forKey: "SheduleSettingSwipeTable"){
            swipec.isOn = flag as! Bool
        }else{
            swipec.isOn = false
        }
    }

}
