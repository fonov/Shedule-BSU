//
//  SettingSourseShedule.swift
//  Shedule5.1
//
//  Created by kotmodell on 09.02.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SettingSourseShedule: UITableViewCell {
    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var SheduleSettingSourseSegment: UISegmentedControl!
    let nc = NSNotificationCenter.defaultCenter()
    var customsegment: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //SheduleSettingSourseSegment.selectedSegmentIndex = customsegment
        ShedueSettinginitsourse()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func SegmentSourseShedule(sender: UISegmentedControl) {
        defaults.setObject(sender.selectedSegmentIndex, forKey: "SheduleSettingSourseShedule")
        defaults.setObject(true, forKey: "SheduleSettingupdate")
        defaults.synchronize()
        nc.postNotificationName("funcshedulesettingsoursereload", object: nil)
    }
    
    func ShedueSettinginitsourse(){
        
        if let data = defaults.objectForKey("SheduleSettingSourseShedule"){
        SheduleSettingSourseSegment.selectedSegmentIndex = data as! Int
        }else{
        SheduleSettingSourseSegment.selectedSegmentIndex = 0
        defaults.setObject(SheduleSettingSourseSegment.selectedSegmentIndex, forKey: "SheduleSettingSourseShedule")
        defaults.synchronize()
        }
        
    }

}
