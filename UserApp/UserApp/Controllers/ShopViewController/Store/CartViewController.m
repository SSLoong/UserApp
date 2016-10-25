//
//  CartViewController.m
//  UserApp
//
//  Created by prefect on 16/4/26.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "CartViewController.h"
#import "AddressViewCell.h"
#import "AddressModel.h"
#import "AddressListController.h"
#import "CartTimeViewCell.h"
#import "MHDatePicker.h"
#import "MarkViewCell.h"
#import "TicketViewCell.h"
#include "OpenKicketViewController.h"
#import "GeneralViewCell.h"
#import "GeneralsModel.h"
#import "SpecialsViewCell.h"
#import "SpecialsModel.h"

#import "PayViewController.h"



@interface CartViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)MBProgressHUD *hud;

@property (strong, nonatomic) MHDatePicker *selectDatePicker;

@property(nonatomic,strong)UITableView *tbView;

@property(nonatomic,strong)NSMutableArray *generalArray;//普通商品数据源

@property(nonatomic,strong)NSMutableArray *specialArray;//普通商品数据源

@property(nonatomic,assign)NSInteger receipt;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *songMoney;

@property(nonatomic,copy)NSString *phone;

@property(nonatomic,copy)NSString *address;

@property(nonatomic,copy)NSString *addr_id;

@property(nonatomic,copy)NSString *timeString;

@property(nonatomic,strong)NSMutableDictionary *dict;

@property(nonatomic,assign)CGFloat money;

@property(nonatomic,assign)CGFloat subMoney;

@property (nonatomic,strong) UILabel *moneyLabel;

@property (nonatomic,strong) UILabel *subLabel;

@property (nonatomic,strong) UIButton *accountBtn;


@end

@implementation CartViewController

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [_hud hide:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"购物车";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    _money = 0.0;
    
    _subMoney = 0.0;
    
    _name = @"没有默认收货地址 - 点此添加";
    _address = @"";
    _phone = @"";
    _receipt = 0;
    _timeString = @"闪电达 急速送";
    
    [self createTableView];
    
    [self createFooterView];
    
    [self loadAddressData];
    
    [self loadStoreData];
    
    [self loadCartData];
}

-(void)viewWillAppear:(BOOL)animated{

    [_tbView reloadData];
}



-(void)loadStoreData{
    
    [AFHttpTool storeDetail:_store_id
                    cust_id:Cust_id
                  longitude:Longitude
                   latitude:Latitude
                   progress:^(NSProgress *progress) {
                       
                   } success:^(id response) {
                       
                       _songMoney = response[@"data"][@"deliver_amount"];

                   } failure:^(NSError *err) {
                    
                       
                   }];
    
}



-(void)createTableView{

    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64-44) style:UITableViewStyleGrouped];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    [self.view addSubview:_tbView];

    [self.tbView registerClass:[AddressViewCell class] forCellReuseIdentifier:@"AddressViewCell"];
    [self.tbView registerClass:[CartTimeViewCell class] forCellReuseIdentifier:@"CartTimeViewCell"];
    [self.tbView registerClass:[MarkViewCell class] forCellReuseIdentifier:@"MarkViewCell"];
    [self.tbView registerClass:[TicketViewCell class] forCellReuseIdentifier:@"TicketViewCell"];
    [self.tbView registerClass:[GeneralViewCell class] forCellReuseIdentifier:@"GeneralViewCell"];
    [self.tbView registerClass:[SpecialsViewCell class] forCellReuseIdentifier:@"SpecialsViewCell"];
    
}


-(void)createFooterView{

    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, CGRectGetWidth(self.view.bounds), 44)];
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
    
    _accountBtn = [UIButton new];
    [_accountBtn setTitle:@"去结算" forState:UIControlStateNormal];
    _accountBtn.backgroundColor =  [UIColor colorWithHex:0xFD5B44];
    _accountBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_accountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_accountBtn addTarget:self action:@selector(accountAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_accountBtn];
    
    
    [self setMoney];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.mas_equalTo(0);
        
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(0);
        make.left.equalTo(_moneyLabel.mas_right).offset(10.f);
    }];
    
    
    [_accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(80);
        
    }];

}

-(void)setMoney{
    
    _moneyLabel.text = [NSString stringWithFormat:@"  合计: ¥%.2f",_money];
    
    _subLabel.text = [NSString stringWithFormat:@"已优惠: ¥%.2f",_subMoney];
}


