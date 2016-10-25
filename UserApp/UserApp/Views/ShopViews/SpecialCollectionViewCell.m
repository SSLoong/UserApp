//
//  SpecialCollectionViewCell.m
//  UserApp
//
//  Created by prefect on 16/4/15.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SpecialCollectionViewCell.h"

@implementation SpecialCollectionViewCell


-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
        
    }
    return self;
}


-(void)setModel:(SpecialModel *)model{
    
    [_logoImage sd_setImageWithURL:[NSURL URLWithString:model.poster_pic] placeholderImage:[UIImage imageNamed:@"logo_place"]];
    
    _timeLabel.text = model.expire;
    
    
    if ([model.type integerValue] == 1) {
        
        _titleLabel.text = model.goods[@"goods_name"];

        _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.goods[@"price"]];
    }else{
    
        _titleLabel.text = model.subject;
        
        _priceLabel.text = nil;
        
    }
    
    _strategyLabel.attributedText = model.iconAttributedString;
    
    _nameLabel.text = model.store_name;
    
}

-(void)initSubviews{

    
    _logoImage = [UIImageView new];
    _logoImage.image = [UIImage imageNamed:@"logo_place"];
    [self.contentView addSubview:_logoImage];
    
    _footerView = [UIView new];
    _footerView.backgroundColor = [UIColor grayColor];
    _footerView.alpha = 0.8;
    [_logoImage addSubview:_footerView];
    
    _mapImage = [UIImageView new];
    _mapImage.image = [UIImage imageNamed:@"shop_date"];
    [_footerView addSubview:_mapImage];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:12.f];
    _timeLabel.backgroundColor = [UIColor clearColor];
    [_footerView addSubview:_timeLabel];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = AppMediumFont;
    [self.contentView addSubview:_titleLabel];
    
    
    _priceLabel = [UILabel new];
    _priceLabel.font = AppMediumFont;
    _priceLabel.textColor = AppBackgroundColor;
    [self.contentView addSubview:_priceLabel];
    
    _strategyLabel = [UILabel new];
    _strategyLabel.textColor = AppBackgroundColor;
    _strategyLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_strategyLabel];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = AppMediumFont;
    [self.contentView addSubview:_nameLabel];

}


-(void)setLayout{

    __weak typeof(self) weakSelf = self;
    
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        
        make.bottom.equalTo(_titleLabel.mas_top).offset(-10.f);
        
        make.size.mas_equalTo(CGSizeMake(weakSelf.bounds.size.width, weakSelf.bounds.size.width));
        
    }];
    
    
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(16);
        make.bottom.equalTo(_logoImage.mas_bottom);
        make.right.left.mas_equalTo(0);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(12);
        make.centerX.mas_equalTo(_footerView.mas_centerX);
        make.centerY.mas_equalTo(_footerView.mas_centerY);
        
    }];
    
    [_mapImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.right.mas_equalTo(_timeLabel.mas_left).offset(-3);
        make.centerY.mas_equalTo(_footerView.mas_centerY);
        
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_priceLabel.mas_top).offset(-5.f);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(12);
    }];
    
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_strategyLabel.mas_top).offset(-5.f);
        make.height.mas_offset(13);
        make.left.mas_equalTo(0);
    }];

    
    [_strategyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.equalTo(_nameLabel.mas_top).offset(-5.f);
        make.height.mas_equalTo(12);
    }];

    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.mas_equalTo(0);
    }];
    
}


@end
