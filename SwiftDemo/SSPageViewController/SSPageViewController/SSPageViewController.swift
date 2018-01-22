//
//  SSPageViewController.swift
//  SSPageViewController
//
//  Created by quanminqianbao on 2018/1/12.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

import UIKit

let selectViewHeight = 45.0
enum SSPageType {
    case defaultType
    case headerType
}
 class SSPageViewController: UIViewController {

    
    var pageType:SSPageType? = SSPageType.defaultType
    var headerHeight:Double? = 0.0
    var selectViewControllers:NSArray? {
        didSet{
            for  vc  in selectViewControllers! {
                let vc = vc as! UIViewController
                vc.index = self.returnIndex(viewController: vc)!
                vc.changePageAction({ (pageIndex) in
                    self.currectIndex = pageIndex
                })
                if self.pageType == .headerType{
                    for subView in vc.view.subviews {
                        if subView.isKind(of: UIScrollView.classForCoder()) {
                            
                            (subView as! UIScrollView).contentInset = UIEdgeInsetsMake(CGFloat(self.headerHeight!+selectViewHeight), 0, 0, 0)
                            
                            subView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions(rawValue: NSKeyValueObservingOptions.RawValue(UInt8(NSKeyValueObservingOptions.new.rawValue)|UInt8(NSKeyValueObservingOptions.old.rawValue))), context:nil)
                            break;
                        }
                    }
                }
               
            }
        }
    }
    var selectTitles:NSArray?
    var sideChangePageEnabel:Bool? = false
    var myPageVc:UIPageViewController!
    var selectView:SSScrollSelectView!
    lazy var findeScrollerView:UIScrollView = {
        
        var scrollView:UIScrollView!
        for view in self.myPageVc.view.subviews {
            if view.isKind(of: UIScrollView.classForCoder()) {
                scrollView = (view as! UIScrollView)
                break
            }
        }
        return scrollView!
    }()
    var isTouchSelectView:Bool = false //是否是选择切换
    
    var currectIndex:Int! = 0 {
        willSet {
            if newValue != currectIndex {
                if self.isTouchSelectView == false {
                    self.selectView.changeSelectView(selectIndex: newValue, finish: {
                       
                    })
                }
               
            }
        }
        didSet{
            self.refreshScrollViewContentOffet()

        }
    }
    
    var headerView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        
        self .removeObserver(self, forKeyPath: "contentOffset")
    }
    
  
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentOffset" {
            let newOffset:CGPoint = change![NSKeyValueChangeKey.newKey] as! CGPoint
            let oldOffset:CGPoint = change![NSKeyValueChangeKey.oldKey] as! CGPoint
            let scrollView = (object as! UIScrollView)
            let newoffety = newOffset.y+scrollView.contentInset.top;
            let oldoffety = oldOffset.y+scrollView.contentInset.top;
