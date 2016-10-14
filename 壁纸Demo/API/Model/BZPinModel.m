
//
//  BZPinModel.m
//  壁纸Demo
//
//  Created by 铁拳科技 on 16/10/14.
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


/*
http://img.hb.aicdn.com/f362323d476fa2aa4cb4876be2638d2126881a7b17e97-A6L6FC_fw236
http://img.hb.aicdn.com/f362323d476fa2aa4cb4876be2638d2126881a7b17e97-A6L6FC_fw658
*/

- (NSString *)imageURLWithThumbnailWidth:(NSInteger)width {
    return [NSString stringWithFormat:@"http://img.hb.aicdn.com/%@_fw%ld", self.key, (long)width];
}







@end
