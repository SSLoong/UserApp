//
//  AppUtil.h
//  BusinessApp
//
//  Created by prefect on 16/3/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Util.h"
#import "UIColor+Util.h"
@class MBProgressHUD;

@interface AppUtil : NSObject


+(CGFloat)getScreenWidth;

+(CGFloat)getScreenHeight;

+ (BOOL)isNetworkExist;

+ (MBProgressHUD *)createHUD;

+(NSString *)getStartTime;

+(NSString *)getEndTime;

//获取设备版本
+ (NSString*)deviceVersion;

//设备唯一标识
+ (NSString*)UUIDString;

//获取站点代码
+(NSString *)getCityCode:(NSString *)cityCode;

@end
