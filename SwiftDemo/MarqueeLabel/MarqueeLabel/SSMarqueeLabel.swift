//
//  SSMarqueeLabel.swift
//  MarqueeLabel
//
//  Created by quanminqianbao on 2018/1/28.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

import UIKit
import WebKit

let speed = 0.5 //控制滚动的速度
let fadeWidth:CGFloat = 20 //两边遮罩的宽度
let spcingBetweenHeadToTail:CGFloat = 30//
class SSMarqueeLabel: UILabel {

    var textWidth:CGFloat? = 0
    var offsetX:CGFloat?
    var displayLink:CADisplayLink?
    
   override open var text: String? {
        didSet{
            self.textWidth = text?.ss_widthForComment(font: self.font, size: CGSize.init(width: CGFloat(MAXFLOAT), height: self.frame.height)).width
            self.displayLink?.isPaused = true;
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if self.window != nil {
            self.displayLink = CADisplayLink.init(target: self, selector: #selector(handleDisplayLink(displayLink:)))
            self.displayLink?.add(to: RunLoop.current, forMode: .commonModes)
        }else {
            self.displayLink?.invalidate()
            self.displayLink = nil
        }
        self.offsetX = 0
    }
    
    
    fileprivate func shouldPlayDisplayLink() -> Bool{
        guard self.textWidth != nil else {
            return false
        }
        var result:Bool = self.window != nil && self.bounds.width > 0 && self.textWidth! > self.bounds.width - fadeWidth*2
        
        if result {
            let rectInWindow = window?.convert(frame, from: superview)
            
            if self.window?.bounds.intersects(rectInWindow!) == false {
                result = false
            }
        }
        
        return result
    }
    
    
    @objc fileprivate func handleDisplayLink(displayLink:CADisplayLink) {
//        if self.offsetX == 0 {
//            self.displayLink?.isPaused = true;
//            self.setNeedsDisplay()
//
//             self.offsetX  = self.offsetX! - CGFloat(speed)
//
//            return;
//        }
        self.offsetX  = self.offsetX! - CGFloat(speed);
        self.setNeedsDisplay()
        
        var num:CGFloat? = 0
        if self.textRepeatCountConsiderTextWidth()>1 {
            num = spcingBetweenHeadToTail
        }
        if -CGFloat(self.offsetX!) >= self.textWidth! + num! {
          
            self.offsetX = self.frame.width-fadeWidth;
//            self.displayLink?.isPaused = true
        }
    }
    
    override func draw(_ rect: CGRect) {
        var textInitialX:Double = 0.0
        if self.textAlignment == .left {
            textInitialX = 0.0
        }else if self.textAlignment == .center {
            textInitialX = fmax(0.0, Double(self.bounds.width-self.textWidth!)/2)
        }else if self.textAlignment == .right {
            textInitialX = fmax(0.0, Double(self.bounds.width-self.textWidth!)/2)
        }
        //考虑渐变遮罩的偏移
        var textOffsetXByFade:Double = 0.0
        if textInitialX < Double(fadeWidth) {
            textOffsetXByFade = Double(fadeWidth)
        }else{
            textOffsetXByFade = 0.0
        }
        textInitialX = textInitialX+textOffsetXByFade
        
        for i in 0...(textRepeatCountConsiderTextWidth()-1) {
            self.attributedText?.draw(in: CGRect.init(x: self.offsetX!, y: (self.textWidth!+spcingBetweenHeadToTail)*CGFloat(i), width: self.textWidth!,height:rect.height))
   
        }
        
    }
    
    func textRepeatCountConsiderTextWidth() -> Int {
        if self.textWidth! < self.bounds.width {
            return 1
        }
        return 2
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
