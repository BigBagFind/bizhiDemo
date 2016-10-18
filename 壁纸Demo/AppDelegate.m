//
//  AppDelegate.m
//  壁纸Demo
//
//  Created by 铁拳科技 on 16/10/14.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import "AppDelegate.h"
#import "Protocols.h"
#import <Objection.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self setupRootViewController];
    
    
    return YES;
}



- (void)setupRootViewController {
    
    UITabBarController *tabViewController = [[UITabBarController alloc] init];
    
    // 拿到首页瀑布流Vc
    UIViewController *waterfallViewController = [[JSObjection defaultInjector] getObject:@protocol(BZWaterfallViewModelProtocol)];
    
    // 第一个最新nav
    UINavigationController *waterfallNavigationController = [[UINavigationController alloc] initWithRootViewController:waterfallViewController];
    waterfallViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"最新" image:[UIImage imageNamed:@"latest"] tag:0];
    waterfallViewController.title = @"最新";

    
    // 第二个分类nav
    UIViewController <BZTagsViewControllerProtocol> *tagsViewController = [[JSObjection defaultInjector] getObject:@protocol(BZTagsViewControllerProtocol)];
    UINavigationController *tagsNavigationController = [[UINavigationController alloc] initWithRootViewController:tagsViewController];
    tagsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"分类" image:[UIImage imageNamed:@"categories"] tag:1];
    tagsViewController.title = @"分类";
    
    
    // 第三个设置nav
    UIViewController <BZSettingsViewControllerProtocol> *settingsViewController = [[JSObjection defaultInjector] getObject:@protocol(BZSettingsViewControllerProtocol)];
    settingsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"settings"] tag:2];
    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    settingsViewController.title = @"设置";
    
    tabViewController.viewControllers = @[waterfallNavigationController, tagsNavigationController, settingsNavigationController];
    
    self.window.rootViewController = tabViewController;
    
    
}












@end
