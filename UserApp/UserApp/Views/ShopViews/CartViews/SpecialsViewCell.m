//
//  SpecialsViewCell.m
//  UserApp
//
//  Created by prefect on 16/5/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SpecialsViewCell.h"

@implementation SpecialsViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}


-(void)configModel:(SpecialsModel *)model{
    
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:model.poster_pic] placeholderImage:[UIImage imageNamed:@"logo_place"]];
    
    _titleLabel.text = model.subject;
    
    if ([model.mk_strategy integerValue] == 3) {
        _strategyImageView.image = [UIImage imageNamed:@"shop_zeng"];
    }else{
        _strategyImageView.image = [UIImage imageNamed:@"shop_jian"];
    }
    
    _strategyLabel.text = model.strategy;
    
    if([model.marketing[@"gift_goods"] isKindOfClass:[NSArray class]]){
        
        NSDictionary *dic = [model.marketing[@"gift_goods"] firstObject];
        _giftLabel.text = [NSString stringWithFormat:@"%@ x%@",dic[@"goods_name"],dic[@"num"]];

    } else{

        _giftLabel.text = nil;
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
}


-(void)setLayout{
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.left.equalTo(_logoImageView.mas_right).offset(10.f);
    }];
    
    
    [_strategyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_logoImageView.mas_bottom);
        make.left.equalTo(_logoImageView.mas_right).offset(10.f);
        
    }];

    
    [_strategyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_strategyImageView.mas_right).offset(3.f);
        make.bottom.equalTo(_logoImageView.mas_bottom);
        make.height.mas_equalTo(13);
    }];
    
    [_giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_strategyLabel.mas_right).offset(3.f);
        make.bottom.equalTo(_logoImageView.mas_bottom);
    }];
    
}
@end
