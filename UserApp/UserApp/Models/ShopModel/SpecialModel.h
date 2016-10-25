//
//  SpecialModel.h
//  UserApp
//
//  Created by prefect on 16/4/15.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialModel : NSObject

@property(nonatomic,copy)NSString *poster_pic;

@property(nonatomic,copy)NSString *expire;

@property(nonatomic,copy)NSString *subject;

@property(nonatomic,assign)NSInteger mk_strategy;

@property(nonatomic,copy)NSString *strategy;

@property(nonatomic,copy)NSString *store_name;

@property(nonatomic,copy)NSString *special_id;

@property(nonatomic,copy)NSString *store_id;

@property(nonatomic,copy)NSString *type;

@property(nonatomic,strong)NSDictionary *goods;

@property(nonatomic,copy)NSMutableAttributedString *iconAttributedString;

@end