-(void)accountAction{
    
    if (_money == 0) {
        
        _hud = [AppUtil createHUD];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"购物车空的是不能结账哟~";
        [_hud hide:YES afterDelay:2];
        return;
    }
    

    if (_addr_id.length == 0) {
            
        _hud = [AppUtil createHUD];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"请添加收货地址";
        [_hud hide:YES afterDelay:2];
        return;
    }
        
    if (_money < [_songMoney floatValue]) {
            
        _hud = [AppUtil createHUD];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"起送价格不足";
        _hud.detailsLabelText = [NSString stringWithFormat:@"还差%.2f元才能起送",[_songMoney floatValue]- _money];
        [_hud hide:YES afterDelay:2];
        return;
    }
        
    NSIndexPath *path=[NSIndexPath indexPathForRow:2 inSection:0];
        
    MarkViewCell *cell = (MarkViewCell *)[_tbView cellForRowAtIndexPath:path];

    PayViewController *vc = [[PayViewController alloc]init];
    
    vc.store_id = _store_id;
    
    vc.cart_id = @"";
    
    vc.receive_type = @"2";
    
    vc.receive_time = _timeString;
    
    vc.add_id = _addr_id;
    
    vc.memo = cell.markTextFiled.text.length >0 ? cell.markTextFiled.text : @"";
    
    vc.money = _money;
    
    vc.subMoney = _subMoney;
    
    vc.generalsDic = _dict[@"generals"];
    
    vc.specialsDic = _dict[@"specials"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)loadAddressData{

    [AFHttpTool addressDefault:Cust_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        NSDictionary *dic = response[@"data"];

        if([dic count] == 0){
            return ;
        }

        if(![SiteCode isEqualToString:dic[@"site_code"]]){
        
            return;
        }
  
        _name = dic[@"receiver"];
        _address = dic[@"address"];
        _phone =[NSString stringWithFormat:@"%@",dic[@"phone"]];
        _addr_id = dic[@"addr_id"];

        [self.tbView reloadData];
        
    } failure:^(NSError *err) {
        
        [self loadFail:err];
        
    }];
    
}



