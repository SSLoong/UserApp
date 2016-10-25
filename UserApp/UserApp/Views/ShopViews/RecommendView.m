//
//  RecommendView.m
//  UserApp
//
//  Created by prefect on 16/4/26.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "RecommendView.h"

@implementation RecommendView


-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}


-(void)configModel:(GoodsModel *)model{

    [_logoImage sd_setImageWithURL:[NSURL URLWithString:model.cover_img] placeholderImage:[UIImage imageNamed:@"logo_place"]];

    _nameLabel.text = model.goods_name;
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
    if ([model.sub_amount floatValue] != 0.f) {
        
        _subLabel.text = [NSString stringWithFormat:@"立减%@元",model.sub_amount];
        
    }else{
        
        _subLabel.text = nil;
    }
}

-(void)initSubviews{
    
    
    _logoImage = [UIImageView new];
    [_logoImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction)]];
    _logoImage.userInteractionEnabled = YES;
    [self addSubview:_logoImage];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = AppMediumFont;
    [self addSubview:_nameLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _priceLabel.font = AppMediumFont;
    [self addSubview:_priceLabel];
    
    _subLabel = [UILabel new];
    _subLabel.font = AppSmallFont;
    _subLabel.textColor = [UIColor whiteColor];
    _subLabel.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    _subLabel.layer.cornerRadius = 2.f;
    _subLabel.layer.masksToBounds = YES;
    [self addSubview:_subLabel];
    
}



-(void)pushAction{

    if (self.pushBlock) {
        self.pushBlock();
    }
}



-(void)setLayout{
    
        
    __weak typeof(self) weakSelf = self;
        
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
    make.top.left.mas_equalTo(0);
            
    make.size.mas_equalTo(CGSizeMake(weakSelf.bounds.size.width, weakSelf.bounds.size.width));
            
        }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_logoImage.mas_bottom).offset(5.f);
        make.right.left.mas_equalTo(0);
    }];
 
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(5.f);
        make.left.mas_equalTo(0);
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLabel.mas_top);
        make.left.equalTo(_priceLabel.mas_right).offset(5.f);
        make.height.mas_equalTo(13);
    }];

}

@end
