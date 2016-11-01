//
//  BZTagModel.h
//  bizhiDemo
//
//  Created by 吴玉铁 on 2016/10/28.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BZTagModel : JSONModel

@property (nonatomic, copy) NSString *tagName;

@property (nonatomic, assign) NSInteger pinCount;


@end
