//
//  ViewController.swift
//  SSPageViewController
//
//  Created by quanminqianbao on 2018/1/12.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
           // Do any additional setup after loading the view, typically from a nib.
    }
    

    
    @IBAction func showAction1(_ sender: Any) {
        let VC = PageViewController()
        VC.headerHeight = 200.0;
        VC.pageType = SSPageType.headerType
        let nav = UINavigationController.init(rootViewController:VC)
        self.present(nav, animated: true, completion: nil)
    }
    @IBAction func showAction(_ sender: Any) {
        let nav = UINavigationController.init(rootViewController:PageViewController())
        self.present(nav, animated: true, completion: nil)
    }
    @IBOutlet weak var show: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class PageViewController: SSPageViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Double(self.headerHeight!) > 0.0 {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.red
            let imageView = UIImageView()
            imageView.image = UIImage.init(named: "appstroe_banar")
            imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
            headerView.addSubview(imageView)
            self.headerView = headerView
        }
        
        self.view.backgroundColor = UIColor.white
        self.selectTitles = ["vc1","vc2vc2vc2vc2","vc3vc3","vc4vc4vc4","vc5vc5vc5vc5vc5"]
        let vc1 = TempViewController()
        
        let vc2 = TempViewController()
        
        let vc3 = TempViewController()
        
        let vc4 = TempViewController()
        let vc5 = TempViewController()
        self.selectViewControllers = [vc1,vc2,vc3,vc4,vc5]
        self.reloadView()

        let rightButton = UIBarButtonItem.init(title: "返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func back(){
        self .dismiss(animated: true, completion: nil)
    }
    
  
}


