//
//  HeaderReusableView.h
//  UserApp
//
//  Created by prefect on 16/4/14.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderReusableView : UICollectionReusableView

@property(nonatomic,strong)UIView *colorView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIButton *moreBtn;

@property(nonatomic,strong)UIImageView *moreImage;

@end
