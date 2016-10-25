//
//  GeneralViewCell.h
//  UserApp
//
//  Created by prefect on 16/5/17.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralsModel.h"

typedef void(^plusBlock)(BOOL isAdd);

@interface GeneralViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *logoImage;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UILabel *subLabel;

@property(nonatomic,strong)UIButton *minus;

@property(nonatomic,strong)UIButton *plus;

@property(nonatomic,strong)UILabel *orderCount;

@property (nonatomic,copy)plusBlock plusBlock;

-(void)configModel:(GeneralsModel *)model;
@end
