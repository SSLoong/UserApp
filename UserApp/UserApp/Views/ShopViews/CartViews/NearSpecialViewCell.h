//
//  NearSpecialViewCell.h
//  UserApp
//
//  Created by prefect on 16/7/8.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didGoodsAtIndex)(NSInteger index);

@interface NearSpecialViewCell : UITableViewCell

@property(nonatomic,copy)didGoodsAtIndex index;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end
