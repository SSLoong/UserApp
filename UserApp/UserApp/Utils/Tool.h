//
//  Tool.h
//  CourseCenter
//
//  Created by jian on 15/5/13.
//  Copyright (c) 2015年 line0.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIView+Extension.h"


@interface Tool : NSObject


#pragma mark - 颜色处理
//十六进制颜色转化为UIColor
+ (UIColor *)colorWithHexString: (NSString *)color;
//背景色
+ (UIColor *)bgColor;
//黑色字体
+ (UIColor *)titleBlackColor;
//灰色字体
+ (UIColor *)titleGrayColor;
//日期的灰色
+ (UIColor *)titleGrayColorForDate;
//内容的灰色
+ (UIColor *)titleGrayColorForcontent;
//label橘色的背景
+ (UIColor *)bgOrangeColorForLabel;
//label红色的背景
+ (UIColor *)bgRedColorForLabel;
//label蓝色的背景
+ (UIColor *)bgBlueColorForLabel;
// button蓝色背景
+ (UIColor *)bgBlueColorForButton;

/** 分割线的颜色*/
+ (UIColor *)separatorColor;

#pragma mark- 时间处理

//获取现在的时间
+ (NSString *)getNowTime;
//str是返回时间字符串的格式
+ (NSString *)getNowTimeWithFomatterStr:(NSString *)str;

//将时间转换为时间戳(Since1970)
+ (NSTimeInterval)timeToTimestamp:(NSString *)timeStr;
//时间戳转换为时间
+ (NSString *)timestampToTime:(NSTimeInterval)timestamp;
//获取某个时间和当前时间的差值
+ (NSTimeInterval)timeToNow:(NSString *)timeStr;



#pragma mark- 判断

//判断字典是否有某key值
+(BOOL)dicContainsKey:(NSDictionary *)dic keyValue:(NSString *)key;
//判断对象是否为空
+(BOOL)objectIsEmpty:(id)object;
//判断字符串是否为空
+ (BOOL)strIsEmpty:(NSString *)object;
//判断是否是纯数字;(含有小数点也返回YES)
+ (BOOL)isNumber:(NSString *)numberStr;



//判断手机号是否有效
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//校验银行卡卡号
+ (BOOL)isBankNumber:(NSString *)bankNum;
//校验身份证号码
+ (BOOL)checkIdentityCardNo:(NSString*)cardNo;
//校验是否为中文
+ (BOOL)isChinese:(NSString *)str;

//判断邀请码是否正确;
+ (BOOL)isNumberOrNil:(NSString *)recommendedTelStr;
//判读是否是正确格式的密码
+ (BOOL)isRightPassworld:(NSString *)passWorld;


#pragma mark - 字符串处理
//转化成带逗号的钱数
+ (NSString *)numFormaterWithNUmber:(NSNumber *)number;
+ (NSString *)floatFormaterWithNUmber:(NSNumber *)number;
//带逗号的钱数转化成float
+ (float)stringFormaterToFloat:(NSString *)string;
//在字符串指定范围添加下划线
+ (NSMutableAttributedString *)addUnderLineWithString:(NSString *)str atRange:(NSRange)range;
//改变字符串指定范围的字体颜色
+ (NSMutableAttributedString *)addColorWithString:(NSString *)str atRange:(NSRange)range withColor:(UIColor *)color;

//将对象装换为dic
+ (NSMutableDictionary *)dictFromObject:(id)object;
//将一个数组转换为json格式
+ (NSString *)jsonFromArray:(NSArray *)array;
//将一个数组里的对象转换为字典
+ (NSArray *)arrayFormObjectArray:(NSArray *)array;


//获取当前显示页面控制器
+ (UIViewController *)getCurrentVC;


@end
