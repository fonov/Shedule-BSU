//
//  SheduleSettingAbout.swift
//  Shedule5.1
//
//  Created by kotmodell on 26.02.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SheduleSettingAbout: UITableViewController {

    var arrayshedulesettingabout = [["cellshedulesettingaboutimg", ["", ""]], ["cellshedulesettingabout", ["Версия", "2.1"]], ["cellshedulesettingabout", ["Руководитель проекта", "Фонов Сергей"]], ["cellshedulesettingabout", ["Разработчик", "Фонов Сергей"]], ["cellshedulesettingabout", ["Дизайнер", "Фонов Алексей"]], ["cellshedulesettingabout", ["Обратная связь", "ask@mounlion.com"]]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shedulesettingsub("О приложении")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayshedulesettingabout.count
    }
    
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayshedulesettingabout[indexPath.row][0] as! String == "cellshedulesettingaboutimg"{
            return 117}else{
            return UITableViewAutomaticDimension
    }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayshedulesettingabout[indexPath.row][0] as! String == "cellshedulesettingaboutimg"{
            return 117}else{
            return UITableViewAutomaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayshedulesettingabout[indexPath.row][0] as! String == "cellshedulesettingabout"{
        let cell = tableView.dequeueReusableCell(withIdentifier: arrayshedulesettingabout[indexPath.row][0] as! String, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = String(describing: (arrayshedulesettingabout[indexPath.row][1] as! NSArray)[0])
        cell.detailTextLabel?.text = String(describing: (arrayshedulesettingabout[indexPath.row][1] as! NSArray)[1])
            return cell
    }
    else if arrayshedulesettingabout[indexPath.row][0] as! String == "cellshedulesettingaboutimg"{
    let cell = tableView.dequeueReusableCell(withIdentifier: arrayshedulesettingabout[indexPath.row][0] as! String, for: indexPath) as! SettingAboutLogo
    cell.selectionStyle = .none
    cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0)
    return cell
    }else{
    let cell = UITableViewCell()
    return cell
    }
    }

    
    func shedulesettingsub(_ text: String){
        self.navigationItem.title = text
        self.tabBarController?.tabBar.isHidden = true
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
