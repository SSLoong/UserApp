//
//  OrderFooterViewCell.m
//  UserApp
//
//  Created by prefect on 16/5/24.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OrderFooterViewCell.h"

@implementation OrderFooterViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}

-(void)initSubviews{
    
    _couponLabel = [UILabel new];
    _couponLabel.font = [UIFont systemFontOfSize:14];
    _couponLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_couponLabel];
    
    _payLabel = [UILabel new];
    _payLabel.font = [UIFont systemFontOfSize:14];
    _payLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_payLabel];
}

-(void)setLayout{
    
    [_payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.right.mas_equalTo(-10);
    }];

    
    [_couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.right.equalTo(_payLabel.mas_left).offset(-10.f);
    }];

}

@end
