//
//  SettingAutoScroll.swift
//  Shedule5.1
//
//  Created by CSergey on 12.03.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SettingAutoScroll: UITableViewCell {

    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.shedule")!
    let nc = NSNotificationCenter.defaultCenter()
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var scrollswitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        finit()
    }
    
    @IBAction func eventswitch(sender: UISwitch) {
        if limitation().check{
        if defaults.objectForKey("SheduleSettingAutoScroll") == nil{
        nc.postNotificationName("funcinstructionaboutautoscroll", object: nil)
        }
        defaults.setObject(sender.on, forKey: "SheduleSettingAutoScroll")
        defaults.synchronize()
        }else{
            nc.postNotificationName("funcalertinfoaboutlimits", object: nil, userInfo:["title": label.text!])
            scrollswitch.on = false
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func finit(){
        label.text = "Автоматическая прокрутка расписания"
        if let flag = defaults.objectForKey("SheduleSettingAutoScroll"){
            scrollswitch.on = flag as! Bool
        }else{
            scrollswitch.on = false
        }
    }

}
