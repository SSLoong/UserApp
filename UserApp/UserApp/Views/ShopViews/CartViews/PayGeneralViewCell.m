//
//  PayGeneralViewCell.m
//  UserApp
//
//  Created by prefect on 16/5/19.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "PayGeneralViewCell.h"

@implementation PayGeneralViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}


-(void)configModel:(GeneralsModel *)model{
    
    _nameLabel.text = model.name;
    
    _numLabel.text = [NSString stringWithFormat:@"×%@",model.buy_num];
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];

}

-(void)initSubviews{
    
    _nameLabel = [UILabel new];
    _nameLabel.font = AppBigFont;
    [self.contentView addSubview:_nameLabel];
    
    _numLabel = [UILabel new];
    _numLabel.font = AppBigFont;
    [self.contentView addSubview:_numLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.textColor = AppBackgroundColor;
    _priceLabel.font = AppMediumFont;
    [self.contentView addSubview:_priceLabel];
}




-(void)setLayout{
    
    __weak typeof(self) weakSelf = self;
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
    }];
    
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(10.f);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
    }];
    
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.right.mas_equalTo(-10.f);
    }];
    
}

@end
