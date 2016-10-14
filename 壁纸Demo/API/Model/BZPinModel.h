//
//  BZPinModel.h
//  壁纸Demo
//
//  Created by 铁拳科技 on 16/10/14.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BZPinModel : JSONModel


@property (nonatomic, assign) NSInteger pinId;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, assign) NSInteger seq;



- (NSString *)imageURLWithThumbnailWidth:(NSInteger)width;



@end
