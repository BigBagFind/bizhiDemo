//
//  BZSettingModule.m
//  壁纸Demo
//
//  Created by 铁拳科技 on 16/10/14.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import "BZSettingModule.h"
#import "Protocols.h"
#import "BZSettingViewController.h"

@implementation BZSettingModule


+ (void)load {
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure {
    [self bindClass:[BZSettingViewController class] toProtocol:@protocol(BZSettingsViewControllerProtocol)];
}


@end
