//
//  UIColor+Util.m
//  BusinessApp
//
//  Created by prefect on 16/3/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)


+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}


@end
