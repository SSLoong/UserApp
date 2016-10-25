//
//  OrderViewCell.m
//  UserApp
//
//  Created by perfect on 16/4/21.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OrderViewCell.h"

@implementation OrderViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}
-(void)configModel:(OrderModel*)model{
    
    _timeLabel.text = model.create_time;
    
    if ([model.pay_result integerValue] == 0) {
        
        _statusLabel.text = @"待付款";
        
        [_oneBtn setTitle:@"立刻付款" forState:UIControlStateNormal];
        
        _twoBtn.hidden = YES;;
        
     }else{
        
        if([model.receive_type integerValue] == 1){
        
            if ([model.status integerValue] == 1) {
                
                _statusLabel.text = @"已完成";
                
            }else{
            
                _statusLabel.text = @"未自提";
        
            }
            
            [_oneBtn setTitle:@"分享拿券" forState:UIControlStateNormal];
            
            _twoBtn.hidden = YES;;


        }else{
        
            if ([model.status integerValue] == 1) {
                
                _statusLabel.text = @"已完成";
                
                [_oneBtn setTitle:@"分享拿券" forState:UIControlStateNormal];
                
                _twoBtn.hidden = YES;;
                
            }else if([model.status integerValue] == 4){
                
                _statusLabel.text = @"配送中";
                
                [_oneBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                
                [_twoBtn setTitle:@"分享拿券" forState:UIControlStateNormal];
                
                _twoBtn.hidden = NO;
                
            }else {
                
                _statusLabel.text = @"未发货";
                
                [_oneBtn setTitle:@"分享拿券" forState:UIControlStateNormal];
                
                _twoBtn.hidden = YES;;
                
            }
        
        }
    }
    
    
    
    for (int i=0; i<model.imgs.count; i++) {
        
        if (i==0) {
            
            [_firstImage sd_setImageWithURL:[NSURL URLWithString:model.imgs[0]] placeholderImage:[UIImage imageNamed:@"order_logo"]];
            _secondImage.image = nil;
            _thirdImage.image = nil;
            _fourImage.image = nil;
            _moreImage.image = nil;
            
        }else if (i==1){
            
            [_secondImage sd_setImageWithURL:[NSURL URLWithString:model.imgs[1]] placeholderImage:[UIImage imageNamed:@"order_logo"]];
            _thirdImage.image = nil;
            _fourImage.image = nil;
            _moreImage.image = nil;
        
        }else if (i==2){
            
            [_thirdImage sd_setImageWithURL:[NSURL URLWithString:model.imgs[1]] placeholderImage:[UIImage imageNamed:@"order_logo"]];
            _fourImage.image = nil;
            _moreImage.image = nil;
            
        }else if (i==3){
            
            [_fourImage sd_setImageWithURL:[NSURL URLWithString:model.imgs[1]] placeholderImage:[UIImage imageNamed:@"order_logo"]];
            _moreImage.image = [UIImage imageNamed:@"order_more"];
            
        }
    }


    
    
    
    if ([model.receive_type integerValue] == 1 ) {
        _waysLabel.text = @"自提";
    }else if ([model.receive_type integerValue] == 2){
        _waysLabel.text = @"店铺配送";
    }else if ([model.receive_type integerValue] == 3){
        _waysLabel.text = @"第三方配送";
    }
    
    _numLabel.text = [NSString stringWithFormat:@"共%@件商品  实付:",model.total_goods];
    
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.real_amount];
 }

-(void)initSubviews{
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_timeLabel];
    
    _statusLabel = [UILabel new];
    _statusLabel.font = [UIFont systemFontOfSize:14];
    _statusLabel.textColor = [UIColor orangeColor];
    [self.contentView addSubview:_statusLabel];
    
    _firstView = [UIView new];
    _firstView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_firstView];
    
    _firstImage = [UIImageView new];
    [self.contentView addSubview:_firstImage];
    
    _secondImage = [UIImageView new];
    [self.contentView addSubview:_secondImage];
    
    _thirdImage = [UIImageView new];
    [self.contentView addSubview:_thirdImage];
    
    _fourImage = [UIImageView new];
    [self.contentView addSubview:_fourImage];
    
    _moreImage = [UIImageView new];
    [self.contentView addSubview:_moreImage];
    
    _secondView = [UIView new];
    _secondView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_secondView];
    
    _waysLabel = [UILabel new];
    _waysLabel.font = [UIFont systemFontOfSize:14];
    _waysLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_waysLabel];
    
    _numLabel = [UILabel new];
    _numLabel.font = [UIFont systemFontOfSize:14];
    _numLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_numLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    _priceLabel.textColor =  [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_priceLabel];
    
    _thirdView = [UIView new];
    _thirdView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_thirdView];

    
    
    _oneBtn = [UIButton new];
    _oneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _oneBtn.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    _oneBtn.layer.cornerRadius = 2.f;
    _oneBtn.layer.masksToBounds = YES;
    [_oneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_oneBtn];

    _twoBtn = [UIButton new];
    _twoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _twoBtn.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    _twoBtn.layer.cornerRadius = 2.f;
    _twoBtn.layer.masksToBounds = YES;
    [_twoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_twoBtn];
}

-(void)setLayout{
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(14);
    }];
    
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(14);
    }];
    
    [_firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom).offset(14.f);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    
    [_firstImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstView.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_secondImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstView.mas_bottom).offset(10);
        make.left.equalTo(_firstImage.mas_right).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_thirdImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstView.mas_bottom).offset(10);
        make.left.equalTo(_secondImage.mas_right).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_fourImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstView.mas_bottom).offset(10);
        make.left.equalTo(_thirdImage.mas_right).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_moreImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_fourImage.mas_centerY);
        make.left.equalTo(_fourImage.mas_right).offset(10.f);
        make.size.mas_equalTo(CGSizeMake(22, 4));
    }];
    
    
    [_secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fourImage.mas_bottom).offset(10.f);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
    [_waysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_secondView.mas_bottom).offset(15.f);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(14);
    }];
    
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_secondView.mas_bottom).offset(15.f);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(14);
    }];
    
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_secondView.mas_bottom).offset(15.f);
        make.right.equalTo(_priceLabel.mas_left).offset(-3.f);
        make.height.mas_equalTo(14);
    }];
    
    
    [_thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_waysLabel.mas_bottom).offset(14.f);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
    [_oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thirdView.mas_bottom).offset(9.f);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(70, 26));
    }];
    
    
    [_twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thirdView.mas_bottom).offset(9.f);
        make.right.equalTo(_oneBtn.mas_left).offset(-15.f);
        make.size.mas_equalTo(CGSizeMake(70, 26));
    }];
}
@end
