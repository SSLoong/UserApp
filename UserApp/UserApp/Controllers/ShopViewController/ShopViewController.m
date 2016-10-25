//
//  ShopViewController.m
//  UserApp
//
//  Created by prefect on 16/4/11.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ShopViewController.h"
#import "MapTableViewController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <CoreLocation/CoreLocation.h>

#import "HeaderViewCell.h"

#import "FollowViewCell.h"
#import "FollowModel.h"

#import "NearSpecialViewCell.h"
#import "SpecialModel.h"

#import "StoreViewController.h"

#import "LoginViewController.h"
#import "SearchViewController.h"
#import "SaoYiSaoViewController.h"
#import "CouponViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "CodeLoginVC.h"

@interface ShopViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,strong)BMKGeoCodeSearch* geocodesearch;

@property(nonatomic,strong)BMKLocationService *locService;

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)UITableView *tbView;

@property(nonatomic,strong)NSMutableArray *SpecialArray;//特卖的数据源

@property(nonatomic,strong)NSMutableArray *NearArray;//附近的数据源

@property(nonatomic,assign)NSInteger page;//页数

@property(nonatomic,assign)BOOL isLoading;//是否在加载中

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)UILabel *titleView;

@property(nonatomic,assign)BOOL isFrist;

@property(nonatomic,strong)UIBarButtonItem *leftItem;

@property(nonatomic,strong)UIBarButtonItem *rightItem;


@end

@implementation ShopViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.navigationItem.titleView = _headerView;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn-scan"] style:UIBarButtonItemStyleDone target:self action:@selector(scanAction)];
    
    _rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn-search"] style:UIBarButtonItemStyleDone target:self action:@selector(soAction)];
    
    
    [self createHeaderView];

    [self createCollectionView];

    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
    
        _titleView.text = @"定位未开启->点此开启";
        
        [self pushMap];
    
    }else{
    
        _locService = [[BMKLocationService alloc]init];
        
        _locService.delegate = self;
               [_locService startUserLocationService];
    }
    
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"updataMap" object:nil];
}


-(void)createHeaderView{
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    
    [_headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushMap)]];
    
    UIImageView *mapView =[UIImageView new];
    mapView.image = [UIImage imageNamed:@"map"];
    [_headerView addSubview:mapView];
    
    _titleView = [UILabel new];
    _titleView.backgroundColor = [UIColor clearColor];
    _titleView.font = [UIFont boldSystemFontOfSize:16];
    _titleView.textColor = [UIColor whiteColor];
    _titleView.text = @"定位中...";
    [_headerView addSubview:_titleView];
    
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_headerView.mas_centerX);
        make.top.mas_equalTo(14);
        make.height.mas_equalTo(16);
        
    }];
    
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_headerView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 16));
        make.right.equalTo(_titleView.mas_left).offset(-3.f);
        
    }];
    
}


