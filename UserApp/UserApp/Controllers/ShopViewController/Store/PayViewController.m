//
//  PayViewController.m
//  UserApp
//
//  Created by prefect on 16/4/25.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "PayViewController.h"
#import "PayTableViewCell.h"
#import "PayCouponViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"

#import "PayGeneralViewCell.h"
#import "GeneralsModel.h"

#import "PaySpecialViewCell.h"
#import "SpecialsModel.h"

#import "PayCouponViewController.h"

#import "OrderDetailViewController.h"

@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)UITableView *tbView;

@property(nonatomic,strong)NSMutableArray *generalArray;

@property(nonatomic,strong)NSMutableArray *specialArray;

@property(nonatomic,copy)NSString *pay_channel;//支付方式

@property(nonatomic,assign)NSInteger couponCount;//优惠券的数

@property(nonatomic,copy)NSString *couponString;//优惠券提示文字

@property(nonatomic,copy)NSString *coupon_id;//优惠券id

@property(nonatomic,assign)NSInteger couponMoney;//优惠券的钱

@property (nonatomic,strong)UILabel *subLabel;

@property(nonatomic,strong)UILabel *moneyLabel;

@property(nonatomic,copy)NSString *order_id;

@end

@implementation PayViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.navigationController.navigationBar.hidden) {
        self.navigationController.navigationBar.hidden = NO;
    }
    
    self.title = @"结算付款";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    _pay_channel = @"alipay";
    
    _coupon_id = @"";
    
    _couponMoney = 0;
    
    if(!_buy_type){
    
    _buy_type = @"1";
    }

    [self loadData];

    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(weixinNotice:) name:@"weixinNotice" object:nil];
    
}


-(void)weixinNotice:(NSNotification *)not{
    
    
    OrderDetailViewController *vc= [[OrderDetailViewController alloc]init];
    
    vc.order_id = _order_id;
    
    vc.payResoult = not.userInfo[@"payResoult"];

    [self.navigationController pushViewController:vc animated:YES];
    
}
    
    

-(void)loadData{
    
    
    for (NSDictionary * dic in _generalsDic) {
        
        GeneralsModel * model = [[GeneralsModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.generalArray addObject:model];
    }
    
    for (NSDictionary * dic in _specialsDic) {

        SpecialsModel *model = [[SpecialsModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.specialArray addObject:model];
    }
    

    
    _hud = [AppUtil createHUD];
    [AFHttpTool storeCoupon:Cust_id
                   store_id:_store_id
                 devices_id:[AppUtil UUIDString]
                   generals:_generalsDic
                   specials:_specialsDic
     
                  progress:^(NSProgress *progress) {
                      
                  } success:^(id response) {
                      
                      NSArray *array = response[@"data"];
                      
                      _couponCount = array.count;
                      
                      [_hud hide:YES];
                      
                      [self createTableView];
                      
                      [self createFooterView];
                      
                  } failure:^(NSError *err) {
                      
                      _hud.userInteractionEnabled = NO;
                      _hud.mode = MBProgressHUDModeCustomView;
                      _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                      _hud.labelText = @"Error";
                      _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                      [_hud hide:YES afterDelay:2];
    
                  }];

}

-(void)createTableView{

    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64-44) style:UITableViewStyleGrouped];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    [self.view addSubview:_tbView];
    
    
    [self.tbView registerClass:[PayTableViewCell class] forCellReuseIdentifier:@"PayTableViewCell"];
    [self.tbView registerClass:[PayCouponViewCell class] forCellReuseIdentifier:@"PayCouponViewCell"];
    [self.tbView registerClass:[PayGeneralViewCell class] forCellReuseIdentifier:@"PayGeneralViewCell"];
    [self.tbView registerClass:[PaySpecialViewCell class] forCellReuseIdentifier:@"PaySpecialViewCell"];
}

-(void)createFooterView{
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-44,self.view.bounds.size.width, 44)];
    footerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:footerView];
    
    _moneyLabel = [UILabel new];
    _moneyLabel.textColor = [UIColor whiteColor];
    _moneyLabel.font = [UIFont systemFontOfSize:17.f];
    [footerView addSubview:_moneyLabel];
    
    _subLabel = [UILabel new];
    _subLabel.textColor = [UIColor lightGrayColor];
    _subLabel.font = [UIFont systemFontOfSize:13.f];
    [footerView addSubview:_subLabel];
    
    [self setMoney];
    
    UIButton *payBtn = [UIButton new];
    [payBtn setTitle:@"   确认付款   " forState:UIControlStateNormal];
    [payBtn setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    [payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [footerView addSubview:payBtn];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.mas_equalTo(0);
        
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(0);
        make.left.equalTo(_moneyLabel.mas_right).offset(10.f);
    }];
    
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
}

