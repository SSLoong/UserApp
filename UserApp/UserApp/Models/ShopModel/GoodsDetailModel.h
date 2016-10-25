//
//  GoodsDetailModel.h
//  UserApp
//
//  Created by prefect on 16/4/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetailModel : NSObject

@property(nonatomic,strong)NSArray *imgs;

@property(nonatomic,copy)NSString *goods_name;

@property(nonatomic,copy)NSString *price;

@property(nonatomic,copy)NSString *dealer_price;

@property(nonatomic,copy)NSString *sub_amount;

@property(nonatomic,copy)NSString *goods_type;

@property(nonatomic,copy)NSString *special_id;

@property(nonatomic,copy)NSString *expire;

@property(nonatomic,strong)NSDictionary *marketing;

@property(nonatomic,strong)NSDictionary *wine;

@end