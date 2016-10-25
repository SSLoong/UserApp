//
//  MessageModel.h
//  UserApp
//
//  Created by perfect on 16/4/13.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property(nonatomic,copy)NSString * title;

@property(nonatomic,copy)NSString * content;

@property(nonatomic,copy)NSString * create_time;

@property(nonatomic,copy)NSString * status;

@end
