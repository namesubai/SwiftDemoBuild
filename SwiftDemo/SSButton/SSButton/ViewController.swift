//
//  ViewController.swift
//  SSButton
//
//  Created by quanminqianbao on 2018/1/8.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        for i in 0..<4 {
            let button:SSButton? = SSButton.init(frame: CGRect.zero,
                                                 type: .custom,
                                                 imageSize: CGSize(width:20,height:20),
                                                 space: 8,
                                                 titleTextType: SSButton.TitleTextType(rawValue: i)!)
            button?.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
            button?.layer.borderWidth = 0.5
            button?.setTitle("微信", for: .normal)
            button?.setTitleColor(UIColor.black, for: .normal)
            button?.setImage(UIImage.init(named: "wechat"), for: .normal)
            button?.frame = CGRect(x: 20, y: 50+(80+20)*i, width: 120, height: 80)
            button?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            self.view.addSubview(button!)
           
        }
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

