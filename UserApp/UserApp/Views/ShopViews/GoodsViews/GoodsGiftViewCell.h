//
//  GoodsGiftViewCell.h
//  UserApp
//
//  Created by prefect on 16/6/24.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"

@interface GoodsGiftViewCell : UITableViewCell

@property(nonatomic,strong)UIView *backView;

@property(nonatomic,strong)UIImageView *strategyImageView;

@property(nonatomic,strong)UILabel *strategyLabel;

@property(nonatomic,strong)UIImageView *timeImageView;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIImageView *logoImageView;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UILabel *oldPriceLabel;

@property(nonatomic,strong)UILabel *numLabel;

-(void)configModel:(GoodsDetailModel *)model;

@end
