//
//  BZPinModel.h
//  bizhiDemo
//
//  Created by 吴玉铁 on 2016/10/28.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BZPinModel : JSONModel

// 自动转换类型
// nsnumber
@property (nonatomic, assign) NSInteger pinId;

// file - > key
@property (nonatomic, copy) NSString *key;

// nsnumber
@property (nonatomic, assign) NSInteger seq;



- (NSString *)imageURLWithThumbnailWidth:(NSInteger)width;



@end
