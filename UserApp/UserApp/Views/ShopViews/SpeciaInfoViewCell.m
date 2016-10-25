//
//  SpeciaInfoViewCell.m
//  UserApp
//
//  Created by prefect on 16/5/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SpeciaInfoViewCell.h"

@implementation SpeciaInfoViewCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
        
    }
    return self;
}


-(void)configModel:(SpecialnfoModel *)model{

    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:model.poster_pic] placeholderImage:[UIImage imageNamed:@"logo_place"]];

    _titleLabel.text = model.subject;
    
    _timeLabel.text = model.surplus_time;
    
    if ([model.mk_strategy integerValue] == 3) {
        
        _strategyImageView.image = [UIImage imageNamed:@"shop_zeng"];
    }else{
        _strategyImageView.image = [UIImage imageNamed:@"shop_jian"];
    }
    
    _strategyLabel.text = model.strategy;

    
    if([model.gift_goods isKindOfClass:[NSArray class]]){

        NSDictionary *dic = [model.gift_goods firstObject];
        _giftLabel.text = [NSString stringWithFormat:@"%@ x%@",dic[@"goods_name"],dic[@"num"]];

    }

}


-(void)initSubviews{
    
    
    _logoImageView = [UIImageView new];
    [self.contentView addSubview:_logoImageView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    
    _strategyImageView = [UIImageView new];
    [self.contentView addSubview:_strategyImageView];

    
    _strategyLabel = [UILabel new];
    _strategyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _strategyLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:_strategyLabel];
    
    _giftLabel = [UILabel new];
    _giftLabel.textColor = [UIColor lightGrayColor];
    _giftLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_giftLabel];
    

    _timeImageView = [UIImageView new];
    _timeImageView.image = [UIImage imageNamed:@"time"];
    [self.contentView addSubview:_timeImageView];
    
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_timeLabel];
    
}


-(void)setLayout{
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.equalTo(_logoImageView.mas_right).offset(10.f);
    }];
    
    
    [_giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_logoImageView.mas_right).offset(10.f);
        make.bottom.equalTo(_logoImageView.mas_bottom);
        make.right.mas_equalTo(0);
    }];
    
    
    [_strategyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_giftLabel.mas_top).offset(-5.f);
        make.left.equalTo(_logoImageView.mas_right).offset(10.f);
        
    }];
    

    [_strategyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_strategyImageView.mas_right).offset(3.f);
        make.bottom.equalTo(_strategyImageView.mas_bottom);
        make.height.mas_equalTo(13);
    }];

    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logoImageView.mas_top);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(13);
    }];
    
    [_timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_top);
        make.right.equalTo(_timeLabel.mas_left).offset(-3.f);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
}




@end
