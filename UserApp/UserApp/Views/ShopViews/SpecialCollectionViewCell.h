//
//  SpecialCollectionViewCell.h
//  UserApp
//
//  Created by prefect on 16/4/15.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialModel.h"

@interface SpecialCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *logoImage;

@property(nonatomic,strong)UIView *footerView;

@property(nonatomic,strong)UIImageView *mapImage;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UILabel *strategyLabel;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)SpecialModel *model;

@end
