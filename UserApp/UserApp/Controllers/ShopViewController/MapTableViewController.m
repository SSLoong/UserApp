//
//  MapTableViewController.m
//  UserApp
//
//  Created by prefect on 16/4/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "MapTableViewController.h"
#import "CurrentLocationCell.h"
#import "AddressModel.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import <CoreLocation/CoreLocation.h>


static NSString* const kCurrentLocationCell = @"currentLocationCell";

@interface MapTableViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)BMKGeoCodeSearch* geocodesearch;

@property(nonatomic,strong)BMKLocationService *locService;

@property(nonatomic,copy)NSString *longitude;//坐标经度

@property(nonatomic,copy)NSString *latitude;//坐标纬度

@property(nonatomic,copy)NSString *address;//地址

@property(nonatomic,copy)NSString *city;//城市


@end

@implementation MapTableViewController

-(id)initWithStyle:(UITableViewStyle)style{

    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
    
        
    }
    return self;

}


-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
    
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [_hud hide:YES];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    CurrentLocationCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        
        [[[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请进入系统[设置] > [隐私] > [定位服务] 中打开开关,并允许闪酒客使用定位服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即开启", nil] show];
        
        cell.locationImageView.hidden = NO;
        cell.activityIndicatorView.hidden = YES;
        if ([cell.activityIndicatorView isAnimating]) {
            [cell.activityIndicatorView stopAnimating];
        }
        cell.currentLocationLabel.text = @"定位服务未开启";
        _address = nil;
        
        return;
    }

    
    if(![AppUtil isNetworkExist]){
    
        cell.locationImageView.hidden = NO;
        cell.activityIndicatorView.hidden = YES;
        if ([cell.activityIndicatorView isAnimating]) {
            [cell.activityIndicatorView stopAnimating];
        }
        cell.currentLocationLabel.text = @"网络异常-请检测网络";
        _address = nil;
        return;
    }
    

    cell.locationImageView.hidden = YES;
    cell.activityIndicatorView.hidden = NO;
    [cell.activityIndicatorView startAnimating];
    cell.currentLocationLabel.text = @"定位中...";
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title=@"选择收货地址";
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(disMissAction)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self.tableView registerClass:[CurrentLocationCell class] forCellReuseIdentifier:kCurrentLocationCell];

    _longitude = @"";
    _latitude = @"";
    _address = @"";
    
    [self loadData];
}



-(void)loadData{
    
    BOOL isLogin = IsLogin;
    
    if (!isLogin) {
        
        return;
        
    }
    
    
    _hud = [AppUtil createHUD];
    
    _hud.userInteractionEnabled = NO;
    
    [AFHttpTool addressList:Cust_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (![response[@"code"]isEqualToString:@"0000"]) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        
        NSArray * dicArray = response[@"data"];
        
        
        for (NSDictionary * dic in dicArray) {
            
            AddressModel * model = [[AddressModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            
            
            [self.dataArray addObject:model];
        }
        
        
        [self.tableView reloadData];
        
        [_hud hide:YES];
        
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
}


-(void)disMissAction{

    [self dismissViewControllerAnimated:YES completion:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - 定位相关


//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{

    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude};
    
    _latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    
    _longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    _geocodesearch.delegate = self;
    
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
    [_locService stopUserLocationService];
    
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        CurrentLocationCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.locationImageView.hidden = NO;
        cell.activityIndicatorView.hidden = YES;
        [cell.activityIndicatorView stopAnimating];
        cell.currentLocationLabel.text = @"定位失败-请重试";
        _address = nil;
    });

}



-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
    
    if (error == 0){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        CurrentLocationCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.locationImageView.hidden = NO;
        cell.activityIndicatorView.hidden = YES;
        [cell.activityIndicatorView stopAnimating];
        cell.currentLocationLabel.text = address;
        _address = address;
        _city = result.addressDetail.city;
    }else{
        
        NSLog(@"%d",error);
    }
    
}



#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (section == 0) {
        return 1;
    }else{
        return _dataArray.count;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        
        CurrentLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:kCurrentLocationCell forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.repositionButton addTarget:self action:@selector(repositionAction) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }else{
        
        static NSString * showUserInfoCellIdentifier = @"ShowUserInfoCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
        if (cell == nil)
        {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:showUserInfoCellIdentifier];
        }
        
        AddressModel *model = _dataArray[indexPath.row];
        
        cell.textLabel.text= [NSString stringWithFormat:@"%@  %@",model.receiver,model.phone];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        cell.detailTextLabel.text = model.address;
        
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section == 0){
    
        if (_address.length!=0) {

            [self getSizeCode:[AppUtil getCityCode:_city]];
        }
    
    }else if(indexPath.section == 1){

        AddressModel *model = _dataArray[indexPath.row];
        [DEFAULTS setObject:model.site_code forKey:@"siteCode"];
        [DEFAULTS setObject:model.longitude forKey:@"longitude"];
        [DEFAULTS setObject:model.latitude forKey:@"latitude"];
        NSNotification * notice = [NSNotification notificationWithName:@"updataMap" object:nil userInfo:@{@"address":model.address}];
        [[NSNotificationCenter defaultCenter]postNotification:notice];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}







-(void)getSizeCode:(NSString *)cityCode{
    
    _hud = [AppUtil createHUD];
    
    _hud.userInteractionEnabled = NO;
    
    [AFHttpTool siteCode:cityCode progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (![response[@"code"]isEqualToString:@"0000"]) {
    
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }


        
        if ([response[@"data"] isKindOfClass:[NSNull class]] || [response[@"data"][@"status"]integerValue] != 1) {
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"此地址附近还没有商户哦"];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        
        [_hud hide:YES];
        
        NSString *siteCode = [NSString stringWithFormat:@"%@",response[@"data"][@"site_code"]];
        [DEFAULTS setObject:siteCode forKey:@"siteCode"];
        [DEFAULTS setObject:_longitude forKey:@"longitude"];
        [DEFAULTS setObject:_latitude forKey:@"latitude"];

        
        NSNotification * notice = [NSNotification notificationWithName:@"updataMap" object:nil userInfo:@{@"address":_address}];
        
        [[NSNotificationCenter defaultCenter]postNotification:notice];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
    }];

}



-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return @"当前位置";
    }else{
        
        BOOL isLogin = IsLogin;
        
        if (isLogin) {
            
            return @"收货地址";
            
        }else{
            
            return @"";
        }
        

    }
    
}



-(void)repositionAction{
    

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    CurrentLocationCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        
        [[[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请进入系统[设置] > [隐私] > [定位服务] 中打开开关,并允许闪酒客使用定位服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即开启", nil] show];
        
        cell.locationImageView.hidden = NO;
        cell.activityIndicatorView.hidden = YES;
        if ([cell.activityIndicatorView isAnimating]) {
        [cell.activityIndicatorView stopAnimating];
        }
        cell.currentLocationLabel.text = @"定位服务未开启";
        
        return;
    }
    
    if(![AppUtil isNetworkExist]){
        
        cell.locationImageView.hidden = NO;
        cell.activityIndicatorView.hidden = YES;
        if ([cell.activityIndicatorView isAnimating]) {
            [cell.activityIndicatorView stopAnimating];
        }
        cell.currentLocationLabel.text = @"网络异常-请检测网络";
        _address = nil;
        return;
        
    }
    
    
    
    cell.locationImageView.hidden = YES;
    cell.activityIndicatorView.hidden = NO;
    [cell.activityIndicatorView startAnimating];
    cell.currentLocationLabel.text = @"定位中...";
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    

    if (buttonIndex == 0) {
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}


@end
