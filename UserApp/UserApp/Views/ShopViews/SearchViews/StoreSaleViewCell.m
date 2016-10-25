//
//  StoreSaleViewCell.m
//  UserApp
//
//  Created by prefect on 16/5/16.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "StoreSaleViewCell.h"

@implementation StoreSaleViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}


-(void)configModel:(StoreSaleModel *)model{
    
    
    [_logoImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"logo_place"]];
    
    _nameLabel.text = model.store_name;
    
    _gradeLabel.text = [NSString stringWithFormat:@"%@",model.score];
    
    CGFloat score = [model.score floatValue];
    
    CGFloat w = 51*score/5.f;
    
    [_starImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(w);
        
    }];
    
    
    _addressLabel.text = model.address;
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
    if ([model.deliver integerValue] == 0) {
        _typeLabel.text = @"仅限自提";
    }else{
        _typeLabel.text = @"门店配送";
    }
    
}


-(void)initSubviews{
    
    _logoImage = [UIImageView new];
    [self.contentView addSubview:_logoImage];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
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
    _gradeLabel.font = [UIFont systemFontOfSize:11.f];
    [self.contentView addSubview:_gradeLabel];
    
    
    _addressLabel = [UILabel new];
    _addressLabel.textColor = [UIColor lightGrayColor];
    _addressLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:_addressLabel];
    
    
    _priceLabel = [UILabel new];
    _priceLabel.textColor = [UIColor redColor];
    _priceLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:_priceLabel];
    
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_lineView];
    
    _typeLabel = [UILabel new];
    _typeLabel.textColor = [UIColor orangeColor];
    _typeLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:_typeLabel];
    
    

}

-(void)setLayout{
    
    
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.equalTo(_logoImage.mas_right).offset(5.f);
        make.height.mas_equalTo(14);
    }];
    
    
    [_starGaryImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_nameLabel.mas_bottom).offset(5.f);
        make.left.equalTo(_logoImage.mas_right).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(51, 9));
        
    }];
    
    [_starImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_nameLabel.mas_bottom).offset(5.f);
        make.left.equalTo(_logoImage.mas_right).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(51, 9));
        
    }];
    
    [_gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_starGaryImage.mas_right).offset(2.f);
        make.top.equalTo(_starGaryImage.mas_top);
        make.height.mas_equalTo(11);
    }];
    
    
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_nameLabel.mas_left);
        make.top.equalTo(_starGaryImage.mas_bottom).offset(5.f);
        make.height.mas_equalTo(12);
        
    }];
    
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_logoImage.mas_bottom);
        make.left.equalTo(_nameLabel.mas_left);
        make.height.mas_equalTo(13);
        
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_logoImage.mas_bottom).offset(5.f);
        make.left.equalTo(_nameLabel.mas_left);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        
    }];
    
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_lineView.mas_bottom).offset(10.f);
        make.left.equalTo(_nameLabel.mas_left);
        make.height.mas_equalTo(13);
        
    }];
    
}


@end
