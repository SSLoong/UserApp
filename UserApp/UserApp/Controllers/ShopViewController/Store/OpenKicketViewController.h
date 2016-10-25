//
//  OpenKicketViewController.h
//  BusinessApp
//
//  Created by prefect on 16/3/23.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectRows)(NSString *titleString);


@interface OpenKicketViewController : UITableViewController

@property(nonatomic,assign)NSInteger num;

@property(nonatomic,strong)selectRows selectRows;

@end
