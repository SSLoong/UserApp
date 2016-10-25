//
//  SpeciaInfoViewCell.h
//  UserApp
//
//  Created by prefect on 16/5/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialnfoModel.h"

@interface SpeciaInfoViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *logoImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIImageView *strategyImageView;

@property(nonatomic,strong)UILabel *strategyLabel;

@property(nonatomic,strong)UILabel *giftLabel;

@property(nonatomic,strong)UIImageView *timeImageView;

@property(nonatomic,strong)UILabel *timeLabel;

-(void)configModel:(SpecialnfoModel *)model;

@end
