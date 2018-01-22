//
//  SSBannerView.swift
//  SSBannerView
//
//  Created by quanminqianbao on 2018/1/20.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//


import UIKit

class BannerScaleLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let arr:NSArray = self.getCopyOfAttributes(attributes: super.layoutAttributesForElements(in: rect)! as NSArray)
        let centerX = (self.collectionView?.contentOffset.x)!+(self.collectionView?.bounds.size.width)!/CGFloat(2.0)
        for  t in arr {
            let attributes = t as! UICollectionViewLayoutAttributes
            let distance = fabs(attributes.center.x-centerX)
            let aprtScale = distance/(self.collectionView?.bounds.size.width)!
            let scale = fabs(cos(aprtScale*CGFloat(Double.pi/4)))
            attributes.transform = CGAffineTransform.init(scaleX: 1.0, y: scale)
        }
        return (arr as! [UICollectionViewLayoutAttributes])
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func getCopyOfAttributes(attributes:NSArray) -> NSMutableArray {
        let copyArr = NSMutableArray()
        
        for attribute in attributes {
            copyArr.add(attribute)
        }
        return copyArr
    }
    
}


class SSBannerCell: UICollectionViewCell {
    
    var imageView:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        self.contentView.addSubview(imageView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




enum BarnerType {
    
    case defaultType
    case cardType
}

typealias ClickBanerBlock = (_ bannerView:SSBannerView,_ index:Int) -> Void //点击图片


let CardCellSpace  = 15

class SSBannerView: UIView {
    var clickBlock:ClickBanerBlock? = nil
    lazy var myCollectionView:UICollectionView = {
        var collectionView:UICollectionView? = nil
        if self.bannerType == BarnerType.defaultType {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = self.itemSize!
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        }
        if self.bannerType == BarnerType.cardType {
            let flowLayout = BannerScaleLayout()
            flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: CGFloat(CardCellSpace), bottom: 0, right: 0)
            flowLayout.itemSize = CGSize.init(width: self.cellWidth(), height: (self.itemSize?.height)!*(self.cellWidth()/(self.itemSize?.width)!))
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = CGFloat(CardCellSpace)
            collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        }
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(SSBannerCell.classForCoder(), forCellWithReuseIdentifier: "SSBannerCell")
        self.addSubview(collectionView!)
        
        return collectionView!
    }()
    
    lazy var myPageControl:UIPageControl = {
        
        let pageControl = UIPageControl.init(frame: CGRect.zero)
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.6)
        pageControl.currentPageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        self.addSubview(pageControl)
        self.bringSubview(toFront: pageControl)
        return pageControl
    }()
    
    
    var itemSize:CGSize?
    var bannerType:BarnerType?
    var images:NSMutableArray? {
        willSet{
            newValue?.insert(newValue?.lastObject as Any, at: 0)
            newValue?.add(newValue?[1] as Any)

        }
        didSet{
            self.myCollectionView.reloadData()
            self.myPageControl.numberOfPages = (images?.count)!-2
            DispatchQueue.main.async(group: nil, qos: .default, flags: .barrier) {
                 self.myCollectionView.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            }
    
        }
    }
    
   
    convenience  init(frame: CGRect, itemSize:CGSize, bannerType:BarnerType) {
        self.init(frame: frame)
        self.itemSize = itemSize
        self.bannerType = bannerType
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    func setupView() {
        //
    }
    
    func bannerClick(block:@escaping ClickBanerBlock) {
        self.clickBlock = block
    }
    
    //返回卡片的宽度
    func cellWidth() -> CGFloat {
        return (self.itemSize?.width)! - CGFloat(CardCellSpace*4)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.bannerType == BarnerType.defaultType {
            self.myCollectionView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        }
        if self.bannerType == BarnerType.cardType {
            self.myCollectionView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: (self.itemSize?.height)!*(self.cellWidth()/(self.itemSize?.width)!))

        }
//        self.myCollectionView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.myPageControl.frame = CGRect(x: 0, y: self.frame.height-25, width: self.frame.width, height:25)
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

extension SSBannerView:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard self.clickBlock != nil else {return}
        if indexPath.item == 0 {
            self.clickBlock!(self,(self.images?.count)!-2)
        }else if indexPath.item == (self.images?.count)!-1 {
            self.clickBlock!(self,0);
        }else {
            self.clickBlock!(self,indexPath.item-1)
        }
    }
}

extension SSBannerView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.images?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:SSBannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SSBannerCell", for: indexPath) as! SSBannerCell
        if (self.images![indexPath.row] as! NSObject).isKind(of:UIImage.classForCoder()) {
            cell.imageView?.image = (self.images?[indexPath.row] as! UIImage)
        }
        if (self.images![indexPath.row] as! NSObject).isKind(of:UIImage.classForCoder()) {
            //网络下载图片
        }
        return cell
    }
    
    
}
extension SSBannerView:UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        var currentIndex:IndexPath? = nil
        var currentRect:CGRect = scrollView.bounds
        currentRect.origin.x = scrollView.contentOffset.x
        
        for cell in self.myCollectionView.visibleCells {
            if currentRect.contains(cell.frame) {
                currentIndex = self.myCollectionView.indexPath(for: cell)!
                break
            }
        }
        
        
        if currentIndex != nil {
            if currentIndex?.item == 0{
                self.myPageControl.currentPage = (self.images?.count)!-2
                self.myCollectionView.scrollToItem(at: IndexPath.init(row: (self.images?.count)!-2, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            }else if currentIndex?.item == (self.images?.count)!-1  {
                
               self.myPageControl.currentPage = 0;
               self.myCollectionView.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
                
            }else {
                self.myPageControl.currentPage = (currentIndex?.item)!-1
            }
            
        }else{
            //防止快速滑动不能切换的情况
            if scrollView.contentOffset.x < 0 {
                self.myCollectionView.scrollToItem(at: IndexPath.init(row: (self.images?.count)!-2, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            }
            if scrollView.contentOffset.x > scrollView.frame.width*CGFloat((self.images?.count)! - 1) {
                self.myCollectionView.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            }
        }
    }
   
}



