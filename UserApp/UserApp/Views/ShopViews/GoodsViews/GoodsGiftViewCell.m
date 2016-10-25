//
//  GoodsGiftViewCell.m
//  UserApp
//
//  Created by prefect on 16/6/24.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "GoodsGiftViewCell.h"

@implementation GoodsGiftViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}

-(void)configModel:(GoodsDetailModel *)model{

    NSDictionary *marketing = model.marketing;
    
    if([marketing[@"mk_strategy"] integerValue]==3){
    
        
        NSDictionary *dict = [marketing[@"gift_goods"] lastObject];
        _strategyImageView.image = [UIImage imageNamed:@"shop_zeng"];
        
        [_logoImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"cover_img"]] placeholderImage:[UIImage imageNamed:@"logo_place"]];
        
        _nameLabel.text = dict[@"goods_name"];
        
        _priceLabel.text = @"¥0";
        
        _oldPriceLabel.text = [NSString stringWithFormat:@"¥%@",dict[@"goods_price"]];
        
        
        NSUInteger length = _oldPriceLabel.text.length;
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_oldPriceLabel.text];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, length)];
        [_oldPriceLabel setAttributedText:attri];
        
        
        
        
        _numLabel.text = [NSString stringWithFormat:@"x%@",dict[@"num"]];
        
    }else{
    
        _strategyImageView.image = [UIImage imageNamed:@"shop_jian"];
    }
    
    _timeLabel.text = model.expire;
    
    _strategyLabel.text = model.marketing[@"subject"];
    
    
    
}

-(void)initSubviews{
    
    _backView = [UIView new];
    _backView.backgroundColor = [UIColor colorWithHex:0xFAFAFA];
    [self.contentView addSubview:_backView];
    
    _strategyImageView= [UIImageView new];
    [_backView addSubview:_strategyImageView];
    
    _strategyLabel = [UILabel new];
    _strategyLabel.textColor = AppBackgroundColor;
    _strategyLabel.font = AppMediumFont;
    [_backView addSubview:_strategyLabel];
    
    _timeImageView= [UIImageView new];
    _timeImageView.image = [UIImage imageNamed:@"time"];
    [_backView addSubview:_timeImageView];

    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = AppMediumFont;
    [_backView addSubview:_timeLabel];
    
    
    _logoImageView= [UIImageView new];
    [self.contentView addSubview:_logoImageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = AppMediumFont;
    _nameLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_nameLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.font = AppBigFont;
    _priceLabel.textColor = AppBackgroundColor;
    [self.contentView addSubview:_priceLabel];
    
    _oldPriceLabel = [UILabel new];
    _oldPriceLabel.font = AppSmallFont;
    _oldPriceLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_oldPriceLabel];
    
    _numLabel = [UILabel new];
    _numLabel.font = AppMediumFont;
    _numLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_numLabel];
    
}

-(void)setLayout{

    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.top.left.mas_equalTo(0);
        make.height.mas_equalTo(44);
        
    }];
    
    [_strategyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(_backView.mas_centerY);
    }];
    
    [_strategyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_strategyImageView.mas_right).offset(3.f);
        make.centerY.equalTo(_backView.mas_centerY);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(_backView.mas_centerY);
    }];

    [_timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_timeLabel.mas_left).offset(-3.f);
        make.centerY.equalTo(_backView.mas_centerY);
    }];
    
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logoImageView.mas_top);
        make.left.equalTo(_logoImageView.mas_right).offset(5.f);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_logoImageView.mas_bottom);
        make.left.equalTo(_logoImageView.mas_right).offset(5.f);
    }];
    
    [_oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_logoImageView.mas_bottom).offset(-1);
        make.left.equalTo(_priceLabel.mas_right).offset(4.f);
    }];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_logoImageView.mas_bottom);
        make.right.mas_equalTo(-10);
    }];
   
}


@end
