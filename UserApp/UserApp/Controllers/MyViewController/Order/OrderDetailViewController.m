//
//  OrderDetailViewController.m
//  UserApp
//
//  Created by prefect on 16/5/24.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailViewCell.h"
#import "OrderDetailModel.h"
#import "OrderTitleViewCell.h"
#import "OrderTitleModel.h"
#import "OrderStoreViewCell.h"
#import "OrderFooterViewCell.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)NSMutableArray * titleArray;

@end

@implementation OrderDetailViewController

-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

-(NSMutableArray *)titleArray{
    
    if(_titleArray == nil){
        
        _titleArray = [NSMutableArray array];
        
    }
    return _titleArray;
}


-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [_hud hide:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    if(_resultDic){
    
        
        self.navigationItem.hidesBackButton = YES;
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
        
        self.navigationItem.leftBarButtonItem = item;
        
        NSInteger code = [_resultDic[@"resultStatus"] integerValue];
        
        if (code == 9000) {
            _hud = [AppUtil createHUD];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            _hud.labelText = @"支付成功";
            [_hud hide:YES afterDelay:4];
            
        }else{
            _hud = [AppUtil createHUD];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = _resultDic[@"memo"];
            [_hud hide:YES afterDelay:4];
        }

    }
    
    
    if(_payResoult){
    
        self.navigationItem.hidesBackButton = YES;
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
        
        self.navigationItem.leftBarButtonItem = item;
        
        if ([_payResoult isEqualToString:@"支付成功"]) {
            _hud = [AppUtil createHUD];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            _hud.labelText = @"支付成功";
            [_hud hide:YES afterDelay:4];
            
        }else{
            _hud = [AppUtil createHUD];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = _payResoult;
            [_hud hide:YES afterDelay:4];
        }
 
    }
    
    
    [self createView];
}

-(void)backAction{

    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(void)createView{
    
    NSArray * array = @[@"订单详情",@"订单状态"];
    UISegmentedControl *mySegmentCtrl = [[UISegmentedControl alloc] initWithItems:array];
    mySegmentCtrl.frame = CGRectMake(([AppUtil getScreenWidth]-160)/2, 7, 160, 30);
    mySegmentCtrl.selectedSegmentIndex = 0;
    [mySegmentCtrl addTarget:self action:@selector(clickMySegmentCtrl:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = mySegmentCtrl;
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, [AppUtil getScreenWidth],[AppUtil getScreenHeight]-64)];
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake([AppUtil getScreenWidth] * 2, [AppUtil getScreenHeight]-64);
    [self.view addSubview:_scrollView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width+self.view.bounds.size.width/2-44, self.view.bounds.size.height/2-30, 100, 20)];
    label.text = @"敬请期待";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHex:0xFD5B44];
    [_scrollView addSubview:label];

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [AppUtil getScreenWidth], [AppUtil getScreenHeight]-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_scrollView addSubview:_tableView];
    
    [_tableView registerClass:[OrderDetailViewCell class] forCellReuseIdentifier:@"OrderDetailViewCell"];
    [_tableView registerClass:[OrderTitleViewCell class] forCellReuseIdentifier:@"OrderTitleViewCell"];
    [_tableView registerClass:[OrderStoreViewCell class] forCellReuseIdentifier:@"OrderStoreViewCell"];
    [_tableView registerClass:[OrderFooterViewCell class] forCellReuseIdentifier:@"OrderFooterViewCell"];
    [self loadData];
}


-(void)loadData{
    
    _hud = [AppUtil createHUD];
    
    [AFHttpTool orderQueryDetail:_order_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:2];
            
            return;
        }
        
        
        for (NSDictionary * dic in response[@"data"][@"goods"]) {
            
            OrderDetailModel * model = [[OrderDetailModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            
            [self.dataArray addObject:model];
            
        }

        NSDictionary * dataDic = response[@"data"];
        
        OrderTitleModel *model = [[OrderTitleModel alloc]init];
        
        [model setValuesForKeysWithDictionary:dataDic];
        
        [_hud hide:YES];
        
        [self.titleArray addObject:model];
        
        [self.tableView reloadData];
        
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:2];
        
    }];
}


- (void)clickMySegmentCtrl:(UISegmentedControl *)mySegmentCtrl
{
    
    NSInteger num = mySegmentCtrl.selectedSegmentIndex;
    
    CGFloat offsetX = num * _scrollView.frame.size.width;
    
    CGFloat offsetY = _scrollView.contentOffset.y;
    
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [_scrollView setContentOffset:offset animated:YES];
    
}



