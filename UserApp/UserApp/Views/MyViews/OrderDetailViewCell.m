//
//  OrderDetailViewCell.m
//  UserApp
//
//  Created by prefect on 16/5/24.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OrderDetailViewCell.h"

@implementation OrderDetailViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}

-(void)configModel:(OrderDetailModel *)model{
    
    _titleLabel.text = model.goods_name;
    _numLabel.text =[NSString stringWithFormat:@"x%@",model.buy_num];
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
}

-(void)initSubviews{
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLabel];
    
    _numLabel = [UILabel new];
    _numLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_numLabel];
    
    _moneyLabel = [UILabel new];
    _moneyLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_moneyLabel];
}

-(void)setLayout{
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
        make.right.mas_equalTo(-80);
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-10);
    }];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-60);
    }];

}


@end
