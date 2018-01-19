//
//  SSScrollSelectView.swift
//  SSScrollSelectView
//
//  Created by quanminqianbao on 2018/1/10.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

import UIKit

let labelMargin = 10.0
let bottomLineViewHeight = 5.0

class SSScrollSelectView: UIView {

    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView.init(frame: .zero)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView;
    }()
    
    lazy var labels:Array<(label:UILabel,labelWidth:CGFloat)> = {
        let labels = Array<(label:UILabel,labelWidth:CGFloat)>()
        return labels
    }()
    
    var bottomLineColor:UIColor? = nil
    var titleColor:UIColor? = nil
    var selectTitleColor:UIColor? = nil
    var titelFont:UIFont? = nil
    var selectTitelFont:UIFont? = nil
    var bottomLineView:UIView? = nil
    var selectIndex:Int? = nil
    
    typealias SelectBlock = (SSScrollSelectView,NSInteger) -> Void
    var selectBlock:SelectBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(frame: CGRect,
                     titles:Array<String>,
                     titleColor:UIColor = UIColor.black,
                     selectTitleColor:UIColor = UIColor.blue,
                     titelFont:UIFont = UIFont.systemFont(ofSize: 14),
                     selectTitelFont:UIFont = UIFont.systemFont(ofSize: 16),
                     bottomLineColor:UIColor = UIColor.blue) {
        self.init(frame: frame)
        self.titleColor = titleColor
        self.selectTitleColor = selectTitleColor
        self.titelFont = titelFont
        self.selectTitelFont = selectTitelFont
        self.bottomLineColor = bottomLineColor
   
        self.addSubview(self.scrollView)
        
        
        for (index,title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.textColor = titleColor;
            label.font = titelFont
            self.scrollView.addSubview(label)
            let labelWidth = title.ss_widthForComment(font: titelFont,
                                                      size: CGSize(width: CGFloat(MAXFLOAT),
                                                                   height: 20.0)).width + CGFloat(labelMargin*2)
            self.labels.append((label,labelWidth))
            label.tag = index+101
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
            label.addGestureRecognizer(tap)
        }
        
        self.bottomLineView = UIView(frame: CGRect.zero)
        self.bottomLineView?.backgroundColor = self.bottomLineColor
        self.scrollView.addSubview(self.bottomLineView!)
        
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.1) {
            self.selectItem(selectIndex: 0)
        }
        
    }
    
   @objc func tapAction(tap:UITapGestureRecognizer) {
        self.selectItem(selectIndex: (tap.view?.tag)!-101)
    }
 
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: self.frame.width,
                                       height: self.frame.height)
       
        if self.returnTotalWidth()<=self.frame.width {
            self.scrollView.contentSize = CGSize(width: self.frame.width,
                                                 height: self.frame.height)
            let equalWidth = self.frame.width/CGFloat(self.labels.count)
            
            
            for (index,value) in self.labels.enumerated() {
                value.label.frame = CGRect(x: equalWidth*CGFloat(index),
                                           y: 0,
                                           width: equalWidth,
                                           height: self.frame.height)
            }
           
            
        }else{
            
            self.scrollView.contentSize = CGSize(width: self.returnTotalWidth(),
                                                 height: self.frame.height)
            for (index,value) in self.labels.enumerated() {
                if index == 0 {
                   value.label.frame = CGRect(x: 0,
                                              y: 0,
                                              width: value.labelWidth,
                                              height: self.frame.height)
                }else{
                    value.label.frame = CGRect(x: self.labels[index-1].label.frame.maxX,
                                               y: 0,
                                               width: value.labelWidth,
                                               height: self.frame.height)
                }
                
            }
            
            
            
        }
        
        if !(self.selectIndex != nil) {
            self.bottomLineView?.frame = CGRect(x: 0, y: self.frame.height-CGFloat(bottomLineViewHeight), width: self.labels[0].label.frame.width, height: CGFloat(bottomLineViewHeight))
            
        }
        
    }
    
     //计算总长度
    func returnTotalWidth() -> CGFloat {
        var totalWidth:CGFloat = 0
        for (_,width) in self.labels {
            totalWidth += width
        }
        return totalWidth
    }
    
    //选择
    func selectItem(selectIndex:Int) {
        
        for (index,value) in self.labels.enumerated() {
            
           
            
            if selectIndex == index {
                guard selectIndex != self.selectIndex else{
                    return;
                }
                self.selectIndex = selectIndex
                value.label.font = self.selectTitelFont
                value.label.textColor = self.selectTitleColor
                
                let covertRect = value.label.superview?.convert(value.label.frame, to: self)
                
                
                if (covertRect?.maxX)!>self.frame.width {
                    if index<self.labels.count-1{
                        self.scrollView.scrollRectToVisible(self.labels[index+1].label.frame, animated: true)
                    }else{
                        self.scrollView.scrollRectToVisible(self.labels[index].label.frame, animated: true)
                    }
                }
                if (covertRect?.minX)!<0 {
                    if index>0 {
                        self.scrollView.scrollRectToVisible(self.labels[index-1].label.frame, animated: true)
                    }else{
                        self.scrollView.scrollRectToVisible(self.labels[index].label.frame, animated: true)
                    }
                }
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.bottomLineView?.frame = CGRect(x: value.label.frame.minX, y: value.label.frame.maxY-CGFloat(bottomLineViewHeight), width: value.label.frame.width, height: CGFloat(bottomLineViewHeight))
                }, completion: { (finish) in
                    
                })
                if (self.selectBlock != nil) {
                    self.selectBlock!(self,NSInteger(selectIndex))
                }

            }else{
                value.label.font = self.titelFont
                value.label.textColor = self.titleColor
            }
        }
    }
    //回调
    func selectView(block:@escaping SelectBlock) {
        self.selectBlock = block;
    }
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