#pragma mark - TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        
        OrderTitleModel *model = [self.titleArray lastObject];
        
        if ([model.receive_type integerValue] == 1) {
            
            return self.titleArray.count>0 ? 5:0;
        }
        return self.titleArray.count>0 ? 6:0;
        
    }else if (section == 1){
    
    
        OrderTitleModel *model = [self.titleArray lastObject];
        
        if ([model.receive_type integerValue] == 1) {
            
            return self.titleArray.count>0 ? 1:0;
        }
        return self.titleArray.count>0 ? 3:0;
    
    }else{
    
        return self.dataArray.count>0 ? self.dataArray.count+1:0;
    
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        static NSString *cellId = @"OrderTitleViewCell";
        
        OrderTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        OrderTitleModel *model = [self.titleArray lastObject];
        
        if ([model.receive_type integerValue] == 1) {
            
            NSArray *titleArray = [NSArray arrayWithObjects:@"订单号",@"下单时间",@"配送方式",@"支付方式",@"备注信息", nil];
            
            NSArray *numArray = [NSArray arrayWithObjects:model.order_id,model.create_time,@"自提",[model.pay_channle isEqualToString:@"alipay"] ? @"支付宝":@"微信",model.memo, nil];
            
            cell.titleLabel.text = titleArray[indexPath.row];
            
            cell.numLabel.text = numArray[indexPath.row];
            
        }else{
        
            NSArray *titleArray = [NSArray arrayWithObjects:@"订单号",@"下单时间",@"配送方式",@"配送时间",@"支付方式",@"备注信息", nil];
            
            NSArray *numArray = [NSArray arrayWithObjects:model.order_id,model.create_time,@"门店配送",model.receive_time,[model.pay_channle isEqualToString:@"alipay"] ? @"支付宝":@"微信",model.memo, nil];
            
            cell.titleLabel.text = titleArray[indexPath.row];
            
            cell.numLabel.text = numArray[indexPath.row];
        
        }
        
        return cell;

    }else if (indexPath.section == 1){
    
        
        OrderTitleModel *model = [self.titleArray lastObject];
        
        if ([model.receive_type integerValue] == 1) {
            
            static NSString *cellId = @"OrderStoreViewCell";
            
            OrderStoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.attBtn addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.attBtn.tag = [model.focus integerValue];
            
            [cell.phoneBtn addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];

            [cell configModel:model];
            
            return cell;
            
        }else{
            
            
            if (indexPath.row <2) {
                
                static NSString *cellId = @"OrderTitleViewCell";
                
                OrderTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSArray *titleArray = [NSArray arrayWithObjects:@"收货人",@"收货地址", nil];
                
                NSArray *numArray = [NSArray arrayWithObjects:model.receiver,model.receiver_address, nil];
                
                cell.titleLabel.text = titleArray[indexPath.row];
                
                cell.numLabel.text = numArray[indexPath.row];
                
                return cell;
                
            }else{
            
                static NSString *cellId = @"OrderStoreViewCell";
                
                OrderStoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell.attBtn addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.attBtn.tag = [model.focus integerValue];
                
                [cell.phoneBtn addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
                
                [cell configModel:model];
                
                return cell;
                
            }
            
        }
    
    
    
    }else{
        
        
        if (indexPath.row<self.dataArray.count) {
            
            static NSString *cellId = @"OrderDetailViewCell";
            
            OrderDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            OrderDetailModel *model = self.dataArray[indexPath.row];
            
            [cell configModel:model];
            
            return cell;
            
        }else{
            
            static NSString *cellId = @"OrderFooterViewCell";
            
            OrderFooterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            OrderTitleModel *model = [self.titleArray lastObject];
            
    
            if ([model.pay_result integerValue] == 0) {
                
                cell.payLabel.text = [NSString stringWithFormat:@"待支付：¥%@",model.real_amount];
            }else{
            
            cell.payLabel.text = [NSString stringWithFormat:@"实付：¥%@",model.real_amount];
            
            }
        
            if ([model.coupon_subamount integerValue] == 0) {
                
                cell.couponLabel.text = nil;
                
            }else{
            
                cell.couponLabel.text = [NSString stringWithFormat:@"优惠券：¥%@",model.coupon_subamount];
            }
        
            return cell;
            
        }

    }

    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    if (section == 2) {
        return self.dataArray.count>0? @"费用明细":nil;
    }
    return nil;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 10;
            break;
        case 1:
            return 5;
            break;
        case 2:
            return 25;
            break;
        default:
            return 0;
            break;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
    
}


-(void)phoneAction{
    
    OrderTitleModel *model = [self.titleArray lastObject];
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",model.store_phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}


-(void)followAction:(UIButton *)btn{
    
    
    OrderTitleModel *model = [self.titleArray lastObject];
    
    if ([model.focus integerValue]== 1) {
        
        _hud = [AppUtil createHUD];
        _hud.userInteractionEnabled = NO;
        [AFHttpTool customerFocusStoreDelete:Cust_id
                                    store_id:model.store_id
                                    progress:^(NSProgress *progress) {
                                        
                                    } success:^(id response) {
                                        
                                        if (!([response[@"code"]integerValue]==0000)) {
                                            
                                            NSString *errorMessage = response [@"msg"];
                                            _hud.mode = MBProgressHUDModeCustomView;
                                            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                                            [_hud hide:YES afterDelay:3];
                                            
                                            return;
                                        }
                                        
                                        [_hud hide:YES];
                                        model.focus = @"0";
                                        [self.tableView reloadData];
                                        
                                    } failure:^(NSError *err) {
                                        
                                        _hud.mode = MBProgressHUDModeCustomView;
                                        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                        _hud.labelText = @"Error";
                                        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                                        [_hud hide:YES afterDelay:3];
                                        
                                    }];
        
    }else{
        
        _hud = [AppUtil createHUD];
        _hud.userInteractionEnabled = NO;
        [AFHttpTool customerFocusStoreAdd:SiteCode
                                  cust_id:Cust_id
                                 store_id:model.store_id
                                 progress:^(NSProgress *progress) {
                                     
                                 } success:^(id response) {
                                     
                                     if (!([response[@"code"]integerValue]==0000)) {
                                         
                                         NSString *errorMessage = response [@"msg"];
                                         _hud.mode = MBProgressHUDModeCustomView;
                                         _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                         _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                                         [_hud hide:YES afterDelay:3];
                                         
                                         return;
                                     }
                                     
                                     [_hud hide:YES];
                                     model.focus = @"1";
                                     [self.tableView reloadData];
                                     
                                 } failure:^(NSError *err) {
                                     
                                     _hud.mode = MBProgressHUDModeCustomView;
                                     _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                     _hud.labelText = @"Error";
                                     _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                                     [_hud hide:YES afterDelay:3];
                                     
                                 }];
        
    }
    
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
