//
//  MessageViewCell.m
//  UsersApp
//
//  Created by perfect on 16/4/10.
//  Copyright © 2016年 prefect. All rights reserved.
//

#import "MessageViewCell.h"

@implementation MessageViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}

-(void)configModel:(MessageModel *)model{

    if ([model.status integerValue] == 0) {
        _titleLabel.text = @"优惠券即将过期";
//        _subLabel.text = [NSString stringWithFormat:@"亲爱的用户 : 您的%@元优惠券即将于明天过期,快购物吧",model.content];
        _subLabel.text = [NSString stringWithFormat:@"%@",model.content];
    }else if ([model.status integerValue] == 1){
    
//        _titleLabel.text = [NSString stringWithFormat:@"获得一张%@元优惠券",model.title];
         _titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
//        _subLabel.text = [NSString stringWithFormat:@"亲爱的用户 : 恭喜您获得一张%@元优惠券,快去购物吧",model.content];
        _subLabel.text = [NSString stringWithFormat:@"%@",model.content];
    }
//    _timeLabel.text = model.create_time;
    
    
}
-(void)initSubviews{
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLabel];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_lineView];

    _subLabel = [UILabel new];
    _subLabel.font = [UIFont systemFontOfSize:14];
    _subLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_subLabel];

}

-(void)setLayout{

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10.f);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake([[UIScreen mainScreen]bounds].size.width-15, 1));
       
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom).offset(10.f);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(14);
        make.bottom.mas_offset(-10.f);
    }];

}
@end