-(void)createCollectionView{
    
    _isFrist = YES;
    

    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64-44) style:UITableViewStylePlain];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    _tbView.emptyDataSetSource = self;
    _tbView.emptyDataSetDelegate = self;
    _tbView.backgroundColor = [UIColor clearColor];
    _tbView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:_tbView];
    
    [self.tbView registerClass:[NearSpecialViewCell class] forCellReuseIdentifier:@"NearSpecialViewCell"];
    [self.tbView registerClass:[HeaderViewCell class] forCellReuseIdentifier:@"HeaderViewCell"];
    [self.tbView registerClass:[FollowViewCell class] forCellReuseIdentifier:@"FollowViewCell"];

    self.tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    

    self.tbView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    
    
    self.tbView.mj_footer = ({
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
    
    [self loadSpecialData];
    
}


-(void)loadMoreData{
    
    
    if (_isLoading) {
        
        return;
    }
    
    _isLoading = YES;
    
    _page++;
    
    [self loadNearData];
}


#pragma mark - 下载数据源

-(void)getSizeCode:(NSString *)cityCode{
    
    [AFHttpTool siteCode:cityCode progress:^(NSProgress *progress) {
        
    } success:^(id response) {

        
        NSString *siteCode = response[@"data"][@"site_code"];
        
        [DEFAULTS setObject:siteCode forKey:@"siteCode"];
        
        [self.tbView.mj_header beginRefreshing];
        
    } failure:^(NSError *err) {
        
            [self loadFail:err];
    }];
    
}



-(void)loadSpecialData{
    
    [AFHttpTool nearbySpecial:SiteCode longitude:Longitude latitude:Latitude page:1 rows:10 progress:^(NSProgress *progress) {
        
    } success:^(id response) {

        
        if(_page ==1 && self.SpecialArray.count>0){
            
            [self.SpecialArray removeAllObjects];
        }
        
        NSArray *dataArray = response[@"data"][@"specials"];
        
        for (NSDictionary *dic in dataArray) {
            
            SpecialModel *model = [[SpecialModel alloc]init];
            
            [model mj_setKeyValues:dic];
            
            [self.SpecialArray addObject:model];
            
        }
        
        [self.tbView reloadData];
        
        [self loadNearData];
        
    } failure:^(NSError *err) {
        
        [self loadFail:err];
        
    }];
}

-(void)loadNearData{
    
    [AFHttpTool nearbyStore:SiteCode longitude:Longitude latitude:Latitude sort:@"1" page:_page rows:10 progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if(_page ==1 && self.NearArray.count>0){
            
            [self.NearArray removeAllObjects];
        }
        
        NSArray *dataArray = response[@"data"];
        
        for (NSDictionary *dic in dataArray) {
            
            FollowModel *model = [[FollowModel alloc]init];
            
            [model mj_setKeyValues:dic];
            
            [self.NearArray addObject:model];
            
        }
        
        if (self.tbView.mj_header.isRefreshing) {
            
            [self.tbView.mj_header endRefreshing];
        }
        
        if ([response[@"data"] count] == 0) {
            
            if (!self.tbView.mj_footer.hidden) {
                self.tbView.mj_footer.hidden = YES;
            }
            
        }else
        
        {
        
            if (self.tbView.mj_footer.hidden) {
                self.tbView.mj_footer.hidden = NO;
            }
        
        }
     
        _isFrist = NO;
        
        NSArray *array = response[@"data"];
        
        if (array.count > 0) {
            
             [self.tbView.mj_footer endRefreshing];
        }else{
            [self.tbView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (_isLoading) {
            _isLoading = NO;
        }
        
        [self.tbView reloadData];
        
        
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
    [_hud hide:YES afterDelay:2];
    
    if (_isLoading) {
        _isLoading = NO;
    }
    if (self.tbView.mj_footer.isRefreshing) {
        [self.tbView.mj_footer endRefreshing];
    }
    if (self.tbView.mj_header.isRefreshing) {
        [self.tbView.mj_header endRefreshing];
    }
    
}




#pragma mark - UITableViewDelegate



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 2) {
        
        if(IsLogin){
            
            StoreViewController *vc = [[StoreViewController alloc]init];
            
            FollowModel *model = _NearArray[indexPath.row];
            
            vc.store_id = model.store_id;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            [self loginAccount];
            
        }
        
    }
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return self.NearArray.count>0?1:0;
            break;
        case 1:
            return self.SpecialArray.count>0?1:0;
            break;
        case 2:
            return self.NearArray.count;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return self.SpecialArray.count>0? 40 :0;
        case 2:
            return self.NearArray.count>0 ? 40 : 0;
            break;
        default:
            return 0;
            break;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 12, 3, 18)];
    lineView.backgroundColor = [UIColor orangeColor];
    [view addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 13, 70, 14)];
    
    if(section == 1){
        titleLabel.text = @"附近特卖";
    }else if(section == 2){
        titleLabel.text = @"附近门店";
    }
    titleLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:titleLabel];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        static NSString *cellId = @"HeaderViewCell";
        
        HeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        [cell.scanBtn addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.searchBtn addTarget:self action:@selector(soAction) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.couponBtn addTarget:self action:@selector(couponAction) forControlEvents:UIControlEventTouchUpInside];
        
        cell.backgroundColor = [UIColor colorWithHex:0xd01617];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if(indexPath.section == 1){

        static NSString *cellId = @"NearSpecialViewCell";
        
        NearSpecialViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        cell.index = ^(NSInteger index){
            
            if(IsLogin){
                
                StoreViewController *vc = [[StoreViewController alloc]init];
                
                SpecialModel *model = _SpecialArray[index];
                
                vc.store_id = model.store_id;
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                
                [self loginAccount];
                
            }
        
        };

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.dataArray = self.SpecialArray;

        return cell;
        
    }else{
    
    static NSString *cellId = @"FollowViewCell";
    
    FollowViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FollowModel *model = self.NearArray[indexPath.row];
  
    cell.model = model;
    
    return cell;
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
    
        return 85;
    
    }else if(indexPath.section == 1){
        
        return (ScreenWidth-30)/2+86;
        
    }else{
    
    
    FollowModel *model = self.NearArray[indexPath.row];
    
    return [tableView fd_heightForCellWithIdentifier:@"FollowViewCell" cacheByIndexPath:indexPath configuration:^(FollowViewCell *cell) {
        
        cell.model = model;
        
    }];
    
}
}



