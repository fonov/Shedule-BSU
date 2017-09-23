//
//  SettingSourseShedule.swift
//  Shedule5.1
//
//  Created by kotmodell on 09.02.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SettingSourseShedule: UITableViewCell {
    var defaults: UserDefaults = UserDefaults.standard

    @IBOutlet weak var SheduleSettingSourseSegment: UISegmentedControl!
    let nc = NotificationCenter.default
    var customsegment: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //SheduleSettingSourseSegment.selectedSegmentIndex = customsegment
        ShedueSettinginitsourse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func SegmentSourseShedule(_ sender: UISegmentedControl) {
        defaults.set(sender.selectedSegmentIndex, forKey: "SheduleSettingSourseShedule")
        defaults.set(true, forKey: "SheduleSettingupdate")
        defaults.synchronize()
        nc.post(name: Notification.Name(rawValue: "funcshedulesettingsoursereload"), object: nil)
    }
    
    func ShedueSettinginitsourse(){
        
        if let data = defaults.object(forKey: "SheduleSettingSourseShedule"){
        SheduleSettingSourseSegment.selectedSegmentIndex = data as! Int
        }else{
        SheduleSettingSourseSegment.selectedSegmentIndex = 0
        defaults.set(SheduleSettingSourseSegment.selectedSegmentIndex, forKey: "SheduleSettingSourseShedule")
        defaults.synchronize()
        }
        
    }

}
