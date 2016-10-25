//
//  OKTableViewCell.m
//  UserApp
//
//  Created by prefect on 16/4/28.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OKTableViewCell.h"

@implementation OKTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}


-(void)initSubviews{
    
    _zhengLabel = [UILabel new];
    _zhengLabel.text = @"正品保证";
    _zhengLabel.font = [UIFont systemFontOfSize:14];
    _zhengLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_zhengLabel];
    
    _songLabel = [UILabel new];
    _songLabel.text = @"闪电送达";
    _songLabel.font = [UIFont systemFontOfSize:14];
    _songLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_songLabel];
    
    
    _imageView1 = [UIImageView new];
    _imageView1.image = [UIImage imageNamed:@"duihao"];
    [self.contentView addSubview:_imageView1];
    
    _imageView2 = [UIImageView new];
    _imageView2.image = [UIImage imageNamed:@"duihao"];
    [self.contentView addSubview:_imageView2];
}

-(void)setLayout{
    
    
    [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    
    [_zhengLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_imageView1.mas_right).offset(3.f);
        make.centerY.equalTo(self);
        make.height.mas_offset(14);

    }];
    
    

    
    [_imageView2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_zhengLabel.mas_right).offset(15.f);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    
    [_songLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_imageView2.mas_right).offset(3.f);
        make.centerY.equalTo(self);
        make.height.mas_offset(14);
        
    }];
    
}


@end
