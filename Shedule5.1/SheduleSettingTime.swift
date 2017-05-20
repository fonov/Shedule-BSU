//
//  SheduleSettingTime.swift
//  Shedule5.1
//
//  Created by kotmodell on 10.02.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SheduleSettingTime: UITableViewController {
    
    var shedulesettingtimearray = [[["shedulesettingtimecell", "Прошлая неделя", false], ["shedulesettingtimecell", "Текущая неделя", false], ["shedulesettingtimecell", "Следующая неделя", false], ["shedulesettingtimecell", "Задать дату", false, ""]], []]
    
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.shedule")!
    
//    let nc = NSNotificationCenter.defaultCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        shedulesettingsub("Время расписания")
//        nc.addObserver(self, selector: "shedulesettingtimecustomdetal", name: "funcshedulesettingtimecustomdetal", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        shedulesettingtimeinit()
//        shedulesettingtimecustomdetal()
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        let sectioncount: Int = shedulesettingtimearray.count
        
//        if self.shedulesettingtimearray[1][0][1] as! Bool != true{
//           sectioncount = sectioncount-1
//        }
        
        return sectioncount
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shedulesettingtimearray[section].count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = 44
        if shedulesettingtimearray[indexPath.section][indexPath.row][0] as? String == "shedulesettingtimecellcust"{
            height = 300
        }
        return height
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if shedulesettingtimearray[indexPath.section][indexPath.row][0] as? String == "shedulesettingtimecell"{
        cell = tableView.dequeueReusableCellWithIdentifier("shedulesettingtimecell", forIndexPath: indexPath)

        if shedulesettingtimearray[indexPath.section][indexPath.row].count == 4{
            cell.detailTextLabel?.text = shedulesettingtimearray[indexPath.section][indexPath.row][3] as? String
        }else{
            cell.detailTextLabel?.text = ""
        }

        cell.textLabel?.text = shedulesettingtimearray[indexPath.section][indexPath.row][1] as? String
        if shedulesettingtimearray[indexPath.section][indexPath.row][2] as! Bool{
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }
            
        }
        if shedulesettingtimearray[indexPath.section][indexPath.row][0] as? String == "shedulesettingtimecellcust"{
            cell = tableView.dequeueReusableCellWithIdentifier("shedulesettingtimecellcust", forIndexPath: indexPath)
        }

        cell.selectionStyle = .None
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if shedulesettingtimearray[indexPath.section][indexPath.row][0] as? String == "shedulesettingtimecell"{
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.shedulesettingtimearray[indexPath.section][0][2] = false
            self.shedulesettingtimearray[indexPath.section][1][2] = false
            self.shedulesettingtimearray[indexPath.section][2][2] = false
            self.shedulesettingtimearray[indexPath.section][3][2] = false
            self.shedulesettingtimearray[indexPath.section][indexPath.row][2] = true
            
            
            self.defaults.setObject(indexPath.row, forKey: "SheduleSettingtime")
            self.defaults.setObject(true, forKey: "SheduleSettingupdate")
            self.defaults.synchronize()
            
            dispatch_async(dispatch_get_main_queue()) {
                if self.shedulesettingtimearray[indexPath.section][3][2] as! Bool{
                    if self.shedulesettingtimearray[1].count == 0{
                        self.shedulesettingtimearray[1].append(["shedulesettingtimecellcust"])
                        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Fade)
                    }
                }else{
                    if self.shedulesettingtimearray[1].count == 1{
                        self.shedulesettingtimearray[1].removeAtIndex(0)
                        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)],withRowAnimation: UITableViewRowAnimation.Fade)
                    }
                }
                tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: 3, inSection: indexPath.section), NSIndexPath(forItem: 2, inSection: indexPath.section), NSIndexPath(forItem: 1, inSection: indexPath.section), NSIndexPath(forItem: 0, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.None)
                
          }
        }
      }
    }
    
    func shedulesettingsub(text: String){
        self.navigationItem.title = text
        self.tabBarController?.tabBar.hidden = true
    }

 
    func shedulesettingtimeinit(){
        if let data = defaults.objectForKey("SheduleSettingtime"){
            shedulesettingtimearray[0][data as! Int][2] = true
            if data as! Int == 3{
                self.shedulesettingtimearray[1].append(["shedulesettingtimecellcust"])
            }
        }
    }
    
//    func shedulesettingtimecustomdetal(){
//        
//        var detalcustomdate: String!
//        
//        if defaults.objectForKey("SheduleSettingCustomdatefist") != nil && defaults.objectForKey("SheduleSettingCustomdatefist") != nil{
//            let fistdate = self.defaults.objectForKey("SheduleSettingCustomdatefist")
//            let lastdate = self.defaults.objectForKey("SheduleSettingCustomdatelast")
//            detalcustomdate = "\(fistdate![1] as! String)-\(lastdate![1] as! String)"
//        }else{
//            detalcustomdate = ""
//        }
//        
//        shedulesettingtimearray[0][3][3] = detalcustomdate
//        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 3, inSection: 0)], withRowAnimation: .None)
//    }

    
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
