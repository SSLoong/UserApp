//
//  AddressListController.h
//  UserApp
//
//  Created by prefect on 16/4/13.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didSelect)(NSString *name,NSString *phone,NSString *address,NSString *addr_id);

@interface AddressListController : UITableViewController

@property(nonatomic,copy)NSString *address;

@property(nonatomic,copy)didSelect didSelect;

@end
