//
//  HelloViewController.swift
//  Shedule5.1
//
//  Created by CSergey on 20.03.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class HelloViewController: UIViewController, UIPageViewControllerDataSource {

    var pageViewController: UIPageViewController!
    let nc = NotificationCenter.default
    
    var pagearray = [["ContentViewController", ["s3.png", "•Выделение текущей пары\n•Автоматическая прокрутка расписания\n•Быстрое переключение недель", UIColor(red: 80/255, green: 208/255, blue: 125/255, alpha: 1)]], ["ContentViewController", ["s7.png", "•Гибкие настройки\n•Работа в режиме офлайн", UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)]], ["ContentViewController", ["s8.png", "Добавляйте преподавателей, переключайтесь между ними", UIColor(red: 0/255, green: 191/255, blue: 255/255, alpha: 1)]], ["ContentViewController", ["s9.png", "Уведомление о начале", UIColor(red: 233/255, green: 150/255, blue: 120/255, alpha: 1)]], ["ContentViewController", ["s10.png", "Виджет\nдля быстрого просмотра", UIColor(red: 3/255, green: 94/255, blue: 96/255, alpha: 1)]], ["StartViewController", []]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageHelloViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let vcstart = contenthello(0)
        let viewControllers = NSArray(object: vcstart)
        
        pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        
        pageViewController.didMove(toParentViewController: self)
        
        nc.addObserver(self, selector: #selector(HelloViewController.returnhellosetting), name: NSNotification.Name(rawValue: "funcreturnhellosetting"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func contenthello(_ index: Int) -> UIViewController{
        if((pagearray.count == 0) || (index >= pagearray.count)){
            return ContentHelloViewController()
        }
        let vc: ContentHelloViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentHelloViewController") as! ContentHelloViewController
        vc.contarray = pagearray[index] as NSArray!
        vc.contindex = index
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentHelloViewController
        var index = vc.contindex as Int
        
        if index == 0 || index == NSNotFound{
            return nil
        }
        index = index-1
        return self.contenthello(index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentHelloViewController
        var index = vc.contindex as Int
        if index == NSNotFound || index+1 == pagearray.count{
            return nil
        }
        index = index+1
        return self.contenthello(index)
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pagearray.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func returnhellosetting(){
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
