//
//  StoreHeaderViewCell.h
//  UserApp
//
//  Created by prefect on 16/4/25.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreModel.h"

@interface StoreHeaderViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *logoImage;

@property(nonatomic,strong)UIImageView *starImage;

@property(nonatomic,strong)UIImageView *starGaryImage;

@property(nonatomic,strong)UILabel *gradeLabel;

@property(nonatomic,strong)UILabel *addressLabel;

@property(nonatomic,strong)UILabel *typeLabel;

@property(nonatomic,strong)UIImageView *mapImage;

@property(nonatomic,strong)UILabel *disLabel;

@property(nonatomic,strong)UILabel *numLabel;

@property(nonatomic,strong)UILabel *fansLabel;

@property(nonatomic,strong)UIButton *followBtn;

@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)UIButton *oneBtn;

@property(nonatomic,strong)UIButton *twoBtn;

@property(nonatomic,strong)UIButton *threeBtn;



-(void)configModel:(StoreModel *)model;

@end
