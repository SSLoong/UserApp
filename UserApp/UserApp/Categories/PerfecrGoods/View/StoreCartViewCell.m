//
//  StoreCartViewCell.m
//  UserApp
//
//  Created by prefect on 16/5/27.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "StoreCartViewCell.h"

@implementation StoreCartViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}


-(void)configModel:(CartSaleModel *)model{

    
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
    [self.contentView addSubview:_logoImage];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_priceLabel];
    
    _subLabel = [UILabel new];
    _subLabel.textColor = [UIColor whiteColor];
    _subLabel.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    _subLabel.font = [UIFont systemFontOfSize:12];
    _subLabel.layer.cornerRadius = 2.f;
    _subLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_subLabel];
    
    _addBtn = [UIButton new];
    [_addBtn setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_addBtn];
    
}

-(void)addAction{

    if (self.addBlock) {
        self.addBlock();
    }

}


-(void)setLayout{
    
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.left.equalTo(_logoImage.mas_right).offset(5);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_logoImage.mas_bottom);
        make.left.equalTo(_logoImage.mas_right).offset(5);
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_priceLabel.mas_centerY);
        make.left.equalTo(_priceLabel.mas_right).offset(5.f);
        make.height.mas_equalTo(15);
    }];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_logoImage.mas_bottom);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

}

@end
