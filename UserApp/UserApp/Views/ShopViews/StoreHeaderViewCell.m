//
//  StoreHeaderViewCell.m
//  UserApp
//
//  Created by prefect on 16/4/25.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "StoreHeaderViewCell.h"

@implementation StoreHeaderViewCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
        
    }
    return self;
}


-(void)configModel:(StoreModel *)model{
    
    [_logoImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"logo_place"]];
    
    if([model.focus integerValue]==0){
        [_followBtn setSelected:NO];
    }else{
        [_followBtn setSelected:YES];
    }
   
    _gradeLabel.text = [NSString stringWithFormat:@"%@",model.score];
    
    CGFloat score = [model.score floatValue];
    
    CGFloat w = 51*score/5.f;
    
    [_starImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(w);
        
    }];

    _addressLabel.text = model.address;
    
    
    if ([model.deliver integerValue] == 0) {
        _typeLabel.text = @"仅限自提";
    }else{
        _typeLabel.text = [NSString stringWithFormat:@"¥%@起送",model.deliver_amount];
    }
    
    _disLabel.text = model.distance;
    
    _numLabel.text = [NSString stringWithFormat:@"%@",model.fans_num];
    
}

-(void)initSubviews{
    
    
    _logoImage = [UIImageView new];
    [self.contentView addSubview:_logoImage];
    
    _starGaryImage = [UIImageView new];
    _starGaryImage.image = [UIImage imageNamed:@"star-gray"];
    [self.contentView addSubview:_starGaryImage];
    
    _starImage = [UIImageView new];
    _starImage.image = [UIImage imageNamed:@"star"];
    [self.contentView addSubview:_starImage];
    _starImage.contentMode = UIViewContentModeLeft;
    _starImage.clipsToBounds = YES;
    
    _gradeLabel = [UILabel new];
    _gradeLabel.textColor = [UIColor orangeColor];
    _gradeLabel.font = AppSmallFont;
    [self.contentView addSubview:_gradeLabel];
    
    
    _addressLabel = [UILabel new];
    _addressLabel.textColor = [UIColor lightGrayColor];
    _addressLabel.font = AppSmallFont;
    [self.contentView addSubview:_addressLabel];
    
    
    _typeLabel = [UILabel new];
    _typeLabel.textColor = [UIColor lightGrayColor];
    _typeLabel.font = AppMediumFont;
    [self.contentView addSubview:_typeLabel];
    
    
    _mapImage = [UIImageView new];
    _mapImage.image = [UIImage imageNamed:@"map-gray"];
    [self.contentView addSubview:_mapImage];
    
    _disLabel = [UILabel new];
    _disLabel.textColor = [UIColor lightGrayColor];
    _disLabel.font = AppMediumFont;
    [self.contentView addSubview:_disLabel];
    
    _numLabel = [UILabel new];
    _numLabel.textColor = [UIColor orangeColor];
    _numLabel.font = AppMediumFont;
    [self.contentView addSubview:_numLabel];
    
    _fansLabel = [UILabel new];
    _fansLabel.text = @"粉丝数";
    _fansLabel.textColor = [UIColor orangeColor];
    _fansLabel.font = AppSmallFont;
    [self.contentView addSubview:_fansLabel];
    
    
    _followBtn = [UIButton new];
    [_followBtn setImage:[UIImage imageNamed:@"shop_follow_off"] forState:UIControlStateNormal];
    [_followBtn setImage:[UIImage imageNamed:@"shop_follow_on"] forState:UIControlStateSelected];
    [self.contentView addSubview:_followBtn];    
    
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_bgView];
    
    _oneBtn = [UIButton new];
    [_oneBtn setImage:[UIImage imageNamed:@"shop_pay"] forState:UIControlStateNormal];
    [self.contentView addSubview:_oneBtn];
    
    _twoBtn = [UIButton new];
    [_twoBtn setImage:[UIImage imageNamed:@"shop_zhao"] forState:UIControlStateNormal];
    [self.contentView addSubview:_twoBtn];
    
    _threeBtn = [UIButton new];
    [_threeBtn setImage:[UIImage imageNamed:@"shop_coupon"] forState:UIControlStateNormal];
    [self.contentView addSubview:_threeBtn];

}


-(void)setLayout{
    
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60,60));
    }];
    

    [_starGaryImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_logoImage.mas_top).offset(2.f);
        make.left.equalTo(_logoImage.mas_right).offset(5.f);
        
    }];
    
    [_starImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_logoImage.mas_right).offset(5.f);
        make.bottom.equalTo(_starGaryImage.mas_bottom);
    }];
    
    [_gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_starGaryImage.mas_right).offset(2.f);
        make.top.equalTo(_logoImage.mas_top);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_starGaryImage.mas_left);
        make.top.equalTo(_starGaryImage.mas_bottom).offset(5.f);
    }];
    
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_logoImage.mas_bottom);
        make.left.equalTo(_starGaryImage.mas_left);
    }];
    
    
    [_mapImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_logoImage.mas_bottom).offset(-2.f);
        make.left.equalTo(_typeLabel.mas_right).offset(15.f);
        
    }];
    
    [_disLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_logoImage.mas_bottom);
        make.left.equalTo(_mapImage.mas_right).offset(3.f);

    }];
    
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_logoImage.mas_centerY);
        make.right.mas_equalTo(-10);
    }];

    [_fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_followBtn.mas_left).offset(-8.f);
        make.bottom.equalTo(_followBtn.mas_bottom).offset(1.f);
    }];

    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_fansLabel.mas_centerX);
        make.top.equalTo(_followBtn.mas_top).offset(-1.f);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_logoImage.mas_bottom).offset(10);
        make.right.mas_equalTo(10);
        make.left.mas_equalTo(-10);
        make.height.mas_equalTo(10);
    }];
    
    [_oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_bottom);
        make.left.mas_equalTo(0);
    }];
    
    [_twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_bottom);
        make.centerX.equalTo(_bgView.mas_centerX);
    }];
    
    [_threeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_bottom);
        make.right.mas_equalTo(0);
    }];

}



@end
