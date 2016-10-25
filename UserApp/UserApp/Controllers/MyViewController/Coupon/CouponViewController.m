//
//  CouponViewController.m
//  UserApp
//
//  Created by perfect on 16/4/12.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponViewCell.h"
#import "CouponModel.h"
//#import "DesertViewController.h"

@interface CouponViewController ()

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isLoading;

@end

@implementation CouponViewController


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
    
    self.tableView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = ({
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.refreshingTitleHidden = YES;
        footer.hidden = YES;
        footer;
    });
    
}


-(void)refresh{
    
    if (_isLoading) {
        
        return;
    }
    
    _isLoading = YES;
    
    _page = 1;
    
    [self loadData];
    
}


-(void)loadMoreData{
    
    
    if (_isLoading) {
        
        return;
    }
    
    _isLoading = YES;
    
    _page++;
    
    [self loadData];
}


-(void)loadData{

    if (_store_id) {
        
        [AFHttpTool couponStore:Cust_id store_id:_store_id page:_page progress:^(NSProgress *progress) {
            
        } success:^(id response) {
            

            
            if (_page == 1 && _dataArray.count > 0) {
                
                [self.dataArray removeAllObjects];
            }
            
            NSArray * dicDataArray = response[@"data"][@"dataList"];
            for (NSDictionary * dic in dicDataArray) {
                CouponModel * model = [[CouponModel alloc]init];
                [model setValue:@"本店" forKey:@"use_store"];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            
            if (self.tableView.mj_footer.hidden) {
                self.tableView.mj_footer.hidden = NO;
            }
            
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            
            NSInteger totalPage = [response[@"data"][@"totalPage"] integerValue];
            
            if (_page ==  totalPage || 0 == totalPage) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                
                [self.tableView.mj_footer endRefreshing];
            }
            
            _isLoading = NO;
            
            [self.tableView reloadData];
            
        } failure:^(NSError *err) {
            
            
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            
            _isLoading = NO;
            
            _hud = [AppUtil createHUD];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = @"Error";
            _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
            [_hud hide:YES afterDelay:2];
            
        }];
        
        
    }else{

    
    [AFHttpTool couponList:Cust_id page:_page progress:^(NSProgress *progress) {
            
    } success:^(id response) {
        
        NSLog(@"%@",response);
        
        if (_page == 1 && _dataArray.count > 0) {
            
            [self.dataArray removeAllObjects];
        }
        
        NSArray * dicDataArray = response[@"data"][@"dataList"];
        for (NSDictionary * dic in dicDataArray) {
            CouponModel * model = [[CouponModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];

            [self.dataArray addObject:model];
        }
        
        if (self.tableView.mj_footer.hidden) {
            self.tableView.mj_footer.hidden = NO;
        }
        
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        
        NSInteger totalPage = [response[@"data"][@"totalPage"] integerValue];
            
        if (_page ==  totalPage || 0 == totalPage) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                
                [self.tableView.mj_footer endRefreshing];
            }

        _isLoading = NO;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *err) {

        
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        
        _isLoading = NO;

        _hud = [AppUtil createHUD];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:2];
        
    }];
    
    }

}


#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
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


@end
