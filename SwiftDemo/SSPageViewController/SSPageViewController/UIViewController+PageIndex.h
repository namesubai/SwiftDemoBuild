//
//  UIViewController+PageIndex.h
//  SSPageViewController
//
//  Created by quanminqianbao on 2018/1/13.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChangePageBlock)(NSInteger index);

@interface UIViewController (PageIndex)


- (void)changePageAction:(ChangePageBlock)block;
@property (nonatomic, copy)ChangePageBlock changePageBlock;
@property (nonatomic, assign) NSInteger index;
@end
