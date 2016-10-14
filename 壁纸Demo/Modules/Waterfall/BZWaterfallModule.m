//
//  BZWaterfallModule.m
//  壁纸Demo
//
//  Created by 铁拳科技 on 16/10/14.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import "BZWaterfallModule.h"
#import "BZWaterfallViewController.h"
#import "Protocols.h"

@implementation BZWaterfallModule


+ (void)load {
    // 初始化将自己绑定到injector上
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ?: [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure {
    [self bindClass:[BZWaterfallViewController class] toProtocol:@protocol(BZWaterfallViewModelProtocol)];
}





@end
