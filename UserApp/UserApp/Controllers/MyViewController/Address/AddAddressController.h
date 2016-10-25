//
//  AddAddressController.h
//  UserApp
//
//  Created by prefect on 16/4/13.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAddressController : UITableViewController

@property(nonatomic,copy)NSString *type;

@property(nonatomic,copy)NSString *addr_id;
@property(nonatomic,copy)NSString *receiver;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *province;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *area;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *site_code;
@property(nonatomic,assign)NSInteger defaultAddress;

@end
