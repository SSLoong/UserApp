//
//  OrderModel.h
//  UserApp
//
//  Created by perfect on 16/4/21.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property(nonatomic,copy)NSString * create_time;

@property(nonatomic,strong)NSArray * imgs;

@property(nonatomic,copy)NSString * is_share;

@property(nonatomic,copy)NSString * order_id;

@property(nonatomic,copy)NSString * pay_result;

@property(nonatomic,copy)NSString * real_amount;

@property(nonatomic,copy)NSString * receive_type;

@property(nonatomic,copy)NSString * status;

@property(nonatomic,copy)NSString * total_goods;

@end
