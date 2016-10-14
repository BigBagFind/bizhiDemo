//
//  BZTagsModule.m
//  壁纸Demo
//
//  Created by 铁拳科技 on 16/10/14.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import "BZTagsModule.h"
#import "Protocols.h"
#import "BZTagsViewController.h"


@implementation BZTagsModule


+ (void)load {
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure {
    [self bindClass:[BZTagsViewController class] toProtocol:@protocol(BZTagsViewControllerProtocol)];
}




@end
