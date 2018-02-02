//
//  ViewController.swift
//  MarqueeLabel
//
//  Created by quanminqianbao on 2018/1/28.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = SSMarqueeLabel.init(frame: CGRect(x: 10, y: 80, width: self.view.bounds.width-20, height: 40))
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "TXSFSFDFSFSFSsXSFSFDFSFSFSsXSFSFDFSFSF   SsXSFSFDFSFSFSsXSFSFDFSFSFSsXSFS "
        self.view.addSubview(label)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

