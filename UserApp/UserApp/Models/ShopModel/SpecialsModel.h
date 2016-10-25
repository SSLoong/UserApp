//
//  SpecialsModel.h
//  UserApp
//
//  Created by prefect on 16/5/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialsModel : NSObject

@property(nonatomic,copy)NSString *poster_pic;

@property(nonatomic,copy)NSString *subject;

@property(nonatomic,copy)NSString *mk_strategy;

@property(nonatomic,copy)NSString *strategy;

@property(nonatomic,copy)NSString *special_id;

@property(nonatomic,strong)NSArray *goodses;

@property(nonatomic,strong)NSDictionary *marketing;

@property(nonatomic,strong)NSArray *order_giftgoods;

@end
