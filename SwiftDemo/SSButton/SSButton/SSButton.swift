//
//  SSButton.swift
//  SSButton
//
//  Created by quanminqianbao on 2018/1/8.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

import UIKit




public class SSButton: UIButton {
    
    
    public enum TitleTextType:Int {
        case TopImage_BottomText //上图,下文
        case TopText_BottomImage //上文,下图
        case LeftImage_RightText //左图,右文
        case LeftText_RightImage //左文,右图
    }
    var imageSize:CGSize?
    var space:CGFloat?
    var titleTextType:TitleTextType?
  
    init?(frame: CGRect,type:UIButtonType,imageSize: CGSize, space:CGFloat, titleTextType:TitleTextType ){
        super.init(frame: frame)
        self.init(type: type)
        self.imageSize = imageSize
        self.space = space
        self.titleTextType = titleTextType
        
    }
    
    
    override init(frame: CGRect) {
       super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel?.sizeToFit()

        if self.titleTextType == .TopImage_BottomText {
            self.titleLabel?.textAlignment = .center
            let textH = self.titleLabel?.text?.ss_widthForComment(font:(self.titleLabel?.font)!, size: CGSize(width: self.frame.width, height:CGFloat(MAXFLOAT))).height
            let margin = (self.frame.height-(self.imageSize?.height)!-self.space!-textH!)/2
            
            self.imageView?.frame = CGRect(x: (self.frame.width-(self.imageSize?.width)!)/2, y: margin, width: (self.imageSize?.width)!, height: (self.imageSize?.height)!)
            self.titleLabel?.frame = CGRect(x: 0, y: (self.imageView?.frame.maxY)!+self.space!, width: self.frame.width, height: textH!)
        }
        
        if self.titleTextType == .TopText_BottomImage {
   
            self.titleLabel?.textAlignment = .center
            let textH = self.titleLabel?.text?.ss_widthForComment(font:(self.titleLabel?.font)!, size: CGSize(width: self.frame.width, height:CGFloat(MAXFLOAT))).height
            let margin = (self.frame.height-(self.imageSize?.height)!-self.space!-textH!)/2
            self.titleLabel?.frame = CGRect(x: 0, y: margin, width: self.frame.width, height: textH!)
            self.imageView?.frame = CGRect(x: (self.frame.width-(self.imageSize?.width)!)/2, y: (self.titleLabel?.frame.maxY)!+self.space!, width: (self.imageSize?.width)!, height: (self.imageSize?.height)!)
            
        }
        
        if self.titleTextType == .LeftImage_RightText {
            
            let textW = self.titleLabel?.text?.ss_widthForComment(font:(self.titleLabel?.font)!, size: CGSize(width: CGFloat(MAXFLOAT), height:self.frame.height)).width
            let margin = (self.frame.width-(self.imageSize?.width)!-self.space!-textW!)/2
            self.imageView?.frame = CGRect(x: margin, y: (self.frame.height-(self.imageSize?.height)!)/2, width: (self.imageSize?.width)!, height: (self.imageSize?.height)!)
            self.titleLabel?.frame = CGRect(x: (self.imageView?.frame.maxX)!+self.space!, y:0, width: textW!, height: self.frame.height)
        }
        
        if self.titleTextType == .LeftText_RightImage {
            
            let textW = self.titleLabel?.text?.ss_widthForComment(font:(self.titleLabel?.font)!, size: CGSize(width: CGFloat(MAXFLOAT), height:self.frame.height)).width
            let margin = (self.frame.width-(self.imageSize?.width)!-self.space!-textW!)/2
            self.titleLabel?.frame = CGRect(x: margin, y:0, width: textW!, height: self.frame.height)
            self.imageView?.frame = CGRect(x: (self.titleLabel?.frame.maxX)!+self.space!, y: (self.frame.height-(self.imageSize?.height)!)/2, width: (self.imageSize?.width)!, height: (self.imageSize?.height)!)
            
         
        }

        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension String {
    
    func ss_widthForComment(font: UIFont, size:CGSize) -> CGSize {
        let rect = NSString(string: self).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return rect.size
    }
    
}


