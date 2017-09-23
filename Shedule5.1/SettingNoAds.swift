//
//  SettingNoAds.swift
//  Shedule5.1
//
//  Created by CSergey on 25.04.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SettingNoAds: UITableViewCell {
    
    @IBOutlet weak var adsswitch: UISwitch!
    @IBOutlet weak var label: UILabel!
    
    let defaults: UserDefaults = UserDefaults(suiteName: "group.com.shedule")!
    let nc = NotificationCenter.default

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        label.text = "Ограничения"
        adsswitch.isEnabled = false
        nc.addObserver(self, selector: #selector(SettingNoAds.noads), name: NSNotification.Name(rawValue: "funcnoads"), object: nil)
        nc.addObserver(self, selector: #selector(SettingNoAds.switchenable), name: NSNotification.Name(rawValue: "funcswitchenable"), object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func adsswitch(_ sender: UISwitch) {
        nc.post(name: Notification.Name(rawValue: "funcalertads"), object: nil)
    }
    
    func noads(){
        adsswitch.isOn = true
    }
    
    func switchenable(){
        adsswitch.isEnabled = true
    }

}
