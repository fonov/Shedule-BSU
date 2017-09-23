//
//  SettingGroupInputCell.swift
//  Shedule5.1
//
//  Created by kotmodell on 02.03.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SettingGroupInputCell: UITableViewCell {

    @IBOutlet weak var groupinput: UITextField!
    let nc = NotificationCenter.default
    let defaults: UserDefaults = UserDefaults(suiteName: "group.com.shedule")!
    var grouparray = [[AnyObject]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shedulesettinggroupcellinit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }    
    @IBAction func eventgrinput(_ sender: AnyObject) {
        if groupinput.text!.characters.count != 0{
            self.defaults.set(String(validatingUTF8: groupinput.text!), forKey: "SheduleSettingSourseGroupID")
            self.defaults.set(true, forKey: "SheduleSettingupdate")
            self.defaults.synchronize()
            seacrhgpush(groupinput.text!)
        }
        groupinput.resignFirstResponder()
        nc.post(name: Notification.Name(rawValue: "funcfromgrouptosetting"), object: nil)
    }
    
    func shedulesettinggroupcellinit(){
        groupinput.keyboardAppearance = UIKeyboardAppearance.dark
        groupinput.placeholder = "Введите номер группы"
    }
    
    func seacrhgpush(_ group: String){
        sgupdate()
        for (index, _) in grouparray.enumerated() {
            grouparray[index][1] = false as AnyObject
        }
        grouparray.append([group as AnyObject, true as AnyObject])
        sgsave()
        print(grouparray)
    }
    func sgsave(){
        if grouparray.count != 0{
            self.defaults.set(grouparray, forKey: "SheduleSettingGroupArray")
            self.defaults.synchronize()}
        else{
            self.sgdell()
        }
    }
    func sgdell(){
        self.defaults.removeObject(forKey: "SheduleSettingGroupArray")
    }
    
    func sgupdate(){
        if defaults.object(forKey: "SheduleSettingGroupArray") != nil{
            grouparray = defaults.object(forKey: "SheduleSettingGroupArray") as! [[AnyObject]]
        }
    }

}
