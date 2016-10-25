//
//  PayViewController.h
//  UserApp
//
//  Created by prefect on 16/4/25.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayViewController : UIViewController

@property(nonatomic,copy)NSString *store_id;

@property(nonatomic,copy)NSString *cart_id;

@property(nonatomic,copy)NSString *buy_type;

@property(nonatomic,copy)NSString *receive_type;

@property(nonatomic,copy)NSString *add_id;

@property(nonatomic,copy)NSString *receive_time;

@property(nonatomic,copy)NSString *memo;

@property(nonatomic,assign)CGFloat money;

@property(nonatomic,assign)CGFloat subMoney;

@property(nonatomic,strong)NSDictionary *generalsDic;

@property(nonatomic,strong)NSDictionary *specialsDic;

@end
