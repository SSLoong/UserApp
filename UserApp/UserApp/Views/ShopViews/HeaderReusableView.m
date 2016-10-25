//
//  HeaderReusableView.m
//  UserApp
//
//  Created by prefect on 16/4/14.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "HeaderReusableView.h"

@implementation HeaderReusableView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
    
        [self initSubview];
        
        [self setLayout];
        
    }
    return self;
}


-(void)initSubview{
    
    _colorView = [UIView new];
    _colorView.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    [self addSubview:_colorView];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:_titleLabel];
    
    _moreBtn = [UIButton new];
    [_moreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [self addSubview:_moreBtn];
    
    _moreImage = [UIImageView new];
    _moreImage.image = [UIImage imageNamed:@"more"];
    [self addSubview:_moreImage];
}


-(void)setLayout{

//    __weak typeof(self) weakSelf = self;

    [_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(3);
        make.bottom.mas_equalTo(-10);
        
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(14);
        make.left.mas_equalTo(_colorView.mas_right).offset(10.f);
        
    }];
    
    [_moreImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(7, 14));
        make.right.mas_equalTo(-10);
        
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(14);
        make.right.equalTo(_moreImage.mas_left).offset(-5.f);
        
    }];

}

@end
