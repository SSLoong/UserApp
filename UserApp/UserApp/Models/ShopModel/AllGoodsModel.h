//
//  AllGoodsModel.h
//  BusinessApp
//
//  Created by prefect on 16/3/16.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllGoodsModel : NSObject

@property(nonatomic,copy)NSString *category_id;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSArray *brands;

@end

@interface BrandlistModel : NSObject

@property(nonatomic,copy)NSString *brand_id;

@property(nonatomic,copy)NSString *logo;

@property(nonatomic,copy)NSString *name;

@end
