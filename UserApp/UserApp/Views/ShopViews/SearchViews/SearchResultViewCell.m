//
//  SearchResultViewCell.m
//  BusinessApp
//
//  Created by prefect on 16/5/13.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SearchResultViewCell.h"

@implementation SearchResultViewCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
        
    }
    return self;
}


-(void)configModel:(SearchResultModel *)model{
    
    [_logoImage sd_setImageWithURL:[NSURL URLWithString:model.cover_img] placeholderImage:[UIImage imageNamed:@"store_big_header"]];
    
    _numLabel.text = [NSString stringWithFormat:@"在售门店%@",model.sale_storenum];
    
    _nameLabel.text = model.goods_name;
}

-(void)initSubviews{
    
    self.logoImage = [[UIImageView alloc]init];
    _logoImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.logoImage];
    
    
    _numLabel = [UILabel new];
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.font = [UIFont systemFontOfSize:14];
    _numLabel.backgroundColor = [UIColor grayColor];
    _numLabel.alpha = 0.8;
    [self.contentView addSubview:_numLabel];
    
    _nameLabel = [UILabel new];
    _nameLabel.numberOfLines = 2;
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
}

-(void)setLayout{
    
    __weak typeof(self) weakSelf = self;
    
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.mas_equalTo(0);
        
        make.size.mas_equalTo(CGSizeMake(weakSelf.bounds.size.width, weakSelf.bounds.size.width));
        
    }];
    
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        
        make.bottom.equalTo(_logoImage.mas_bottom);

        make.height.mas_equalTo(18);
        
    }];
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        
        make.top.equalTo(_logoImage.mas_bottom).offset(10.f);
        
    }];
}


@end
