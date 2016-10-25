//
//  SpecialsViewCell.h
//  UserApp
//
//  Created by prefect on 16/5/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialsModel.h"

@interface SpecialsViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *logoImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIImageView *strategyImageView;

@property(nonatomic,strong)UILabel *strategyLabel;

@property(nonatomic,strong)UILabel *giftLabel;

-(void)configModel:(SpecialsModel *)model;

@end
