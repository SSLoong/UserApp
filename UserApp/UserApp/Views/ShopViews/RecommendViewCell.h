//
//  RecommendViewCell.h
//  UserApp
//
//  Created by prefect on 16/4/26.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendView.h"
#import "GoodsModel.h"

typedef void(^pushGoods)(NSString *sg_id);

@interface RecommendViewCell : UICollectionViewCell

@property(nonatomic,strong)RecommendView *view;

@property(nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)pushGoods pushGoods;

-(void)configData:(NSMutableArray*)dataArray;

@end
