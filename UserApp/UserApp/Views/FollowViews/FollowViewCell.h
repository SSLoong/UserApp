//
//  FollowViewCell.h
//  UserApp
//
//  Created by prefect on 16/4/22.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "FollowModel.h"

@interface FollowViewCell : MGSwipeTableCell

@property(nonatomic,strong)UIImageView *logoImage;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UIImageView *starImage;

@property(nonatomic,strong)UIImageView *starGaryImage;

@property(nonatomic,strong)UILabel *gradeLabel;

@property(nonatomic,strong)UILabel *addressLabel;

@property(nonatomic,strong)UIView *lineView;

@property(nonatomic,strong)UILabel *typeLabel;

@property(nonatomic,strong)UIImageView *mapImage;

@property(nonatomic,strong)UILabel *disLabel;

@property(nonatomic,strong)UILabel *iconLabel;

@property(nonatomic,strong)FollowModel *model;

@end
