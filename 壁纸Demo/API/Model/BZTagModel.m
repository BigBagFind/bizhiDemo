//
//  BZTagModel.m
//  bizhiDemo
//
//  Created by 吴玉铁 on 2016/10/28.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import "BZTagModel.h"

@implementation BZTagModel

// 讲tag_name 转换成tagName
+ (JSONKeyMapper *)keyMapper {
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
