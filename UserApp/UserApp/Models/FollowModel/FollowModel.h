//
//  FollowModel.h
//  UserApp
//
//  Created by prefect on 16/4/15.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowModel : NSObject

@property(nonatomic,copy)NSString *img;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *score;

@property(nonatomic,copy)NSString *address;

@property(nonatomic,copy)NSString *deliver;

@property(nonatomic,copy)NSString *deliver_amount;

@property(nonatomic,copy)NSString *distance;

@property(nonatomic,copy)NSString *store_id;

@property(nonatomic,assign)int sub;

@property(nonatomic,assign)int give;

@property(nonatomic,copy)NSMutableAttributedString *iocnAttributedString;

@end
