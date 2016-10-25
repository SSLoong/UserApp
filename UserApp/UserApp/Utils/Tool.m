//
//  Tool.m
//  CourseCenter
//
//  Created by jian on 15/5/13.
//  Copyright (c) 2015年 line0.com. All rights reserved.
//

#import "Tool.h"

#import <objc/runtime.h>

@implementation Tool

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
        // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
        // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
        // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
        //r
    NSString *rString = [cString substringWithRange:range];
    
        //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
        //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
        // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIColor *)bgColor
{
    return [self colorWithHexString:@"#f5f4f9"];
}

+ (UIColor *)titleBlackColor
{
    return [self colorWithHexString:@"#20222e"];
}
+ (UIColor *)titleGrayColor
{
    return [self colorWithHexString:@"#999ea3"];
}

+ (UIColor *)titleGrayColorForDate {
    return [self colorWithHexString:@"#999999"];
}

+ (UIColor *)titleGrayColorForcontent {
    return [self colorWithHexString:@"#8c8c8c"];
}
+ (UIColor *)bgOrangeColorForLabel {
    return [self colorWithHexString:@"#ffb74d"];
}
+ (UIColor *)bgRedColorForLabel {
    return [self colorWithHexString:@"#ff5252"];
}
+ (UIColor *)bgBlueColorForLabel {
    return [self colorWithHexString:@"#00aaef"];
}
+ (UIColor *)bgBlueColorForButton {
    return [self colorWithHexString:@"#00aaef"];
}

+ (UIColor *)separatorColor {
    return [self colorWithHexString:@"#e1e6eb"];
}

+ (NSString *)getNowTime
{
    return [Tool getNowTimeWithFomatterStr:@"yyyy-MM-dd"];
}

+ (NSString *)getNowTimeWithFomatterStr:(NSString *)str
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:str];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;

}

//将时间转换为时间戳
+ (NSTimeInterval)timeToTimestamp:(NSString *)timeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:timeStr];
    NSTimeInterval timesp = [date timeIntervalSince1970];
    formatter = nil;
    return timesp;
}

+ (NSTimeInterval)timeToNow:(NSString *)timeStr
{
    NSString * now = [Tool getNowTime];
    NSTimeInterval  time1 = [Tool timeToTimestamp:timeStr];
    NSTimeInterval time2 = [Tool timeToTimestamp:now];
    return time2 - time1;
    
}


//时间戳转换为时间
+ (NSString *)timestampToTime:(NSTimeInterval)timestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = nil;
    date  = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *timeStr = [formatter stringFromDate:date];
    formatter = nil;
    return timeStr;
}










+ (NSMutableDictionary *)dictFromObject:(id)object
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [object valueForKey:(NSString *)propertyName];
        if ([propertyValue isKindOfClass:[NSArray class]] || [propertyValue isKindOfClass:[NSMutableArray class]]) {
            propertyValue = [self arrayFormObjectArray:propertyValue];
        } else if ([propertyValue isKindOfClass:[NSObject class]]) {
            propertyValue = [self dictFromObject:propertyValue];
        }
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
    
}

