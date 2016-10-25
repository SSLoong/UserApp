//
//  OrderDetailViewCell.h
//  UserApp
//
//  Created by prefect on 16/5/24.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"

@interface OrderDetailViewCell : UITableViewCell

@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UILabel * numLabel;

@property(nonatomic,strong)UILabel * moneyLabel;

-(void)configModel:(OrderDetailModel *)model;

@end
