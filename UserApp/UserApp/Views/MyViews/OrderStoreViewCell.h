//
//  OrderStoreViewCell.h
//  UserApp
//
//  Created by prefect on 16/5/24.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderTitleModel.h"

@interface OrderStoreViewCell : UITableViewCell

@property(nonatomic,strong)UILabel * storeLabel;

@property(nonatomic,strong)UILabel * nameLabel;

@property(nonatomic,strong)UIButton * attBtn;

@property(nonatomic,strong)UIButton * phoneBtn;

-(void)configModel:(OrderTitleModel *)model;

@end
