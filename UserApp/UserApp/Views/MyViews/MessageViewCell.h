//
//  MessageViewCell.h
//  UsersApp
//
//  Created by perfect on 16/4/10.
//  Copyright © 2016年 prefect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@interface MessageViewCell : UITableViewCell

@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UIView * lineView;

@property(nonatomic,strong)UILabel * subLabel;

-(void)configModel:(MessageModel *)model;

@end
