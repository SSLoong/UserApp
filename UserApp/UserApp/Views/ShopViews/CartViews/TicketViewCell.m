//
//  TicketViewCell.m
//  UserApp
//
//  Created by prefect on 16/5/10.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "TicketViewCell.h"

@implementation TicketViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}


-(void)initSubviews{
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"发票信息";
    _nameLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_nameLabel];
    
    _ticketLabel = [UILabel new];
    _ticketLabel.text = @"不需要";
    _ticketLabel.font = [UIFont systemFontOfSize:14.f];
    _ticketLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_ticketLabel];
}

-(void)setLayout{
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15.f);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self);
    }];
    
    
    
    [_ticketLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self);
    }];
}


@end
