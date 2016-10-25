//
//  SearchResultViewCell.h
//  BusinessApp
//
//  Created by prefect on 16/5/13.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultModel.h"

@interface SearchResultViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *logoImage;

@property(nonatomic,strong)UILabel *numLabel;

@property(nonatomic,strong)UILabel *nameLabel;

-(void)configModel:(SearchResultModel *)model;

@end
