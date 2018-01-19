//
//  ViewController.swift
//  SSScrollSelectView
//
//  Created by quanminqianbao on 2018/1/10.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectView = SSScrollSelectView.init(frame: CGRect(x:0,y:40,width:self.view.frame.width,height:45),
                                                 titles: ["select1","select1","select1","select1","select1select1","select1select1select1","select1","select1select1","select1select1select1","select1select1"])
        selectView.backgroundColor = UIColor.gray
        self.view.addSubview(selectView)
        selectView.selectView { (view, index) in
            NSLog("点击%ld", index)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

