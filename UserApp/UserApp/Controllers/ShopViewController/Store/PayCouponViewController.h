//
//  PayCouponViewController.h
//  UserApp
//
//  Created by prefect on 16/5/20.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^chooseCoupon)(NSString *coupon_id,NSInteger couponMoney);

@interface PayCouponViewController : UITableViewController

@property(nonatomic,copy)NSString *store_id;

@property(nonatomic,strong)NSDictionary *generalsDic;

@property(nonatomic,strong)NSDictionary *specialsDic;

@property(nonatomic,copy)chooseCoupon chooseCoupon;

@end
