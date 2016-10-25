//
//  DetailTableViewCell.m
//  UserApp
//
//  Created by prefect on 16/4/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}

-(void)configModel:(GoodsDetailModel *)model{

    _nameLabel.text = model.goods_name;
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
    _dealerPriceLabel.text = [NSString stringWithFormat:@" ¥%@",model.dealer_price];
    
    NSUInteger length = _dealerPriceLabel.text.length;
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_dealerPriceLabel.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, length)];
    [_dealerPriceLabel setAttributedText:attri];
    
    if ([model.price integerValue] == [model.dealer_price integerValue] || [model.dealer_price integerValue] == 0) {
        
        [_subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
           make.top.equalTo(_priceLabel.mas_top);
           make.left.equalTo(_priceLabel.mas_right).offset(5.f);
           make.height.mas_equalTo(14);
            
        }];
        _dealerPriceLabel.hidden = YES;
    }
    
    if ([model.sub_amount floatValue] != 0.f) {
        
        _subLabel.text = [NSString stringWithFormat:@"立减%@元",model.sub_amount];
        
    }else{
        
        _subLabel.text = nil;
    }
    

}


-(void)initSubviews{
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    _priceLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_priceLabel];
    
    _dealerPriceLabel = [UILabel new];
    _dealerPriceLabel.font = [UIFont systemFontOfSize:13];
    _dealerPriceLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_dealerPriceLabel];
    
    _subLabel = [UILabel new];
    _subLabel.font = [UIFont systemFontOfSize:12];
    _subLabel.textColor = [UIColor whiteColor];
    _subLabel.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    _subLabel.layer.cornerRadius = 2.f;
    _subLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_subLabel];
    
    _iconImageView= [UIImageView new];
    _iconImageView.image = [UIImage imageNamed:@"goods_detail"];
    [self.contentView addSubview:_iconImageView];
    
}

-(void)setLayout{

    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(15);
        make.height.mas_offset(14);
        
    }];
    
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.top.equalTo(_nameLabel.mas_bottom).offset(10.f);
        make.height.mas_offset(14);
        
    }];
    
    [_dealerPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_priceLabel.mas_right).offset(3.f);
        make.bottom.equalTo(_priceLabel.mas_bottom);
        make.height.mas_offset(13);
        
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLabel.mas_top);
        make.left.equalTo(_dealerPriceLabel.mas_right).offset(5.f);
        make.height.mas_equalTo(14);
    }];
    
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    
}


@end
