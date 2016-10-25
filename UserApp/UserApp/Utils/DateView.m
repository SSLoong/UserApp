//
//  DateView.m
//  BusinessApp
//
//  Created by prefect on 16/3/17.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "DateView.h"

@implementation DateView

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self createView];
        
        [self setLayout];
    }

    return self;
}


-(void)createView{
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];

    _zhiLable = [UILabel new];
    _zhiLable.text = @"至";
    _zhiLable.font = [UIFont systemFontOfSize:16.f];
    _zhiLable.textColor = [UIColor grayColor];
    [self addSubview:_zhiLable];
    
    _sYearLabel = [UILabel new];
    _sYearLabel.text = [dateString substringToIndex:5];
    _sYearLabel.font = [UIFont systemFontOfSize:12.f];
    _sYearLabel.textColor = [UIColor grayColor];
    [self addSubview:_sYearLabel];
    
    
    _sDateLabel = [UILabel new];
    _sDateLabel.font = [UIFont systemFontOfSize:14.f];
    _sDateLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    
    NSRange range = NSMakeRange(5, 3);
    NSString *yue =  [dateString substringWithRange:range];
    _sDateLabel.text = [NSString stringWithFormat:@"%@1日",yue];
    [self addSubview:_sDateLabel];
    
    _eYearLabel = [UILabel new];
    _eYearLabel.text = [dateString substringToIndex:5];
    _eYearLabel.font = [UIFont systemFontOfSize:12.f];
    _eYearLabel.textColor = [UIColor grayColor];
    [self addSubview:_eYearLabel];
    
    _eDateLabel = [UILabel new];
    _eDateLabel.font = [UIFont systemFontOfSize:14.f];
    _eDateLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _eDateLabel.text = [dateString substringFromIndex:5];
    [self addSubview:_eDateLabel];

}


-(void)setLayout{

[_sYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
    make.left.mas_equalTo(15);
    
    make.top.mas_equalTo(5);
    
    make.height.mas_equalTo(13);
    
}];
    
    [_sDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        
        make.top.equalTo(_sYearLabel.mas_bottom).offset(5.f);
        
        make.height.mas_equalTo(14);
        
    }];
    
    [_zhiLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(14);
        
        make.left.equalTo(_sDateLabel.mas_right).offset(10.f);
        
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    
    
    [_eYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.height.equalTo(_sYearLabel);
        
        make.left.equalTo(_zhiLable.mas_right).offset(10.f);

    }];

    [_eDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.height.equalTo(_sDateLabel);
        
        make.left.equalTo(_zhiLable.mas_right).offset(10.f);
        
    }];
    

}

@end
