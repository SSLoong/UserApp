//
//  FollowViewCell.m
//  UserApp
//
//  Created by prefect on 16/4/22.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "FollowViewCell.h"

@implementation FollowViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}

-(void)setModel:(FollowModel *)model{

    [_logoImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"logo_place"]];
    
    _nameLabel.text = model.name;
    
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
    
    _iconLabel.attributedText = model.iocnAttributedString;
}


-(void)initSubviews{
    
    _logoImage = [UIImageView new];
    [self.contentView addSubview:_logoImage];
    
    _iconLabel = [UILabel new];
    [self.contentView addSubview:_iconLabel];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameLabel];
    
    
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
    _gradeLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:_gradeLabel];
    
    
    _addressLabel = [UILabel new];
    _addressLabel.textColor = [UIColor lightGrayColor];
    _addressLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:_addressLabel];
    
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_lineView];
    
    _typeLabel = [UILabel new];
    _typeLabel.textColor = [UIColor lightGrayColor];
    _typeLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_typeLabel];
    
    
    _mapImage = [UIImageView new];
    _mapImage.image = [UIImage imageNamed:@"map-gray"];
    [self.contentView addSubview:_mapImage];
    
    
    _disLabel = [UILabel new];
    _disLabel.textColor = [UIColor lightGrayColor];
    _disLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_disLabel];
    
}


-(void)setLayout{
    
    
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logoImage.mas_top);
        make.left.equalTo(_logoImage.mas_right).offset(10.f);
    }];
    

    [_starGaryImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_nameLabel.mas_bottom).offset(5.f);
        make.left.equalTo(_nameLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(51, 9));
        
    }];
    
    [_starImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_nameLabel.mas_bottom).offset(5.f);
        make.left.equalTo(_nameLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(51, 9));
        
    }];
    
    [_gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_starGaryImage.mas_right).offset(3.f);
        make.bottom.equalTo(_starGaryImage.mas_bottom);
    }];

    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_nameLabel.mas_left);
        make.top.equalTo(_starGaryImage.mas_bottom).offset(5.f);
    }];
    

    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_addressLabel.mas_bottom).offset(5.f);
        make.left.equalTo(_nameLabel.mas_left);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        
    }];
    

    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_lineView.mas_bottom).offset(6);
        make.bottom.mas_equalTo(-10);
        make.left.equalTo(_nameLabel.mas_left);
    
    }];

    
    [_disLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_typeLabel.mas_top);
        make.right.mas_equalTo(-10);

    }];
    
    
    [_mapImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_typeLabel.mas_top).offset(2.f);
        make.right.equalTo(_disLabel.mas_left).offset(-3.f);
        
    }];
    
    
    [_iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel.mas_centerY);
        make.right.mas_equalTo(-10);
    }];
    
    
}




@end
