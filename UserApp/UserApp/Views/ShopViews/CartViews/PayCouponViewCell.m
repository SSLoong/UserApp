//
//  PayCouponViewCell.m
//  UserApp
//
//  Created by prefect on 16/5/19.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "PayCouponViewCell.h"

@implementation PayCouponViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    
    return self;
}



-(void)initSubviews{
    
    _logoImage = [UIImageView new];
    _logoImage.image = [UIImage imageNamed:@"ticket"];
    [self.contentView addSubview:_logoImage];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"优惠券";
    _nameLabel.font= [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_nameLabel];
    
    _couponLabel = [UILabel new];
    _couponLabel.font= [UIFont systemFontOfSize:14.f];
    _couponLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_couponLabel];
}


-(void)setLayout{
    
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(9.5);
        
    }];
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(15);
        make.left.equalTo(_logoImage.mas_right).offset(10.f);
        make.height.mas_equalTo(14);
        
    }];
    
    
    [_couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(14);
        
    }];
    
}

@end
