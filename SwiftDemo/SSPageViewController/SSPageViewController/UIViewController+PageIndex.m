//
//  UIViewController+PageIndex.m
//  SSPageViewController
//
//  Created by quanminqianbao on 2018/1/13.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

#import "UIViewController+PageIndex.h"
#import <objc/runtime.h>

@implementation UIViewController (PageIndex)
+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(scrollpage_viewDidAppear:) with:@selector(viewDidAppear:)];
    });
}

- (void)setChangePageBlock:(ChangePageBlock)changePageBlock{
    objc_setAssociatedObject(self, @selector(changePageBlock), changePageBlock, OBJC_ASSOCIATION_COPY);
    
}
- (ChangePageBlock)changePageBlock{
    return objc_getAssociatedObject(self, _cmd);
}



- (NSInteger)index {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setIndex:(NSInteger)index {
    objc_setAssociatedObject(self, @selector(index), @(index), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)scrollpage_viewDidAppear:(BOOL)animated {
    [self scrollpage_viewDidAppear:animated];
    if (self.changePageBlock) {
        self.changePageBlock(self.index);
    }
}

- (void)changePageAction:(ChangePageBlock)block{
    self.changePageBlock = block;
}

@end
