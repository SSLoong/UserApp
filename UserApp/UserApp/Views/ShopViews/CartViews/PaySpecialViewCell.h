//
//  PaySpecialViewCell.h
//  UserApp
//
//  Created by prefect on 16/5/19.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialsModel.h"

@interface PaySpecialViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *strategyView;

@property(nonatomic,strong)UILabel *strategyLabel;

@property(nonatomic,strong)UILabel *numLabel;

-(void)configModel:(SpecialsModel *)model;

@end
