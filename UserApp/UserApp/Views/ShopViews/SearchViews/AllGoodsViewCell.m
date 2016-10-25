//
//  AllGoodsViewCell.m
//  UserApp
//
//  Created by prefect on 16/5/16.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "AllGoodsViewCell.h"

@implementation AllGoodsViewCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.logoImageView = [[UIImageView alloc]init];
        [self addSubview:self.logoImageView];
        
    }
    return self;
}


-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    [super applyLayoutAttributes:layoutAttributes];
    
    self.logoImageView.frame = CGRectMake(layoutAttributes.bounds.origin.x , layoutAttributes.bounds.origin.y, layoutAttributes.bounds.size.width , layoutAttributes.bounds.size.height);
    
}

@end
