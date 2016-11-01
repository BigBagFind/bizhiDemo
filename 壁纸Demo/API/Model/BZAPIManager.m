//
//  BZAPIManager.m
//  壁纸Demo
//
//  Created by 铁拳科技 on 16/10/14.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import "BZAPIManager.h"
#import <ReactiveCocoa.h>
#import <AFNetworking-RACExtensions/AFHTTPRequestOperationManager+RACSupport.h>
#import "BZPinModel.h"
#import "BZTagModel.h"

@implementation BZAPIManager

/** 单例初始化 */
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static BZAPIManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [self manager];
    });
    return instance;
}


// 14565555
// http://api.huaban.com/fm/wallpaper/pins?limit=21&tag=
// http://api.huaban.com/fm/wallpaper/pins?limit=21&max=14565535&tag=
// http://api.huaban.com/fm/wallpaper/pins?limit=21&max=14565514&tag=
// http://api.huaban.com/fm/wallpaper/pins?limit=21&max=14565491&tag=

/** 根据tag和分页获取壁纸 */
- (RACSignal *)fetchPinsWithTag:(NSString *)tag offset:(NSInteger)offset limit:(NSInteger)limit {
    // 判断上拉或者下拉
    NSString *max = offset ? [NSString stringWithFormat:@"&max=%ld", (long)offset] : @"";
    // 判断有无带tag,有则转成utf-8
    tag = tag ? [NSString stringWithFormat:@"&tag=%@", [tag stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] : @"";
    // 完整urlString
    NSString *urlString = [NSString stringWithFormat:@"http://api.huaban.com/fm/wallpaper/pins?limit=%ld%@%@", (long)limit, max, tag];
    return [self fetchPinsWithURL:urlString];
}

/** 基础获取壁纸接口 */
- (RACSignal *)fetchPinsWithURL:(NSString *)urlString {
    
    return [[self rac_GET:urlString parameters:nil] map:^id(RACTuple *tuple) {
        NSLog(@"result :\n%@",tuple);
        NSDictionary *response = tuple.first;
        // 遍历sequence
        // dicArray -> dic -> model -> modelArray
        return [[((NSArray *)response[@"pins"]).rac_sequence map:^id(id value) {
            return [[BZPinModel alloc] initWithDictionary:value error:nil];
        }] array];
    }];
}

/** 基础获取分类接口 */
- (RACSignal *)fetchTags {
    
    return [[self rac_GET:@"http://api.huaban.com/fm/wallpaper/tags" parameters:nil] map:^id(RACTuple *tuple) {
        NSArray *tags = tuple.first;
        NSLog(@"%@",tuple);
        return [[tags.rac_sequence map:^id(id value) {
            return [[BZTagModel alloc] initWithDictionary:value error:nil];
        }] array];
    }];
    
}



@end
