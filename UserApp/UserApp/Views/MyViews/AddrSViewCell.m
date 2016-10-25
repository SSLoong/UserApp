//
//  AddrSViewCell.m
//  UsersApp
//
//  Created by perfect on 16/4/11.
//  Copyright © 2016年 prefect. All rights reserved.
//

#import "AddrSViewCell.h"

@implementation AddrSViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}

-(void)configModel:(AddressModel *)model{

    if ([model.is_default integerValue]==1) {
        
        _defaultView.hidden = NO;
    }else{
        _defaultView.hidden = YES;
    }

    _nameLabel.text = model.receiver;
    
    if ([model.sex isEqualToString:@"M"]) {
        
        _sexLabel.text = @"先生";
    }else{
        _sexLabel.text = @"女士";
    }

    _phoneLabel.text = model.phone;
    
    _addressLabel.text = model.address;
    
    
}

-(void)initSubviews{
    _defaultView = [UIView new];
    _defaultView.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_defaultView];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    _sexLabel = [UILabel new];
    _sexLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_sexLabel];
    
    _phoneLabel = [UILabel new];
    _phoneLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_phoneLabel];
    
    _addressLabel = [UILabel new];
    _addressLabel.font = [UIFont systemFontOfSize:13];
    _addressLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_addressLabel];
    
    _modBtn = [UIButton new];
    [_modBtn setBackgroundImage:[UIImage imageNamed:@"editor"] forState:UIControlStateNormal];
    [self.contentView addSubview:_modBtn];
}

-(void)setLayout{
    __weak typeof(self) weakSelf = self;
    [_defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(3, 47));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    [_sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(67);
        make.height.mas_equalTo(14);
    }];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(105);
        make.height.mas_equalTo(14);
    }];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(37);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(13);
    }];

    [_modBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
}
@end
