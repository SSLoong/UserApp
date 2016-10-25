//
//  NSTextAttachment+Util.m
//  UserApp
//
//  Created by prefect on 16/7/14.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "NSTextAttachment+Util.h"

@implementation NSTextAttachment (Util)

-(void)setY:(CGFloat)y{

    self.bounds = CGRectMake(0, y, self.image.size.width, self.image.size.height);
}

@end