//            NSLog( "%lf,%lf", newOffset.y-oldOffset.y,newoffety)

            if scrollView.contentOffset.y < scrollView.contentSize.height-scrollView.frame.height {
                if newoffety>0 && oldoffety>0{
                    self.moveHeadrView(newoffety: newoffety, oldoffety: oldoffety, scrollView: scrollView)
                }
            }
            
           
        }
        
        
    }
    
    func moveHeadrView(newoffety:CGFloat,oldoffety:CGFloat,scrollView:UIScrollView) {
        
        let y = newoffety - oldoffety
        
        if y > 0 {
        
            if self.selectView.frame.minY > self.returnTopHeight(){
                var fram = self.selectView.frame
                fram.origin.y = fram.origin.y - y
                self.selectView.frame = fram
            }
            
        }
        
        if y < 0 {
            
            //当头刚下拉进屏幕
            if newoffety-scrollView.contentInset.top<0 {
                if self.selectView.frame.minY <  self.returnTopHeight()+CGFloat(self.headerHeight!) {
                    var fram = self.selectView.frame
                    fram.origin.y = fram.origin.y - y
                    self.selectView.frame = fram
                }
            }
            
        }
        
        if self.selectView.frame.minY >= self.returnTopHeight()+CGFloat(self.headerHeight!){
            self.selectView.frame = CGRect(x:0.0, y:headerHeight! + Double(self.returnTopHeight()),width:Double(self.view.frame.width), height:selectViewHeight)
        }
        if self.selectView.frame.minY <= self.returnTopHeight() {
             self.selectView.frame = CGRect(x:0.0, y: Double(self.returnTopHeight()),width:Double(self.view.frame.width), height:selectViewHeight)
        }
        

        
        self.headerView?.frame = CGRect(x: 0, y: self.selectView.frame.minY-CGFloat(self.headerHeight!), width: self.view.frame.width, height: CGFloat(self.headerHeight!))
        
        
        
    }
    
    func reloadView() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.initPageViewController()
            self.initSegmentView()
        }
        
      
    }
    
    func returnTopHeight() -> CGFloat {
        return (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
    }
    
    private func initPageViewController(){
        self.myPageVc = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        if self.sideChangePageEnabel != nil {
            
            self.myPageVc.delegate = self;
            self.myPageVc?.dataSource = self;
        }
        self.addChildViewController(self.myPageVc!)
        self.myPageVc?.didMove(toParentViewController: self)
        self.view.addSubview((self.myPageVc?.view)!)
        self.findeScrollerView.delegate = self
    }
    private func initSegmentView(){
        
        self.selectView = SSScrollSelectView.init(frame: CGRect(x:0.0, y:headerHeight! + Double(self.returnTopHeight()),width:Double(self.view.frame.width), height:selectViewHeight), titles: self.selectTitles as! Array<String>)
        self.selectView.backgroundColor = UIColor.lightGray
        self.view.addSubview(self.selectView!)
        self.view.bringSubview(toFront: self.selectView!)
        
        self.selectView.selectView { (selectView, index) in
            
            self.isTouchSelectView = true
            
            var direction:UIPageViewControllerNavigationDirection
            if self.currectIndex!  > index {
                direction = UIPageViewControllerNavigationDirection.reverse
            }else{
                direction = UIPageViewControllerNavigationDirection.forward
            }
            self.myPageVc.setViewControllers([self.selectViewControllers![index] as! UIViewController],
                                             direction: direction,
                                             animated:true,
                                             completion: { (finished) in
                                                
                                              
            })
            self.currectIndex = index
            self.myPageVc.view.frame = CGRect(x: 0, y: self.returnTopHeight(), width: self.view.frame.width, height: self.view.frame.height-self.returnTopHeight())
            self.refreshScrollViewContentOffet()
            
        }
        if self.headerView != nil {
            self.view.addSubview(self.headerView!)

        }
        self.headerView?.frame = CGRect(x: 0, y: self.returnTopHeight(), width: self.view.frame.width, height: CGFloat(self.headerHeight!))
        
    }
    
   
    fileprivate func returnIndex(viewController:UIViewController) -> Int? {
        if (self.selectViewControllers?.contains(viewController))! {
            return self.selectViewControllers?.index(of:viewController)
        }
        return nil
    }
    
    fileprivate func returnViewController(index:NSInteger) -> UIViewController? {
        if index > (self.selectViewControllers?.count)! {
            return nil
        }else{
            return self.selectViewControllers?.object(at: index) as? UIViewController
        }
    }
    
    func refreshScrollViewContentOffet() {
        //设置其他的scrollview位置错位
        guard self.pageType == .headerType  else {
            return;
        }
        
        for vc in self.selectViewControllers! {
            if (self.selectViewControllers![self.currectIndex] as! UIViewController).isEqual(vc){
                for subView in (vc as AnyObject).view.subviews {
                    
                    if subView.isKind(of: UIScrollView.classForCoder()) {
                        let subScrollView = subView as! UIScrollView
                        NSLog("%lf",subScrollView.contentOffset.y+self.selectView.frame.maxY-self.returnTopHeight())
                        if subScrollView.contentOffset.y+self.selectView.frame.maxY-self.returnTopHeight()<0 {
                            subScrollView.setContentOffset(CGPoint(x:0,y:self.returnTopHeight()-self.selectView.frame.maxY), animated: false)
                        }
                        break;
                    }
                }
            }
            
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SSPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = self.returnIndex(viewController: viewController)

        guard index != nil else {
            return nil;
        }
        
        index = index! + 1
        guard index == self.selectViewControllers?.count else {
            return self.returnViewController(index: index!)
        }
       return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var  index = self.returnIndex(viewController: viewController)

        guard index != nil else {
            return nil;
        }
        guard index == 0 else {
            index = index! - 1
            return self.returnViewController(index: index!)

        }
       return nil
    }
    
    
}

extension SSPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.selectView .changeSelectView(selectIndex: self.currectIndex) {
            
        }
    }
}


extension SSPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard self.self.isTouchSelectView == false else {return}
        
        let vc = self.selectViewControllers![self.currectIndex] as! UIViewController
        let currentRect = vc.view.superview?.convert(vc.view.frame, to: UIApplication.shared.keyWindow)
        let minX = currentRect?.minX
        
        var selectIndex:Int = 0
        var progress:Float = 0
        if Float(minX!) > 0 {
            if self.currectIndex > 0 {
                selectIndex = self.currectIndex-1
                progress = Float(minX!/self.view.frame.width)
                self.selectView.changeSelectView(selectIndex: selectIndex, progress:Float(progress))

            }
        }
        if Float(minX!) < 0 {
            if self.currectIndex < (self.selectTitles?.count)!-1 {
                selectIndex = self.currectIndex+1
                progress = Float(minX!/self.view.frame.width)
                self.selectView.changeSelectView(selectIndex: selectIndex, progress:Float(progress))

            }
        }
        
        }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isTouchSelectView = false
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }
    
}





