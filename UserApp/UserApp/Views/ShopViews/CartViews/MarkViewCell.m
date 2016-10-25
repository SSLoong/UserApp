//
//  MarkViewCell.m
//  UserApp
//
//  Created by prefect on 16/5/10.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "MarkViewCell.h"

@implementation MarkViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}


-(void)initSubviews{
    
    _markLabel = [UILabel new];
    _markLabel.text = @"收货备注";
    _markLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_markLabel];
    
    _markTextFiled = [UITextField new];
    _markTextFiled.borderStyle=UITextBorderStyleRoundedRect;
    _markTextFiled.font = [UIFont systemFontOfSize:14];
    _markTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _markTextFiled.placeholder = @"可输入100字内的特殊要求内容";
    [self.contentView addSubview:_markTextFiled];

}

-(void)setLayout{
    
    
    [_markLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15.f);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self);
    }];
    
    
    [_markTextFiled mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(81);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self);
    }];
}


@end