-(void)loadCartData{

    
    [AFHttpTool cartDetail:Cust_id store_id:_store_id
                  progress:^(NSProgress *progress) {
        
    } success:^(id response) {
    

        if (self.generalArray.count > 0) {
            
            [self.generalArray removeAllObjects];
        }
        
        if (self.specialArray.count > 0) {
            
            [self.specialArray removeAllObjects];
        }
        
        
        
        for (NSDictionary *dic in response[@"data"][@"generals"]) {
            
            GeneralsModel *model = [[GeneralsModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [self.generalArray addObject:model];
            
        }

        
        for (NSDictionary *dic in response[@"data"][@"specials"]) {
            
            SpecialsModel *model = [[SpecialsModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [self.specialArray addObject:model];
            
        }

        _money =[response[@"data"][@"total_amount"] floatValue];
        
        _subMoney = [response[@"data"][@"sub_amount"] floatValue];
        
        [self setMoney];
        
        [self.tbView reloadData];
        
        _dict = response[@"data"];
        
    } failure:^(NSError *err) {
        
        [self loadFail:err];
        
    }];
    
}




-(void)loadFail:(NSError *)err{
    
    _hud = [AppUtil createHUD];
    _hud.userInteractionEnabled = NO;
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
    _hud.labelText = @"Error";
    _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
    [_hud hide:YES afterDelay:3];
    
}




#pragma mark - TableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
    
            if (indexPath.row == 0) {
                
                static NSString *cellId = @"AddressViewCell";
                
                AddressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIImageView *imageView = [UIImageView new];
                
                imageView.image = [UIImage imageNamed:@"address_bg"];
                
                cell.backgroundView = imageView;
                
                cell.nameLabel.text = _name;
                
                cell.phoneLabel.text = _phone;
                
                cell.addressLabel.text = _address;
                
                return cell;
                
            }else if (indexPath.row == 1){
            
            
                static NSString *cellId = @"CartTimeViewCell";
                
                CartTimeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.timeLabel.text = _timeString;
                
                return cell;
            
            }else if (indexPath.row == 2){
                
                static NSString *cellId = @"MarkViewCell";
                
                MarkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
                
            }else if (indexPath.row == 3){
            
                static NSString *cellId = @"TicketViewCell";
                
                TicketViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            
            }
            
    }else if(indexPath.section == 1){
    
        static NSString *cellId = @"GeneralViewCell";
        
        GeneralViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        GeneralsModel *model = self.generalArray[indexPath.row];
        
        cell.plusBlock = ^(BOOL isAdd){
        
            _hud = [AppUtil createHUD];
            
            _hud.userInteractionEnabled = YES;
            
            NSString *buy_num = isAdd ? @"+1":@"-1";
            
            [AFHttpTool addCart:Cust_id store_id:_store_id special_id:@"" sg_id:model.sg_id buy_num:buy_num  progress:^(NSProgress *progress) {
                
            } success:^(id response) {
                
                if (!([response[@"code"]integerValue]==0000)) {
                    NSString *errorMessage = response [@"msg"];
                    _hud.mode = MBProgressHUDModeCustomView;
                    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                    _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                    [_hud hide:YES afterDelay:2];
                    return;
                }
                
                [_hud hide:YES];
                
                [self loadCartData];
                
            } failure:^(NSError *err) {
                
                _hud.mode = MBProgressHUDModeCustomView;
                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                _hud.labelText = @"Error";
                _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                [_hud hide:YES afterDelay:2];
                
            }];

        };
        
        [cell configModel:model];
        
        return cell;
        
        
    }else{
    
        if (indexPath.row == 0) {
        
            static NSString *cellId = @"SpecialsViewCell";
            
            SpecialsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            SpecialsModel *model = self.specialArray[indexPath.section-2];
            
            [cell configModel:model];
            
            return cell;
            
        }else{
        
            static NSString *cellId = @"GeneralViewCell";
            
            GeneralViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            SpecialsModel *model = self.specialArray[indexPath.section-2];
            
            NSArray *array = model.goodses;
            
            NSDictionary *dic = array[indexPath.row-1];
            
            GeneralsModel *model1 = [GeneralsModel mj_objectWithKeyValues:dic];

            
            model1.sub_amount = model1.special_subamount;
            
            cell.plusBlock = ^(BOOL isAdd){
                
                _hud = [AppUtil createHUD];

                
                NSString *buy_num = isAdd ? @"+1":@"-1";
                
                [AFHttpTool addCart:Cust_id store_id:_store_id special_id:model.special_id sg_id:model1.sg_id buy_num:buy_num  progress:^(NSProgress *progress) {
                    
                } success:^(id response) {
    
                    
                    if (!([response[@"code"]integerValue]==0000)) {
                        NSString *errorMessage = response [@"msg"];
                        _hud.mode = MBProgressHUDModeCustomView;
                        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                        _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                        [_hud hide:YES afterDelay:2];
                        return;
                    }
                    
                    [_hud hide:YES];
                    
                    [self loadCartData];
                    
                } failure:^(NSError *err) {
                    
                    _hud.mode = MBProgressHUDModeCustomView;
                    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                    _hud.labelText = @"Error";
                    _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                    [_hud hide:YES afterDelay:2];
                    
                }];
                
            };
            
            
            [cell configModel:model1];
            
            return cell;

        }
    }

    return nil;
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2+self.specialArray.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0){
    
        return  4;
        
    }else if (section == 1){
    
        return self.generalArray.count;
        
    }else{
        
        SpecialsModel *model = self.specialArray[section-2];
        
        return 1 + model.goodses.count;
    
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
    
            if (indexPath.row == 0) {
                
                return 62;
            }
        
        return 44;

    }else{
    
        return 60;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 5.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5.f;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                    AddressListController *vc = [[AddressListController alloc]init];
                
                    vc.address = @"address";
                
                vc.didSelect = ^(NSString *name,NSString *phone,NSString *address,NSString *addr_id){
                
                    _name = name;
                    
                _phone = phone;
                    
                _address = address;
                    
                _addr_id = addr_id;
                    
                };
                
                [self.navigationController pushViewController:vc animated:YES];
            
            }else if(indexPath.row == 1){
            
                _selectDatePicker = [[MHDatePicker alloc] init];
                _selectDatePicker.datePickerMode = UIDatePickerModeDate;
                
                [_selectDatePicker didFinishSelectedDate:^(NSDate *selectedDate) {
                    
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
                [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
                NSString *str = [dateFormatter stringFromDate:selectedDate];
                _timeString = str;
                [_tbView reloadData];
                }];
            
            }else if(indexPath.row == 3) {
            
                OpenKicketViewController *vc= [[OpenKicketViewController alloc]init];
            
                vc.num = _receipt;
            
                vc.selectRows = ^(NSString *titleString){
            
                TicketViewCell *cell = (TicketViewCell*)[tableView cellForRowAtIndexPath:indexPath];
                
                cell.ticketLabel.text = titleString;
                
                };
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    
}

}

#pragma mark - 懒加载数据源


-(NSMutableArray *)generalArray{
    
    if(_generalArray == nil){
        
        _generalArray = [NSMutableArray array];
        
    }
    return _generalArray;
}

-(NSMutableArray *)specialArray{
    
    if(_specialArray == nil){
        
        _specialArray = [NSMutableArray array];
        
    }
    return _specialArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