#pragma mark - 定位相关


//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    [_locService stopUserLocationService];
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude};
    
    NSString * longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    NSString * latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    
    if ([AppUtil isNetworkExist]) {
        
        [DEFAULTS setObject:longitude forKey:@"longitude"];
        
        [DEFAULTS setObject:latitude forKey:@"latitude"];
        
        reverseGeocodeSearchOption.reverseGeoPoint = pt;
        
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        
        _geocodesearch.delegate = self;
        
        BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if(flag)
        {

        }
        else
        {

        }
        

        
    }else{
    
        _titleView.text = @"网络异常-点此重试";
    
    }

    
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    _titleView.text = @"定位失败-点此重试";
}



-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    NSString *address = [NSString stringWithFormat:@"%@%@",result.addressDetail.streetName,result.addressDetail.streetNumber];

    
    if (error == 0){
        
        _titleView.text = address;
        
        [self getSizeCode:[AppUtil getCityCode:result.addressDetail.city]];
        
    }else{
        
//        NSLog(@"%d",error);
    }
    
}





#pragma mark - 懒加载数据源

-(NSMutableArray *)SpecialArray{
    
    if(_SpecialArray == nil){
        
        _SpecialArray = [NSMutableArray array];
        
    }
    return _SpecialArray;
}

-(NSMutableArray *)NearArray{
    
    if(_NearArray == nil){
        
        _NearArray = [NSMutableArray array];
        
    }
    return _NearArray;
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if(offsetY>85){
    
        self.tabBarController.navigationItem.leftBarButtonItem = _leftItem;
        
        self.tabBarController.navigationItem.rightBarButtonItem = _rightItem;
    
        
    }else{
    
        self.tabBarController.navigationItem.leftBarButtonItem = nil;
        
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }


}




//返回的图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{

    if(!_isFrist){
    
            return [UIImage imageNamed:@"empty_prompt"];
    
    }
    
    return nil;
}


//标题提示
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    
    if(!_isFrist){
    
    NSString *text = @"您当前附近没有店铺哟~";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
        
    }
    
    return nil;
}


#pragma mark - Action


-(void)pushMap{
    
    MapTableViewController *map = [[MapTableViewController alloc]init];
    
    UINavigationController *vc = [[UINavigationController alloc]initWithRootViewController:map];
    
    [self presentViewController:vc animated:YES completion:nil];
}



-(void)scanAction{
    
    if(IsLogin){
        
        SaoYiSaoViewController *sao = [[SaoYiSaoViewController alloc] init];

        [self.navigationController pushViewController:sao animated:YES];

    }else{
        
        [self loginAccount];
    }
    
}


-(void)soAction{
    
    if(IsLogin){
        
        SearchViewController *vc =[[SearchViewController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        [self loginAccount];
    }
    
}

-(void)couponAction{

    if(IsLogin){
        
        CouponViewController *vc =[[CouponViewController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        [self loginAccount];

    }

}


-(void)loginAccount{

    CodeLoginVC *vc = [[CodeLoginVC alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];

}


-(void)notice:(NSNotification *)not{
    
    _titleView.text = not.userInfo[@"address"];

    [self.tbView.mj_header beginRefreshing];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];

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

/**
 *
 */
