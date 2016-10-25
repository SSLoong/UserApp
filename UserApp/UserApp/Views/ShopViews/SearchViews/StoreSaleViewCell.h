//
//  StoreSaleViewCell.h
//  UserApp
//
//  Created by prefect on 16/5/16.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreSaleModel.h"

@interface StoreSaleViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *logoImage;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UIImageView *starImage;

@property(nonatomic,strong)UIImageView *starGaryImage;

@property(nonatomic,strong)UILabel *gradeLabel;

@property(nonatomic,strong)UILabel *addressLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UIView *lineView;

@property(nonatomic,strong)UILabel *typeLabel;

-(void)configModel:(StoreSaleModel *)model;

@end
