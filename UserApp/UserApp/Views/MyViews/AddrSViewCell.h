//
//  AddrSViewCell.h
//  UsersApp
//
//  Created by perfect on 16/4/11.
//  Copyright © 2016年 prefect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "AddressModel.h"

@interface AddrSViewCell : MGSwipeTableCell

@property(nonatomic,strong)UIView * defaultView;

@property(nonatomic,strong)UILabel * nameLabel;

@property(nonatomic,strong)UILabel * sexLabel;

@property(nonatomic,strong)UILabel * phoneLabel;

@property(nonatomic,strong)UILabel * addressLabel;

@property(nonatomic,strong)UIButton * modBtn;

-(void)configModel:(AddressModel *)model;

@end
