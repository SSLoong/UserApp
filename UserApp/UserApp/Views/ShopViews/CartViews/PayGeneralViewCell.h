//
//  PayGeneralViewCell.h
//  UserApp
//
//  Created by prefect on 16/5/19.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralsModel.h"

@interface PayGeneralViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UILabel *numLabel;

-(void)configModel:(GeneralsModel *)model;

@end
