//
//  OrderTitleModel.h
//  UserApp
//
//  Created by prefect on 16/5/24.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderTitleModel : NSObject

@property(nonatomic,copy)NSString *order_id;        //订单号
@property(nonatomic,copy)NSString *create_time;     //下单时间
@property(nonatomic,copy)NSString *receive_time;    //配送时间
@property(nonatomic,copy)NSString *receive_type;    //配送方式
@property(nonatomic,copy)NSString *pay_channle;     //支付方式
@property(nonatomic,copy)NSString *memo;            //备注信息

@property(nonatomic,copy)NSString *receiver;        //收货人
@property(nonatomic,copy)NSString *receiver_address;//收货地址
@property(nonatomic,copy)NSString *store_id;        //店铺ID
@property(nonatomic,copy)NSString *store_name;      //店铺名
@property(nonatomic,copy)NSString *focus;           //实否关注
@property(nonatomic,copy)NSString *store_phone;     //商户电话


@property(nonatomic,copy)NSString *coupon_subamount;//优惠券
@property(nonatomic,copy)NSString *real_amount;     //实付

@property(nonatomic,copy)NSString *pay_result;


@end
