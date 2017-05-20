//
//  SheduleSettingMainId.swift
//  Shedule5.1
//
//  Created by kotmodell on 10.02.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SheduleSettingSourseGroup: UITableViewController {

//    @IBOutlet weak var MainID: UITextField!
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.shedule")!
    let nc = NSNotificationCenter.defaultCenter()
    var grouparray = [[AnyObject]]()
    var openkeyboard: Bool = false
    var showgs: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        shedulesettingsub("Выбор группы")
//        MainID.becomeFirstResponder()
        nc.addObserver(self, selector: #selector(SheduleSettingSourseGroup.fromgrouptosetting), name: "funcfromgrouptosetting", object: nil)
        shedulesettinggroupinit()
    }
    
    override func viewWillAppear(animated: Bool) {
//    shedulesettinggroupinit()
    }
//    
//
//    @IBAction func ActionMainID(sender: UITextField) {
//        if MainID.text != ""{
//        self.defaults.setObject(MainID.text, forKey: "SheduleSettingSourseGroupID")
//        self.defaults.setObject(true, forKey: "SheduleSettingupdate")
//        self.defaults.synchronize()
//        }
//        MainID.resignFirstResponder()
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if showgs{
            return 2
        }else{
            return 1
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1{
        return grouparray.count
        }else{
        return 1
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Выбрать группу"
        }else if section == 1{
            let title: String!
            if grouparray.count == 1{
                title = "Последняя выбранная группа"
            }else{
                title = "Последние выбранные группы"
            }
            return title
        }else{
            return ""
        }
    }
    
    func shedulesettingsub(text: String){
        self.navigationItem.title = text
        self.tabBarController?.tabBar.hidden = true
    }
    
    func shedulesettinggroupinit(){
        if let data = defaults.objectForKey("SheduleSettingGroupArray"){
            grouparray = data as! [[AnyObject]]
            if grouparray.count == 0{
                showgs = false
            }else{
                showgs = true
            }
        }else{
            showgs = false
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("shedulesettinglistgrcell", forIndexPath: indexPath) as! SettingGroupListCell
            cell.textLabel?.text = grouparray[indexPath.row][0] as? String
            cell.selectionStyle = .None
            if grouparray[indexPath.row][1] as! Bool{
                cell.accessoryType = .Checkmark
            }
            else{
                cell.accessoryType = .None
            }
            return cell
        }else{
        let cell = tableView.dequeueReusableCellWithIdentifier("shedulesettinggroupinput", forIndexPath: indexPath) as! SettingGroupInputCell
            if grouparray.count == 0 || openkeyboard{
            cell.groupinput.becomeFirstResponder()
            }
        return cell
        }
    }
    
    func fromgrouptosetting(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1{
            shedulesettinggroupinit()
            for (index, _) in grouparray.enumerate() {
                grouparray[index][1] = false
            }
            grouparray[indexPath.row][1] = true
            self.defaults.setObject(grouparray, forKey: "SheduleSettingGroupArray")
            self.defaults.setObject(grouparray[indexPath.row][0], forKey: "SheduleSettingSourseGroupID")
            self.defaults.setObject(true, forKey: "SheduleSettingupdate")
            self.defaults.synchronize()
            self.navigationController?.popViewControllerAnimated(true)
        }
        if indexPath.section == 0{
            openkeyboard = true
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
    
   override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    if indexPath.section == 1{
        
        let dell = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Удалить") { action, index in
//            if self.grouparray.count > 1{
//                if self.grouparray[indexPath.row][1] as! Bool{
//                    print("Have CheckMark")
//                    self.defaults.removeObjectForKey("SheduleSettingSourseGroupID")
//                    self.defaults.setObject(true, forKey: "SheduleSettingupdate")
//                    self.defaults.synchronize()
//                }
//            self.grouparray.removeAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//            self.defaults.setObject(self.grouparray, forKey: "SheduleSettingGroupArray")
//            self.defaults.synchronize()
//                if self.grouparray.count == 1{
//                    print("One sparata")
//                    self.grouparray[0][1] = true
//                    self.defaults.setObject(self.grouparray, forKey: "SheduleSettingGroupArray")
//                    self.defaults.setObject(self.grouparray[0][0], forKey: "SheduleSettingSourseGroupID")
//                    self.defaults.setObject(true, forKey: "SheduleSettingupdate")
//                    self.defaults.synchronize()
//                    self.navigationController?.popViewControllerAnimated(true)
//                }
//            }
              self.shedulesettinggroupinit()
              if self.grouparray[indexPath.row][1] as! Bool{
                self.defaults.removeObjectForKey("SheduleSettingSourseGroupID")
                self.defaults.setObject(true, forKey: "SheduleSettingupdate")
                self.defaults.synchronize()
              }
              self.grouparray.removeAtIndex(indexPath.row)
              tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
              if self.grouparray.count == 1{
                tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
              }
              self.sgsave()
              self.sgupdate()
        }
        return [dell]
    }else{
        return [UITableViewRowAction()]
    }
    }
    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 1{
            return true
        }else{
            return false
        }
    }
    
    func sgsave(){
        self.defaults.setObject(grouparray, forKey: "SheduleSettingGroupArray")
        self.defaults.synchronize()
    }
    func sgupdate(){
        if let data = defaults.objectForKey("SheduleSettingGroupArray"){
            grouparray = data as! [[AnyObject]]
            if grouparray.count == 0{
                showgs = false
                tableView.reloadData()
            }else{
                showgs = true
            }
        }else{
            showgs = false
            tableView.reloadData()
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
