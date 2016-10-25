//
//  SecurityUtil.h
//  Smile
//
//  Created by 周 敏 on 12-11-24.
//  Copyright (c) 2012年 BOX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityUtil : NSObject 

+ (NSString *)encryptAESData:(NSString *)string;

+ (NSString *)decryptAESHex:(NSString *)hexString;

@end