-(void)payAction{

    _hud = [AppUtil createHUD];
    
    _hud.userInteractionEnabled = YES;

    [AFHttpTool orderSubmit:Cust_id
                   store_id:_store_id
                    cart_id:_cart_id
                    devices:[AppUtil deviceVersion]
                 devices_id:[AppUtil UUIDString]
                   buy_type:_buy_type
                  site_code:SiteCode
                   latitude:Latitude
                  longitude:Longitude
               receive_type:_receive_type
                    addr_id:_add_id
               receive_time:_receive_time
                       memo:_memo
                pay_channel:_pay_channel
                  coupon_id:_coupon_id
                   generals:_generalsDic
                   specials:_specialsDic
                   progress:^(NSProgress *progress) {
                       
                   } success:^(id response) {
                       
                       if (!([response[@"code"]integerValue]==0000)) {
                           NSString *errorMessage = response [@"msg"];
                           _hud.mode = MBProgressHUDModeCustomView;
                           _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                           _hud.detailsLabelText = errorMessage;
                           [_hud hide:YES afterDelay:2];
                           return;
                       }
                       
                       _order_id = response[@"data"][@"order_id"];
                       
                       [self goPay];

                   } failure:^(NSError *err) {
                       
                       _hud.userInteractionEnabled = NO;
                       _hud.mode = MBProgressHUDModeCustomView;
                       _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                       _hud.labelText = @"Error";
                       _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                       [_hud hide:YES afterDelay:2];
                       
                   }];


}


-(void)goPay{

    
    if ([_pay_channel isEqualToString:@"alipay"]) {
        
        [self zhifubaoPay];
        
    }else{
    
        [self weixinPay];
    }
    
}


-(void)zhifubaoPay{


    [AFHttpTool orderSignAlipay:_order_id
                   progress:^(NSProgress *progress) {
                       
                   } success:^(id response) {
                       
                       if (!([response[@"code"]integerValue]==0000)) {
                           NSString *errorMessage = response [@"msg"];
                           _hud.mode = MBProgressHUDModeCustomView;
                           _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                           _hud.detailsLabelText = errorMessage;
                           [_hud hide:YES afterDelay:2];
                           return;
                       }
                       
                       
                       NSString *orderString = response[@"data"][@"sign"];
                       
                       NSString *appScheme = @"sjkuser";

                       [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                           
                           OrderDetailViewController *vc= [[OrderDetailViewController alloc]init];
                           
                           vc.order_id = _order_id;
                           
                           vc.resultDic = resultDic;
                           
                           [self.navigationController pushViewController:vc animated:YES];
                           
                       }];
   

                        [_hud hide:YES];
                       
                   } failure:^(NSError *err) {
                       
                       _hud.userInteractionEnabled = NO;
                       _hud.mode = MBProgressHUDModeCustomView;
                       _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                       _hud.labelText = @"Error";
                       _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                       [_hud hide:YES afterDelay:2];
                       
                   }];

}





-(void)weixinPay{

    [AFHttpTool orderSignWeixin:_order_id
                     devices_id:[AppUtil UUIDString]
                       progress:^(NSProgress *progress) {
                           
                       } success:^(id response) {
                           
                           if (!([response[@"code"]integerValue]==0000)) {
                               NSString *errorMessage = response [@"msg"];
                               _hud.mode = MBProgressHUDModeCustomView;
                               _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                               _hud.detailsLabelText = errorMessage;
                               [_hud hide:YES afterDelay:2];
                               return;
                           }

                           PayReq *request = [[PayReq alloc] init];
                           request.partnerId = response[@"data"][@"partnerId"];
                           request.prepayId= response[@"data"][@"prepayId"];
                           request.package = response[@"data"][@"package"];
                           request.nonceStr= response[@"data"][@"nonceStr"];
                           request.timeStamp= [response[@"data"][@"timeStamp"] intValue];
                           request.sign= response[@"data"][@"sign"];

                           [WXApi sendReq:request];
                           
                           [_hud hide:YES];
                           
                       } failure:^(NSError *err) {
                           
                           _hud.userInteractionEnabled = NO;
                           _hud.mode = MBProgressHUDModeCustomView;
                           _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                           _hud.labelText = @"Error";
                           _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                           [_hud hide:YES afterDelay:2];
                           
                       }];

}



