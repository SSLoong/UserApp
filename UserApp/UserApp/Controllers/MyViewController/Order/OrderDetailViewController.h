//
//  OrderDetailViewController.h
//  UserApp
//
//  Created by prefect on 16/5/24.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : UIViewController

@property(nonatomic,copy)NSString * order_id;

@property(nonatomic,strong)NSDictionary *resultDic;

@property(nonatomic,copy)NSString *payResoult;

@end
