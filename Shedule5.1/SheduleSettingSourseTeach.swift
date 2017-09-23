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
    
    let defaults: UserDefaults = UserDefaults(suiteName: "group.com.shedule")!
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
    
    override func viewWillAppear(_ animated: Bool) {
        nav(false)
        tableViewinit()
        stinit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        nav(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        nav(false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        nav(false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        teachinit(searchText)
        stext = searchText
    }
    
    func searchbarinit(){
        SearchBar.delegate = self
        SearchBar.placeholder = "Введите фамилию преподавателя"
        SearchBar.barTintColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        SearchBar.layer.borderColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        SearchBar.layer.borderWidth = 1
        SearchBar.keyboardAppearance = UIKeyboardAppearance.dark
    }
    
    
    func tableViewinit(){
        tableView.tableFooterView = UIView(frame:CGRect.zero)
        notable("educative", textlabel: "Начните искать преподавателей")
    }
    
    func nav(_ flag: Bool){
        self.navigationController?.setNavigationBarHidden(flag, animated: true)
        if !flag{
            self.SearchBar.showsCancelButton = false;
            SearchBar.resignFirstResponder()
            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
            view.backgroundColor = UIColor.clear
            self.view.addSubview(view)
        }else{
            self.SearchBar.showsCancelButton = true;
            let uiButton = SearchBar.value(forKey: "cancelButton") as! UIButton
            uiButton.setTitle("Отмена", for: UIControlState())
            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
            view.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
            self.view.addSubview(view)
        }
    }
    
    func teachinit(_ text: String){
        if text.characters.count == 0{
            notable("educative", textlabel: "Начните искать преподавателей")
            stinit()
        }else{
            self.loadjson(true)
            let priority = DispatchQueue.GlobalQueuePriority.default
            DispatchQueue.global(priority: priority).async {
                
                let SFCpostjson = SFpostjson(in_post: "name=\(text)", in_url: "http://lab.lionrepair.ru/uapp/api_teach.php")
                self.SFjson = SFCpostjson.json
                
                DispatchQueue.main.async {
                    
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
    
    func shedulesettingsub(_ text: String){
        self.navigationItem.title = text
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if showtableteach{
            return 1
        }else if showtablesearch{
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showtableteach{
            var count: Int
            if (SFjson != nil){
                count = ((SFjson["data"] as! [String:AnyObject])["data"]?.count)!
            } else {
                count = 1
            }
            return count
        }else if showtablesearch{
            return searcharray.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if showtableteach{
            var count: Int
            if (SFjson != nil){
                count = ((SFjson["data"] as! [String:AnyObject])["data"]?.count)!
            } else {
                count = 1
            }
            if count == 1{
                return "По запросу \"\(stext)\" найден \(count) преподаватель"
            }else if count < 5{
                return "По запросу \"\(stext)\" найдено \(count) преподавателя"
            }else{
                return "По запросу \"\(stext)\" найдено \(count) преподавателей"
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showtableteach{
        let cell = tableView.dequeueReusableCell(withIdentifier: "shedulesettingteachcell", for: indexPath)
        cell.textLabel?.text = "\(String(describing: (((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.row] as! NSArray)[2])) \(String(describing: (((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.row] as! NSArray)[3])) \(String(describing: (((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.row] as! NSArray)[4]))"
        cell.accessoryType = .none
        return cell
        } else if showtablesearch{
           let cell = tableView.dequeueReusableCell(withIdentifier: "shedulesettingteachcell", for: indexPath)
           cell.selectionStyle = .none
            if searcharray[indexPath.row][2] as! Bool{
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
           cell.textLabel?.text = searcharray[indexPath.row][1] as? String
           return cell
        } else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showtableteach{
        tableView.deselectRow(at: indexPath, animated: true)
        let teachid = String(describing: (((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.row] as! NSArray)[1])
        let teachname = "\(String(describing: (((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.row] as! NSArray)[2])) \(String(describing: (((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.row] as! NSArray)[3])) \(String(describing: (((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.row] as! NSArray)[4]))"
        let SheduleSettingSourseTeachID = [teachid, teachname]
        seacrhteachpush(teachid, teachname: teachname)
        self.defaults.set(SheduleSettingSourseTeachID, forKey: "SheduleSettingSourseTeachID")
        self.defaults.set(true, forKey: "SheduleSettingupdate")
        self.defaults.synchronize()
        nav(false)
        self.navigationController?.popViewController(animated: true)
        }
        if showtablesearch{
            for (index, _) in searcharray.enumerated() {
                searcharray[index][2] = false as AnyObject
            }
            searcharray[indexPath.row][2] = true as AnyObject
            self.defaults.set([String(describing: searcharray[indexPath.row][0]), String(describing: searcharray[indexPath.row][1])], forKey: "SheduleSettingSourseTeachID")
            self.defaults.set(true, forKey: "SheduleSettingupdate")
            self.defaults.synchronize()
            stsave()
            stupdate()
            nav(false)
            self.navigationController?.popViewController(animated: true)
        }
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if showtablesearch{
            let dell = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Удалить") { action, index in
                if self.searcharray[indexPath.row][2] as! Bool{
                    self.defaults.removeObject(forKey: "SheduleSettingSourseTeachID")
                    self.defaults.set(true, forKey: "SheduleSettingupdate")
                    self.defaults.synchronize()
                }
                self.searcharray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                if self.searcharray.count == 1{
                    tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
                }
                self.stsave()
                self.stupdate()
            }
            return [dell]
        }else{
            return [UITableViewRowAction()]
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
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
        notable("cross31", textlabel: (self.SFjson["data"] as? [String:Any])!["info"] as! String)
    }
    
    func jsoncode05(){
        notable("cross31", textlabel: "Невозможно обработать данные")
    }
    
    func notable(_ textimg: String, textlabel: String){
        showtableteach = false
        showtablesearch = false
        infoimage.image = UIImage(named: textimg)
        infolabel.text = textlabel
        tableView.isHidden = true
        loadjson(false)
    }
    
    func ontable(){
        showtableteach = true
        showtablesearch = false
        self.tableView.isHidden = false
        self.tableView.reloadData()
        loadjson(false)
    }
    
    func loadjson(_ flag: Bool){
        if flag{
            activeload.startAnimating()
            activelabel.isHidden = false
            tableView.isHidden = flag
        }else{
            activeload.stopAnimating()
            activelabel.isHidden = true
        }
        infolabel.isHidden = flag
        infoimage.isHidden = flag
    }
    
    func seacrhteachpush(_ teachid: String, teachname: String){
        stupdate()
        for (index, _) in searcharray.enumerated() {
            searcharray[index][2] = false as AnyObject
        }
        searcharray.append([teachid as AnyObject, teachname as AnyObject, true as AnyObject])
        print(searcharray)
        stsave()
    }
    
    func stsave(){
        if searcharray.count != 0{
            self.defaults.set(searcharray, forKey: "SheduleSettingSearchTeach")
            self.defaults.synchronize()}
        else{
            self.stdell()
        }
    }
    func stupdate(){
        if defaults.object(forKey: "SheduleSettingSearchTeach") != nil{
            searcharray = defaults.object(forKey: "SheduleSettingSearchTeach") as! [[AnyObject]]
        }else{
            showtablesearch = false
            tableView.isHidden = true
        }
    }
    func stdell(){
        self.defaults.removeObject(forKey: "SheduleSettingSearchTeach")
    }
    func stinit(){
        if defaults.object(forKey: "SheduleSettingSearchTeach") != nil{
            searcharray = defaults.object(forKey: "SheduleSettingSearchTeach") as! [[AnyObject]]
            showtableteach = false
            showtablesearch = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}