#pragma mark - TableViewDelegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1 || indexPath.section == 0) {
        
        return 44;
        
    }else{
        
        if (indexPath.section > 2) {
            
        SpecialsModel *model = self.specialArray[indexPath.section-3];
            
            if (indexPath.row >= model.goodses.count) {
                
                return 40;
            }
            
        }
        
        return 60;
        
    }
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0){
        return 2;
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        return self.generalArray.count;
    }else{
        
        SpecialsModel *model = self.specialArray[section-3];
        
        NSInteger count;
        
        
        if(model.order_giftgoods.count == 0 && [model.mk_strategy integerValue] == 3){
        
            count = model.goodses.count;
        
        }else{
        
            count = model.goodses.count+1;
        }
        
        return model.goodses.count>0? count:0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3+self.specialArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (indexPath.section == 0) {
        
        static NSString *cellId = @"PayTableViewCell";
        
        PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"支付宝";
            cell.logoImage.image = [UIImage imageNamed:@"pay_zhifubao"];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
        }else{
            cell.nameLabel.text = @"微信";
            cell.logoImage.image = [UIImage imageNamed:@"pay_weixin"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }    else if (indexPath.section == 1){
    
        static NSString *cellId = @"PayCouponViewCell";
        
        PayCouponViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        
        if (_couponCount>0) {
            cell.couponLabel.text = _couponString;
            cell.couponLabel.textColor = [UIColor colorWithHex:0xFD5B44];
            
        }else{
            cell.couponLabel.text = @"没有可用优惠券";
            cell.couponLabel.textColor = [UIColor lightGrayColor];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if(indexPath.section == 2){
            
            static NSString *cellId = @"PayGeneralViewCell";
            
            PayGeneralViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            GeneralsModel *model = self.generalArray[indexPath.row];
            
            [cell configModel:model];
        
            return cell;

    }else{
        
        SpecialsModel *sModel = self.specialArray[indexPath.section-3];
    
        if (indexPath.row<= sModel.goodses.count-1) {
            
            static NSString *cellId = @"PayGeneralViewCell";
            
            PayGeneralViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSDictionary *dict = sModel.goodses[indexPath.row];
            
            GeneralsModel * model = [[GeneralsModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dict];
            
            [cell configModel:model];
            
            return cell;

        }else{
            
            static NSString *cellId = @"PaySpecialViewCell";
        
            PaySpecialViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            [cell configModel:sModel];
            
            return cell;
        
        
        }
    }
}




-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return @"支付方式";
    }else if (section == 1){
        return @"优惠券";
    }else if(section == 2){
        return @"商品明细";
    }else{
        return nil;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if(section >2){
    
        return 5.f;
    }else{
    
        return 30;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {

            NSIndexPath *indexpath;
        
        if (indexPath.row == 0) {
            
             indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
            _pay_channel = @"alipay";
        }else{
            
             indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            _pay_channel = @"weixin";
        }

    PayTableViewCell *cell1 = (PayTableViewCell*)[tableView cellForRowAtIndexPath:indexpath];
        
    [cell1 setSelected:NO];
        
    PayTableViewCell *cell = (PayTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelected:YES];
        
    }else if (indexPath.section == 1){
    
        if (_couponCount>0) {
            
            PayCouponViewController *vc= [[PayCouponViewController alloc]init];
            
            vc.store_id = _store_id;
            
            vc.generalsDic = _generalsDic;
            
            vc.specialsDic = _specialsDic;
            
            vc.chooseCoupon =^(NSString *coupon_id,NSInteger couponMoney){
            
                _coupon_id = coupon_id;
                
                _couponMoney = couponMoney;
                
                [self setMoney];
            };
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}



-(void)setMoney{

    if (_couponMoney>0) {
        
        _couponString = [NSString stringWithFormat:@"¥%zd",_couponMoney];
        
    }else{
        _couponString = [NSString stringWithFormat:@"有%zd张可用",_couponCount];
    }
    
    _moneyLabel.text = [NSString stringWithFormat:@"  实付: ¥%.2f",_money -_couponMoney];
    
    _subLabel.text = [NSString stringWithFormat:@"已优惠: ¥%.2f",_subMoney +_couponMoney];
    
    [self.tbView reloadData];
}




-(NSMutableArray *)generalArray{
    
    if (_generalArray == nil) {
        _generalArray = [NSMutableArray array];
    }
    return _generalArray;
}


-(NSMutableArray *)specialArray{
    
    if (_specialArray == nil) {
        _specialArray = [NSMutableArray array];
    }
    return _specialArray;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_hud hide:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
