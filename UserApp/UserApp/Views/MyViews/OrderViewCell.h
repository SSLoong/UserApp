//
//  OrderViewCell.h
//  UserApp
//
//  Created by perfect on 16/4/21.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderViewCell : UITableViewCell

@property(nonatomic,strong)UILabel * timeLabel;

@property(nonatomic,strong)UILabel * statusLabel;

@property(nonatomic,strong)UIView * firstView;


@property(nonatomic,strong)UIImageView * firstImage;

@property(nonatomic,strong)UIImageView * secondImage;

@property(nonatomic,strong)UIImageView * thirdImage;

@property(nonatomic,strong)UIImageView * fourImage;

@property(nonatomic,strong)UIImageView * moreImage;

@property(nonatomic,strong)UIView * secondView;


@property(nonatomic,strong)UILabel * waysLabel;

@property(nonatomic,strong)UILabel * numLabel;

@property(nonatomic,strong)UILabel * priceLabel;

@property(nonatomic,strong)UIView * thirdView;


@property(nonatomic,strong)UIButton * oneBtn;

@property(nonatomic,strong)UIButton * twoBtn;


-(void)configModel:(OrderModel*)model;

@end
