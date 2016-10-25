//
//  PayTableViewCell.m
//  UserApp
//
//  Created by prefect on 16/4/25.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "PayTableViewCell.h"

@implementation PayTableViewCell



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
    [self.contentView addSubview:_logoImage];
    
    _nameLabel = [UILabel new];
    _nameLabel.font= [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_nameLabel];
    
    
    _chooseImage = [UIImageView new];
    [self.contentView addSubview:_chooseImage];
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
    
    
    [_chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(20, 20));
        
        make.right.mas_equalTo(-15);
        
        make.top.mas_equalTo(11);
        
    }];
    
}


-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        _chooseImage.image = [UIImage imageNamed:@"pay_selelet"];
    }else{
        _chooseImage.image = [UIImage imageNamed:@"pay_unselelet"];
    }
}


@end
