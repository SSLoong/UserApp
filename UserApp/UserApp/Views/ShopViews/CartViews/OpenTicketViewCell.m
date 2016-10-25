//
//  OpenTicketViewCell.m
//  BusinessApp
//
//  Created by prefect on 16/3/23.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OpenTicketViewCell.h"

@implementation OpenTicketViewCell

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
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font= [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:_nameLabel];

}


-(void)setLayout{
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(16);
        
    }];
    
    
    
}


@end
