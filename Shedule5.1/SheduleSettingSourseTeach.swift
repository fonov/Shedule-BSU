//
//  SheduleSettingSourseTeach.swift
//  Shedule5.1
//
//  Created by kotmodell on 10.02.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SheduleSettingSourseTeach: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var infolabel: UILabel!
    @IBOutlet weak var infoimage: UIImageView!
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activeload: UIActivityIndicatorView!
    @IBOutlet weak var activelabel: UILabel!
    
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.shedule")!
    var SFjson: NSDictionary!
    var showtableteach: Bool = false
    var searcharray = [[AnyObject]]()
    var showtablesearch: Bool = false
    var stext: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shedulesettingsub("Выбор преподавателя")
        searchbarinit()
    }
    
    override func viewWillAppear(animated: Bool) {
        nav(false)
        tableViewinit()
        stinit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        nav(true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        nav(false)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        nav(false)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        teachinit(searchText)
        stext = searchText
    }
    
    func searchbarinit(){
        SearchBar.delegate = self
        SearchBar.placeholder = "Введите фамилию преподавателя"
        SearchBar.barTintColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        SearchBar.layer.borderColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).CGColor
        SearchBar.layer.borderWidth = 1
        SearchBar.keyboardAppearance = UIKeyboardAppearance.Dark
    }
    
    
    func tableViewinit(){
        tableView.tableFooterView = UIView(frame:CGRectZero)
        notable("educative", textlabel: "Начните искать преподавателей")
    }
    
    func nav(flag: Bool){
        self.navigationController?.setNavigationBarHidden(flag, animated: true)
        if !flag{
            self.SearchBar.showsCancelButton = false;
            SearchBar.resignFirstResponder()
            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
            view.backgroundColor = UIColor.clearColor()
            self.view.addSubview(view)
        }else{
            self.SearchBar.showsCancelButton = true;
            let uiButton = SearchBar.valueForKey("cancelButton") as! UIButton
            uiButton.setTitle("Отмена", forState: UIControlState.Normal)
            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
            view.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
            self.view.addSubview(view)
        }
    }
    
    func teachinit(text: String){
        if text.characters.count == 0{
            notable("educative", textlabel: "Начните искать преподавателей")
            stinit()
        }else{
            self.loadjson(true)
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                let SFCpostjson = SFpostjson(in_post: "name=\(text)", in_url: "http://lab.lionrepair.ru/uapp/api_teach.php")
                self.SFjson = SFCpostjson.json
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    let codejson: Int = self.SFjson["code"] as! Int
                    switch codejson{
                    case 01:
                        self.jsoncode01()
                        break
                    case 02:
                        self.jsoncode02()
                        break
                    case 03:
                        self.jsoncode03()
                        break
                    case 04:
                        self.jsoncode04()
                        break
                    case 05:
                        self.jsoncode05()
                        break
                    default:
                        self.jsoncode00()
                        break
                    }
                }
            }
        }
    }
    
    func shedulesettingsub(text: String){
        self.navigationItem.title = text
        self.tabBarController?.tabBar.hidden = true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if showtableteach{
            return 1
        }else if showtablesearch{
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showtableteach{
            return SFjson["data"]!["data"]!!.count
        }else if showtablesearch{
            return searcharray.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if showtableteach{
            if SFjson["data"]!["data"]!!.count == 1{
                return "По запросу \"\(stext)\" найден \(SFjson["data"]!["data"]!!.count) преподаватель"
            }else if SFjson["data"]!["data"]!!.count < 5{
                return "По запросу \"\(stext)\" найдено \(SFjson["data"]!["data"]!!.count) преподавателя"
            }else{
                return "По запросу \"\(stext)\" найдено \(SFjson["data"]!["data"]!!.count) преподавателей"
            }
        }else if showtablesearch{
            if searcharray.count == 1{
                return "Последний выбранный преподаватель"
            }
            else{
                return "Последние выбранные преподаватели"
            }
        }else{
            return ""
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if showtableteach{
        let cell = tableView.dequeueReusableCellWithIdentifier("shedulesettingteachcell", forIndexPath: indexPath)
        cell.textLabel?.text = "\(String((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.row] as! NSArray)[2])) \(String((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.row] as! NSArray)[3])) \(String((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.row] as! NSArray)[4]))"
        cell.accessoryType = .None
        return cell
        } else if showtablesearch{
           let cell = tableView.dequeueReusableCellWithIdentifier("shedulesettingteachcell", forIndexPath: indexPath)
           cell.selectionStyle = .None
            if searcharray[indexPath.row][2] as! Bool{
                cell.accessoryType = .Checkmark
            }else{
                cell.accessoryType = .None
            }
           cell.textLabel?.text = searcharray[indexPath.row][1] as? String
           return cell
        } else{
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if showtableteach{
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let teachid = String((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.row] as! NSArray)[1])
        let teachname = "\(String((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.row] as! NSArray)[2])) \(String((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.row] as! NSArray)[3])) \(String((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.row] as! NSArray)[4]))"
        let SheduleSettingSourseTeachID = [teachid, teachname]
        seacrhteachpush(teachid, teachname: teachname)
        self.defaults.setObject(SheduleSettingSourseTeachID, forKey: "SheduleSettingSourseTeachID")
        self.defaults.setObject(true, forKey: "SheduleSettingupdate")
        self.defaults.synchronize()
        nav(false)
        self.navigationController?.popViewControllerAnimated(true)
        }
        if showtablesearch{
            for (index, _) in searcharray.enumerate() {
                searcharray[index][2] = false
            }
            searcharray[indexPath.row][2] = true
            self.defaults.setObject([String(searcharray[indexPath.row][0]), String(searcharray[indexPath.row][1])], forKey: "SheduleSettingSourseTeachID")
            self.defaults.setObject(true, forKey: "SheduleSettingupdate")
            self.defaults.synchronize()
            stsave()
            stupdate()
            nav(false)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if showtablesearch{
            let dell = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Удалить") { action, index in
                if self.searcharray[indexPath.row][2] as! Bool{
                    self.defaults.removeObjectForKey("SheduleSettingSourseTeachID")
                    self.defaults.setObject(true, forKey: "SheduleSettingupdate")
                    self.defaults.synchronize()
                }
                self.searcharray.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                if self.searcharray.count == 1{
                    tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
                }
                self.stsave()
                self.stupdate()
            }
            return [dell]
        }else{
            return [UITableViewRowAction()]
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if showtablesearch{
            return true
        }else{
            return false
        }
    }
    
    func jsoncode00(){
        notable("cross31", textlabel: "Неизвестная ошибка")
    }

    func jsoncode01(){
        notable("cross31", textlabel: "Oтсутствует подключение к интернету")
    }
    
    func jsoncode02(){
        notable("cross31", textlabel: "Невозможно загрузить данные")
    }
    
    func jsoncode03(){
        ontable()
    }
    
    func jsoncode04(){
        notable("cross31", textlabel: self.SFjson["data"]!["info"] as! String)
    }
    
    func jsoncode05(){
        notable("cross31", textlabel: "Невозможно обработать данные")
    }
    
    func notable(textimg: String, textlabel: String){
        showtableteach = false
        showtablesearch = false
        infoimage.image = UIImage(named: textimg)
        infolabel.text = textlabel
        tableView.hidden = true
        loadjson(false)
    }
    
    func ontable(){
        showtableteach = true
        showtablesearch = false
        self.tableView.hidden = false
        self.tableView.reloadData()
        loadjson(false)
    }
    
    func loadjson(flag: Bool){
        if flag{
            activeload.startAnimating()
            activelabel.hidden = false
            tableView.hidden = flag
        }else{
            activeload.stopAnimating()
            activelabel.hidden = true
        }
        infolabel.hidden = flag
        infoimage.hidden = flag
    }
    
    func seacrhteachpush(teachid: String, teachname: String){
        stupdate()
        for (index, _) in searcharray.enumerate() {
            searcharray[index][2] = false
        }
        searcharray.append([teachid, teachname, true])
        print(searcharray)
        stsave()
    }
    
    func stsave(){
        if searcharray.count != 0{
            self.defaults.setObject(searcharray, forKey: "SheduleSettingSearchTeach")
            self.defaults.synchronize()}
        else{
            self.stdell()
        }
    }
    func stupdate(){
        if defaults.objectForKey("SheduleSettingSearchTeach") != nil{
            searcharray = defaults.objectForKey("SheduleSettingSearchTeach") as! [[AnyObject]]
        }else{
            showtablesearch = false
            tableView.hidden = true
        }
    }
    func stdell(){
        self.defaults.removeObjectForKey("SheduleSettingSearchTeach")
    }
    func stinit(){
        if defaults.objectForKey("SheduleSettingSearchTeach") != nil{
            searcharray = defaults.objectForKey("SheduleSettingSearchTeach") as! [[AnyObject]]
            showtableteach = false
            showtablesearch = true
            tableView.hidden = false
            tableView.reloadData()
        }
    }
}