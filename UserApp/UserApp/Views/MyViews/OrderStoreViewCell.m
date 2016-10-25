//
//  OrderStoreViewCell.m
//  UserApp
//
//  Created by prefect on 16/5/24.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OrderStoreViewCell.h"

@implementation OrderStoreViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}


-(void)configModel:(OrderTitleModel *)model{

    _nameLabel.text = model.store_name;

    if([model.focus integerValue]==0){
        [_attBtn setSelected:NO];
    }else{
        [_attBtn setSelected:YES];
    }

}


-(void)initSubviews{
    
    _storeLabel = [UILabel new];
    _storeLabel.text = @"配送店铺";
    _storeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_storeLabel];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    _attBtn = [UIButton new];
    [_attBtn setImage:[UIImage imageNamed:@"att"] forState:UIControlStateNormal];
    [_attBtn setImage:[UIImage imageNamed:@"att-light"] forState:UIControlStateSelected];
    [self.contentView addSubview:_attBtn];

    _phoneBtn = [UIButton new];
    [_phoneBtn setImage:[UIImage imageNamed:@"ico-phone"] forState:UIControlStateNormal];
    [self.contentView addSubview:_phoneBtn];
}

-(void)setLayout{
    
    [_storeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
    }];

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(90);
    }];

    [_phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_nameLabel.mas_centerY);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(17, 21));
    }];
    [_attBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_nameLabel.mas_centerY);
        make.right.equalTo(_phoneBtn.mas_left).offset(-10.f);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
    
}

@end
