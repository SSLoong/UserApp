//
//  CartTimeViewCell.m
//  UserApp
//
//  Created by prefect on 16/4/27.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "CartTimeViewCell.h"

@implementation CartTimeViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}


-(void)initSubviews{

    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"收货时间";
    _nameLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_nameLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:14.f];
    _timeLabel.textColor = [UIColor orangeColor];
    [self.contentView addSubview:_timeLabel];
    
    _moreLabel = [UILabel new];
    _moreLabel.text = @"可预订";
    _moreLabel.font = [UIFont systemFontOfSize:14.f];
    _moreLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_moreLabel];
}

-(void)setLayout{
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15.f);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self);
    }];

    
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_nameLabel.mas_right).offset(10.f);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self);
    }];
    
    
    
    [_moreLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self);
    }];
}


@end
