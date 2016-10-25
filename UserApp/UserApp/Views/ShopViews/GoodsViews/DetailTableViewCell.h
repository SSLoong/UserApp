//
//  DetailTableViewCell.h
//  UserApp
//
//  Created by prefect on 16/4/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"

@interface DetailTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UILabel *dealerPriceLabel;

@property(nonatomic,strong)UILabel *subLabel;

@property(nonatomic,strong)UIImageView *iconImageView;

-(void)configModel:(GoodsDetailModel *)model;

@end
