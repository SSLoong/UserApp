//
//  CouponModel.h
//  UserApp
//
//  Created by perfect on 16/4/14.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject

@property(nonatomic,copy)NSString * title;

@property(nonatomic,copy)NSString * expire_time;

@property(nonatomic,copy)NSString * full_amount;

@property(nonatomic,copy)NSString * receive_time;

@property(nonatomic,copy)NSString * sub_amount;

@property(nonatomic,copy)NSString * coupon_id;

@property(nonatomic,copy)NSString * type;

@property(nonatomic,copy)NSString * use_store;
@end
