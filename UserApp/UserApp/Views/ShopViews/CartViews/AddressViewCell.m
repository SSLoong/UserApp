//
//  AddressViewCell.m
//  UserApp
//
//  Created by prefect on 16/4/27.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "AddressViewCell.h"
#import "AddressModel.h"

@implementation AddressViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}


-(void)initSubviews{
    
    _mapImage = [UIImageView new];
    _mapImage.image = [UIImage imageNamed:@"map_red"];
    [self.contentView addSubview:_mapImage];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont boldSystemFontOfSize:14.f];
    [self.contentView addSubview:_nameLabel];
    
    _phoneLabel = [UILabel new];
    _phoneLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:_phoneLabel];
    
    _addressLabel = [UILabel new];
    _addressLabel.font = [UIFont systemFontOfSize:13.f];
    _addressLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_addressLabel];
    
}

-(void)setLayout{
    

    [_mapImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_offset(CGSizeMake(12, 16));
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(15);
        make.left.equalTo(_mapImage.mas_right).offset(10.f);
        make.height.mas_equalTo(14);
    }];
    
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(15.5);
        make.left.equalTo(_nameLabel.mas_right).offset(10.f);
        make.height.mas_equalTo(13);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_nameLabel.mas_bottom).offset(5.f);
        make.left.equalTo(_mapImage.mas_right).offset(10.f);
        make.height.mas_equalTo(13);
    }];
    
}



@end
