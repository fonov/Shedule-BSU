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
    
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.shedule")!
    let nc = NSNotificationCenter.defaultCenter()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        label.text = "Ограничения"
        adsswitch.enabled = false
        nc.addObserver(self, selector: #selector(SettingNoAds.noads), name: "funcnoads", object: nil)
        nc.addObserver(self, selector: #selector(SettingNoAds.switchenable), name: "funcswitchenable", object: nil)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func adsswitch(sender: UISwitch) {
        nc.postNotificationName("funcalertads", object: nil)
    }
    
    func noads(){
        adsswitch.on = true
    }
    
    func switchenable(){
        adsswitch.enabled = true
    }

}
