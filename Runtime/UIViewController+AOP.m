//
//  UIViewController+AOP.m
//  Runtime
//
//  Created by 丁丁 on 15/11/20.
//  Copyright © 2015年 huangyanan. All rights reserved.
//

#import "UIViewController+AOP.h"
#import <objc/runtime.h>

static inline void swizzleSelector(Class clazz,SEL originalSelector , SEL swizzledSelector) {
    
    Class class = clazz ;
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

@implementation UIViewController (AOP)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleSelector(self, @selector(viewWillAppear:), @selector(aop_viewWillAppear:));
        swizzleSelector(self, @selector(viewWillDisappear:), @selector(aop_viewWillDisappear:));
    });
}

- (void)aop_viewWillDisappear:(BOOL)animation {
//    [self aop_viewWillDisappear:animation];
    //这里用打印类名代替统计
    //实际开发中应该是这样，以友盟为例
//    [MobClick beginLogPageView:NSStringFromClass([self class])];
    if (![self isMemberOfClass:[UINavigationController class]] && ![self isMemberOfClass:[UITabBarController class]]) {
        NSLog(@"%@ end",NSStringFromClass([self class]));
    }
    
}

- (void)aop_viewWillAppear:(BOOL)animation {
    if (![self isMemberOfClass:[UINavigationController class]] && ![self isMemberOfClass:[UITabBarController class]]) {
        NSLog(@"%@ begin",NSStringFromClass([self class]));
    }
    
}

@end
