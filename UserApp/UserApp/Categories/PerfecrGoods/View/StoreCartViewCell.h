//
//  StoreCartViewCell.h
//  UserApp
//
//  Created by prefect on 16/5/27.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartSaleModel.h"

typedef void(^addBlock)();

@interface StoreCartViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *logoImage;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UILabel *subLabel;

@property(nonatomic,strong)UIButton *addBtn;

@property (nonatomic,copy)addBlock addBlock;

-(void)configModel:(CartSaleModel *)model;

@end
