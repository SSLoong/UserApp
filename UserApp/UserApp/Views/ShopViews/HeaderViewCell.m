//
//  HeaderViewCell.m
//  UserApp
//
//  Created by prefect on 16/6/23.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "HeaderViewCell.h"

@implementation HeaderViewCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    
    return self;
}



-(void)initSubviews{
    
    _scanBtn = [UIButton new];
    _scanBtn.adjustsImageWhenHighlighted = NO;
    [_scanBtn setImage:[UIImage imageNamed:@"store_scan"] forState:UIControlStateNormal];
    [self addSubview:_scanBtn];
    
    _searchBtn = [UIButton new];
    _searchBtn.adjustsImageWhenHighlighted = NO;
    [_searchBtn setImage:[UIImage imageNamed:@"store_search"] forState:UIControlStateNormal];
    [self addSubview:_searchBtn];
    
    _couponBtn = [UIButton new];
    _couponBtn.adjustsImageWhenHighlighted = NO;
    [_couponBtn setImage:[UIImage imageNamed:@"store_coupon"] forState:UIControlStateNormal];
    [self addSubview:_couponBtn];
}


-(void)setLayout{
    
    
    __weak typeof(self) weakSelf = self;
    
    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(ScreenWidth/3);
    }];
    
    
    
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.width.mas_equalTo(ScreenWidth/3);
    }];
    
    
    [_couponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(ScreenWidth/3);
    }];
    
}

@end
