//
//  MyFollowViewController.m
//  UserApp
//
//  Created by prefect on 16/4/28.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "MyFollowViewController.h"
#import "FollowViewCell.h"
#import "FollowModel.h"
#import "StoreViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "LoginViewController.h"
#import "MapTableViewController.h"

@interface MyFollowViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UITableView *tbView;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isLoading;//是否在加载中

@property(nonatomic,copy)NSString *siteCode;//站点代码

@property(nonatomic,copy)NSString *longitude;//经度

@property(nonatomic,copy)NSString *latitude;//纬度


@end

@implementation MyFollowViewController


-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if ([DEFAULTS objectForKey:@"siteCode"]) {
        _longitude = [DEFAULTS objectForKey:@"longitude"];
        _latitude = [DEFAULTS objectForKey:@"latitude"];
        _siteCode = [DEFAULTS objectForKey:@"siteCode"];
    }
    
        
    if(_siteCode){
        [self refresh];
    }else{
            [self.tbView reloadData];
        }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关注的店";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    _tbView.emptyDataSetSource = self;
    _tbView.emptyDataSetDelegate = self;
    _tbView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tbView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:_tbView];
    
    [self.tbView registerClass:[FollowViewCell class] forCellReuseIdentifier:@"FollowViewCell"];
    
    _tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _tbView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    
    _tbView.mj_footer = ({
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
    
    
    [AFHttpTool customerFocusStore:_siteCode cust_id:Cust_id longitude:_longitude latitude:_latitude page:_page rows:10 progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        
        if(_page ==1 && self.dataArray.count>0){
            
            [self.dataArray removeAllObjects];
        }
        
        
        for (NSDictionary * dic in response[@"data"][@"stores"]) {
            FollowModel * model = [[FollowModel alloc]init];
            [model mj_setKeyValues:dic];
            [self.dataArray addObject:model];
        }
        
        _isLoading = NO;
        
        if (self.dataArray.count>0) {
            if (_tbView.mj_footer.hidden) {
                _tbView.mj_footer.hidden = NO;
            }
        }else{
            if (!_tbView.mj_footer.hidden) {
                _tbView.mj_footer.hidden = YES;
            }
        }
        
        if(_page == [response[@"data"][@"totalPage"] integerValue] || [response[@"data"][@"totalPage"] integerValue] == 0){
            
            [_tbView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            [_tbView.mj_footer endRefreshing];
            
        }
        
        
        if (_tbView.mj_header.isRefreshing) {
            
            [_tbView.mj_header endRefreshing];
        }
        
        [_tbView reloadData];
        
        
        
        
    } failure:^(NSError *err) {
        
        _hud = [AppUtil createHUD];
        _hud.userInteractionEnabled = NO;
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
        _isLoading = NO;
        
        if (_tbView.mj_footer.isRefreshing) {
            
            [_tbView.mj_footer endRefreshing];
            
        }
        if (_tbView.mj_header.isRefreshing) {
            
            [_tbView.mj_header endRefreshing];
        }
        
    }];
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"FollowViewCell";
    
    FollowViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    FollowModel *model = self.dataArray[indexPath.row];
    
    
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"删除"
                                         backgroundColor:[UIColor redColor]                                                             callback:^BOOL(MGSwipeTableCell *sender) {
                                             
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
                                                                             
                                                                             [self.dataArray removeAllObjects];
                                                                             
                                                                             [self loadData];
                                                                             
                                                                         } failure:^(NSError *err) {
                                                                             
                                                                             _hud.mode = MBProgressHUDModeCustomView;
                                                                             _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                                                             _hud.labelText = @"Error";
                                                                             _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                                                                             [_hud hide:YES afterDelay:3];
                                                                             
                                                                         }];
                                             
                                             
                                             return YES;
                                         }]];
    
    
    cell.model = model;
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    StoreViewController *vc = [[StoreViewController alloc]init];
    
    FollowModel *model = _dataArray[indexPath.row];
    
    vc.store_id = model.store_id;
    
//    NSString *longitude = [DEFAULTS objectForKey:@"longitude"];
//    
//    NSString *latitude = [DEFAULTS objectForKey:@"latitude"];
//    
//    NSString *site_code = [DEFAULTS objectForKey:@"siteCode"];
//    
//    vc.latitude = latitude;
//    
//    vc.longitude = longitude;
//    
//    vc.site_code = site_code;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}




#pragma mark - DZNEmptyDelegate

//返回的图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    
    if(!_siteCode){
        
        return [UIImage imageNamed:@"empty_prompt"];
    }
        
    return [UIImage imageNamed:@"empty_placeholder"];
 
}


//标题提示
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSString *text = @"您还没有关注的店铺哟~";
    if(!_siteCode){
        text = @"定位失败,请定位成功后再查看关注列表吧~~";
    }
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//点击事件
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    

        if (!_siteCode) {
            
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],NSForegroundColorAttributeName: [UIColor grayColor]};
            
            return [[NSAttributedString alloc] initWithString:@"点此重新定位" attributes:attributes];
            
        }
        
        return nil;

}

//点击了按钮
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    
        MapTableViewController *vc = [[MapTableViewController alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
        [self presentViewController:nav animated:YES completion:nil];

    
}

//是否允许下滑
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{

    if(!_siteCode){
        
        return NO;
    }
    
    return YES;
}

//视图之间的间距
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
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
