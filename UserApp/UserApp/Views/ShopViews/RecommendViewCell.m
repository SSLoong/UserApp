//
//  RecommendViewCell.m
//  UserApp
//
//  Created by prefect on 16/4/26.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "RecommendViewCell.h"
#import "GoodsModel.h"

@implementation RecommendViewCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
        
    }
    return self;
}

-(void)configData:(NSMutableArray*)dataArray{
    
    CGFloat w = (self.bounds.size.width-10)/2;
    CGFloat h = self.bounds.size.height;
    NSInteger count = dataArray.count<=2 ? 2:dataArray.count;
    
    
    if(_scrollView.contentSize.height == h){

        return;
    }

    _scrollView.contentSize = CGSizeMake(count * w+(count-1)*10, h);

    for (int i=0; i<dataArray.count; i++) {
        CGFloat x = i * w + 10 * i;
        _view = [[RecommendView alloc]initWithFrame:CGRectMake(x, 0, w, h)];
        
        GoodsModel *model = dataArray[i];
        
        [_view configModel:dataArray[i]];
        
        [_scrollView addSubview:_view];
        
        __weak typeof(self) weakSelf = self;
        
        _view.pushBlock = ^(){
            
            if (weakSelf.pushGoods) {
                
                weakSelf.pushGoods(model.sg_id);
            }
            
        };
        
    }
    
    
}



-(void)initSubviews{

    _scrollView = [UIScrollView new];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_scrollView];
    

}

-(void)setLayout{
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
}

@end
