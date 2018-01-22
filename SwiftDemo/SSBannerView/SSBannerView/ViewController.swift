//
//  ViewController.swift
//  SSBannerView
//
//  Created by quanminqianbao on 2018/1/20.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let array = NSMutableArray()
        for i in 0...3 {
            let image = UIImage.init(named: "\(i+1).jpg")
            array.add(image as Any)
        }
        let bannerView = SSBannerView.init(frame: CGRect(x:0,y:64,width:self.view.frame.width,height:200), itemSize: CGSize(width:self.view.frame.width,height:200), bannerType: .cardType)
        self.view.addSubview(bannerView)
        bannerView.images = array
        bannerView .bannerClick { (view, index) in
            NSLog("点击%d", index)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