+ (NSString *)jsonFromArray:(NSArray *)array
{
    NSMutableArray *dics = [[NSMutableArray alloc] initWithCapacity:0];
    for (id object in array) {
        NSDictionary *dic = [self dictFromObject:object];
        [dics addObject:dic];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
    
}

+ (NSArray *)arrayFormObjectArray:(NSArray *)array
{
    NSMutableArray *dics = [[NSMutableArray alloc] initWithCapacity:0];
    for (id object in array) {
        NSDictionary *dic = [self dictFromObject:object];
        [dics addObject:dic];
    }
    return dics;
}

    //判断字典是否有某key值
+(BOOL)dicContainsKey:(NSDictionary *)dic keyValue:(NSString *)key
{
    
    if ([self objectIsEmpty:dic]) {
        return NO;
    }
    
    NSArray *keyArray = [dic allKeys];
    
    if ([keyArray containsObject:key]) {
        
        return YES;
    }
    return NO;
}

//判断对象是否为空
+ (BOOL)objectIsEmpty:(id)object
{
    if ([object isEqual:[NSNull null]]) {
        return YES;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (nil == object){
        return YES;
    }
    return NO;
}

//判断字符串是否为空
+ (BOOL)strIsEmpty:(NSString *)object
{
    if ([object isEqual:[NSNull null]])
    {
        return YES;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (nil == object)
    {
        return YES;
    }else if ([object isEqualToString:@""])
    {
        return YES;
    }
    return NO;
}


//判断密码格式是否正确
+ (BOOL)isRightPassworld:(NSString *)passWorld
{
    BOOL one = NO;
    BOOL two = NO;
    BOOL three = NO;
    //判断长度
    if ([passWorld length] >= 6 && [passWorld length] <= 16) {
        one = YES;
    }
    //判断是否含有字母和数字
    for (int i = 0;i < [passWorld length]; i++) {
        char a = [passWorld characterAtIndex:i];
        if (a >= '0' && a <= '9' ) {
            two = YES;
        }
        if (a >= 'A' && a <= 'z') {
            three = YES;
        }
    }
    
    if (one && two && three) {
        return YES;
    }else{
        return NO;
    }
}


//判断邀请码是否正确;
+ (BOOL)isNumberOrNil:(NSString *)recommendedTelStr
{
    BOOL result = NO;
    
    if (recommendedTelStr == nil || [recommendedTelStr isEqualToString:@""]) {
        result = YES;
    }else{
        
        if ([recommendedTelStr hasPrefix:@"800"]) {
            if ([recommendedTelStr length] >= 4 && [recommendedTelStr length] <= 11) {
                if ([self isNumber:recommendedTelStr]) {
                    result = YES;
                }
            }
        }else if ([recommendedTelStr hasPrefix:@"1"]){
            if ([self isMobileNumber:recommendedTelStr]) {
                result = YES;
            }
        }
     }
    return result;
}

//判断是否是纯数字;
+ (BOOL)isNumber:(NSString *)numberStr
{ BOOL result = YES;
    for (int i = 0; i < [numberStr length];i++) {
        if (([numberStr characterAtIndex:i] < '0' && [numberStr characterAtIndex:i] != '.')
            || ([numberStr characterAtIndex:i] > '9' && [numberStr characterAtIndex:i] != '.')) {
            result = NO;
            
        }
    }
    return result;
}


//判断手机号是否有效
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,147,183
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181
     */
    NSString * MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0-9]|8[0-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，183
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[156])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
// 校验银行卡卡号
+ (BOOL)isBankNumber:(NSString *)cardNo
{
        int oddsum = 0;     //奇数求和
        int evensum = 0;    //偶数求和
        int allsum = 0;
        int cardNoLength = (int)[cardNo length];
        int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
        
        cardNo = [cardNo substringToIndex:cardNoLength - 1];
        for (int i = cardNoLength -1 ; i>=1;i--) {
            NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
            int tmpVal = [tmpString intValue];
            if (cardNoLength % 2 ==1 ) {
                if((i % 2) == 0){
                    tmpVal *= 2;
                    if(tmpVal>=10)
                        tmpVal -= 9;
                    evensum += tmpVal;
                }else{
                    oddsum += tmpVal;
                }
            }else{
                if((i % 2) == 1){
                    tmpVal *= 2;
                    if(tmpVal>=10)
                        tmpVal -= 9;
                    evensum += tmpVal;
                }else{
                    oddsum += tmpVal;
                }
            }
        }
        allsum = oddsum + evensum;
        allsum += lastNum;
        if((allsum % 10) == 0)
            return YES;
        else
            return NO;
}
// 校验身份证号
+ (BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}
// 校验是否为中文
+ (BOOL)isChinese:(NSString *)str {
    BOOL result = YES;
    for(int i = 0; i < [str length];i++){
        int a = [str characterAtIndex:i];
        if( a < 0x4e00 || a > 0x9fff)
        {
            result = NO;
            break;
        }
    }
    return result;
}



+ (NSDictionary *)jsonToDictionary:(NSString *)jsonString
{
    NSDictionary *JSON;
    if (jsonString && ![jsonString isEqual:[NSNull null]]) {
        NSError *error;
        JSON = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    }
    return JSON;
}

+ (NSString *)numFormaterWithNUmber:(NSNumber *)number {
    NSString *formaterStr = nil;
    if (number) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.formatterBehavior = NSDateFormatterBehavior10_4;
        formaterStr = [formatter stringFromNumber:number];
    }
    return formaterStr;
    
}
+ (NSString *)floatFormaterWithNUmber:(NSNumber *)number {
    NSString *formaterStr = nil;
    if (number) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
        formatter.formatterBehavior = NSDateFormatterBehavior10_4;
        formaterStr = [formatter stringFromNumber:number];
        formaterStr = [[formaterStr componentsSeparatedByString:@"US$"] lastObject];
        formaterStr = [[formaterStr componentsSeparatedByString:@"GP"] lastObject];
        formaterStr = [[formaterStr componentsSeparatedByString:@"CN¥"] lastObject];
        formaterStr = [[formaterStr componentsSeparatedByString:@"￥ "] lastObject];
        formaterStr = [[formaterStr componentsSeparatedByString:@"￥"] lastObject];
        formaterStr = [[formaterStr componentsSeparatedByString:@"$"] lastObject];
//        formaterStr = [formaterStr substringFromIndex:1];
    }
    return formaterStr;
    
}

+ (float )stringFormaterToFloat:(NSString *)string
{
    float floatMoney = 0.;
    if (![string isEqualToString:@""] && ![string isEqual:[NSNull null]])
    {
        floatMoney = [[NSString stringWithFormat:@"%.2f",[[string stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue]] floatValue];
    }
    return floatMoney;
}

+ (NSMutableAttributedString *)addUnderLineWithString:(NSString *)str atRange:(NSRange)range


{         NSMutableAttributedString * result = [[NSMutableAttributedString alloc]initWithString:str];
    
    [result addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
    
    
    return result;
}

+ (NSMutableAttributedString *)addColorWithString:(NSString *)str atRange:(NSRange)range withColor:(UIColor *)color
{
    NSMutableAttributedString * result = [[NSMutableAttributedString alloc]initWithString:str];
    
    [result addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    
    return result;

}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


@end
