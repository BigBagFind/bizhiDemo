//
//  BZPinModel.m
//  bizhiDemo
//
//  Created by 吴玉铁 on 2016/10/28.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import "BZPinModel.h"

@implementation BZPinModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"file.key": @"key",
                                                       @"pin_id": @"pinId",
                                                       }];
}



- (NSString *)imageURLWithThumbnailWidth:(NSInteger)width {
    NSLog(@"url:\n%@",[NSString stringWithFormat:@"http://img.hb.aicdn.com/%@_fw%ld", self.key, (long)width]);
    return [NSString stringWithFormat:@"http://img.hb.aicdn.com/%@_fw%ld", self.key, (long)width];
}



@end
