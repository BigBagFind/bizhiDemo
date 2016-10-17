//
//  UIColor+LightRandom.m
//  ios-bizhi-copy
//
//  Created by Limboy on 4/18/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "UIColor+LightRandom.h"

@implementation UIColor (LightRandom)

+ (UIColor *)lightRandom {
    // 色彩 0 - 1.0
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    // 饱和度 0.5 to 1.0, away from white
    CGFloat saturation = ( arc4random() % 128 / 256.0 );
    // 亮度 0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
