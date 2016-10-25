//
//  GoodsImageCell.m
//  UserApp
//
//  Created by prefect on 16/4/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "GoodsImageCell.h"

@implementation GoodsImageCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}

-(void)configImageArray:(NSArray *)imageArray{

    _cycleScrollView.imageURLStringsGroup = imageArray;
}

-(void)initSubviews{
    
    _cycleScrollView = [SDCycleScrollView new];
    
    _cycleScrollView.currentPageDotColor = [UIColor colorWithHex:0xFD5B44];
    
    _cycleScrollView.pageDotColor = [UIColor colorWithHex:0xFFD2D2];

    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"logo_place"];
    
    [self.contentView addSubview:_cycleScrollView];
    
}

-(void)setLayout{
    
    
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
        
    }];

}


@end
