//
//  CouponViewCell.m
//  UsersApp
//
//  Created by perfect on 16/4/12.
//  Copyright © 2016年 prefect. All rights reserved.
//

#import "CouponViewCell.h"

#define Width self.view.bounds.size.width
@implementation CouponViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}

-(void)configModel:(CouponModel *)model{
    
    _cutLabel.text = [NSString stringWithFormat:@"¥%@",model.sub_amount];
    
    _couponLabel.text = [NSString stringWithFormat:@"[%@]优惠券",model.title];
    
    _startTimeLabel.text = [NSString stringWithFormat:@"%@",model.receive_time];
    
    _endTimeLabel.text = [NSString stringWithFormat:@"%@",model.expire_time];
    
    _setLabel.text =    _setLabel.text = [NSString stringWithFormat:@"单笔订单满%@元可用",model.full_amount];
    
    if ([model.type integerValue] == 0) {
        
        _waysLabel.text = @"[不限门店]";

    }else{
        
        _waysLabel.text = [NSString stringWithFormat:@"[仅限%@]",model.use_store];
    }

}
-(void)initSubviews{
    
    _allView = [UIImageView new];
    _allView.backgroundColor = [UIColor whiteColor];
    [_allView setImage:[UIImage imageNamed:@"coupon"]];
    [self.contentView addSubview:_allView];
    
    _cutLabel = [UILabel new];
    _cutLabel.font = [UIFont systemFontOfSize:15];
    _cutLabel.textColor = [UIColor whiteColor];
    [_allView addSubview:_cutLabel];
    
    _couponLabel = [UILabel new];
    _couponLabel.font = [UIFont systemFontOfSize:14];
    _couponLabel.textColor = [UIColor redColor];
    [_allView addSubview:_couponLabel];
    
    _startTimeLabel = [UILabel new];
    _startTimeLabel.font = [UIFont systemFontOfSize:13];
    _startTimeLabel.textColor = [UIColor redColor];
    [_allView addSubview:_startTimeLabel];
    
    _zhiLabel = [UILabel new];
    _zhiLabel.text = @"至";
    _zhiLabel.font = [UIFont systemFontOfSize:13];
    _zhiLabel.textColor = [UIColor redColor];
    [_allView addSubview:_zhiLabel];
    
    _endTimeLabel = [UILabel new];
    _endTimeLabel.font = [UIFont systemFontOfSize:13];
    _endTimeLabel.textColor = [UIColor redColor];
    [_allView addSubview:_endTimeLabel];
    
    _setLabel = [UILabel new];
    _setLabel.font = [UIFont systemFontOfSize:13];
    _setLabel.textColor = [UIColor redColor];
    [_allView addSubview:_setLabel];
    
    _waysLabel = [UILabel new];
    _waysLabel.font = [UIFont systemFontOfSize:13];
    _waysLabel.textColor = [UIColor redColor];
    [_allView addSubview:_waysLabel];
    
}

-(void)setLayout{
    
    __weak typeof(self) weakSelf = self;
    [_allView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    [_cutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.centerY.mas_equalTo(weakSelf.allView.mas_centerY);
        make.height.mas_equalTo(14);
    }];
    [_couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(weakSelf.zhiLabel.mas_centerX);
        make.height.mas_equalTo(14);
    }];
    [_startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(34);
        make.right.mas_equalTo(_zhiLabel.mas_left).offset(1.f);
        make.height.mas_equalTo(13);
    }];
    [_zhiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(34);
        make.centerX.mas_equalTo(weakSelf.mas_centerX).offset(40.f);
        make.height.mas_equalTo(13);
    }];
    [_endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(34);
        make.left.equalTo(_zhiLabel.mas_right).offset(1.f);
        make.height.mas_equalTo(13);
    }];
    [_setLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60);
        make.centerX.mas_equalTo(weakSelf.zhiLabel.mas_centerX);
        make.height.mas_equalTo(13);
    }];
    [_waysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(13);
    }];
 

    
}
@end
