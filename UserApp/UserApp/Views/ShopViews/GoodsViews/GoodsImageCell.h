//
//  GoodsImageCell.h
//  UserApp
//
//  Created by prefect on 16/4/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface GoodsImageCell : UITableViewCell

@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;

-(void)configImageArray:(NSArray *)imageArray;

@end
