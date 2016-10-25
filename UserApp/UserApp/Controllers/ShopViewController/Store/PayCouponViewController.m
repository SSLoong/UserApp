//
//  PayCouponViewController.m
//  UserApp
//
//  Created by prefect on 16/5/20.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "PayCouponViewController.h"
#import "CouponViewCell.h"
#import "CouponModel.h"

@interface PayCouponViewController ()

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,assign)BOOL isLoading;

@end

@implementation PayCouponViewController

-(id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[CouponViewCell class] forCellReuseIdentifier:@"CouponViewCell"];
    }
    return self;
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"优惠券";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"不使用优惠券" style:UIBarButtonItemStyleDone target:self action:@selector(unuseAction)];
    
    self.navigationItem.rightBarButtonItem = item;
    

    self.tableView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    [self.tableView.mj_header beginRefreshing];
    
}


-(void)refresh{
    
    if (_isLoading) {
        
        return;
    }
    
    _isLoading = YES;
    
    [self loadData];
    
}



-(void)loadData{
    
    [AFHttpTool storeCoupon:Cust_id
                   store_id:_store_id
                 devices_id:[AppUtil UUIDString]
                   generals:_generalsDic
                   specials:_specialsDic progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if(self.dataArray.count>0){
        
            [self.dataArray removeAllObjects];
        }
        
        NSArray * dicDataArray = response[@"data"];
        for (NSDictionary * dic in dicDataArray) {
            CouponModel * model = [[CouponModel alloc]init];
            [model setValue:@"本店" forKey:@"use_store"];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        
        _isLoading = NO;
        
        [self.tableView.mj_header endRefreshing];

        [self.tableView reloadData];
        
    } failure:^(NSError *err) {
        
        _isLoading = NO;
        [self.tableView.mj_header endRefreshing];
        _hud = [AppUtil createHUD];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:2];
        
    }];
}


#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count>0? 1:0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat h = (self.view.bounds.size.width-30) / 345 * 105;
    
    return h;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CouponViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CouponViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CouponModel * model = _dataArray[indexPath.section];
    [cell configModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CouponModel * model = _dataArray[indexPath.section];
    if (self.chooseCoupon) {
        self.chooseCoupon(model.coupon_id,[model.sub_amount integerValue]);
    }
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)unuseAction{

    if (self.chooseCoupon) {
        self.chooseCoupon(@"",0);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
