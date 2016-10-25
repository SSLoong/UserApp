//
//  CouponViewCell.h
//  UsersApp
//
//  Created by perfect on 16/4/12.
//  Copyright © 2016年 prefect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"
@interface CouponViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView * allView;

@property(nonatomic,strong)UILabel * cutLabel;

@property(nonatomic,strong)UILabel * couponLabel;

@property(nonatomic,strong)UILabel * startTimeLabel;

@property(nonatomic,strong)UILabel * zhiLabel;

@property(nonatomic,strong)UILabel * endTimeLabel;

@property(nonatomic,strong)UILabel * setLabel;

@property(nonatomic,strong)UILabel * waysLabel;

-(void)configModel:(CouponModel *)model;

@end
