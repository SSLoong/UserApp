//
//  CityViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/7.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "CityViewController.h"
#import "CityModel.h"
#import "PlaceViewController.h"

@interface CityViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation CityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择城市";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.tableView setTableFooterView:footView];
    
    [self loadData];
    
}



-(void)loadData{
    
    
    _hud = [AppUtil createHUD];
    _hud.labelText = @"加载中...";
    _hud.userInteractionEnabled = NO;
    
    [AFHttpTool getCityList:self.province_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        NSLog(@"%@",response);
        
        if (![response[@"code"]isEqualToString:@"0000"]) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误：%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        
        
        NSArray *dataArr = response [@"data"];
        
        for (NSDictionary *dic in dataArr) {
            
            CityModel *model = [[CityModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [self.dataArray addObject:model];
        }
        
        [_hud hide:YES];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_hud hide:YES];
}

//懒加载数组
-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [UITableViewCell new];
    
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    
    CityModel *model = self.dataArray[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = model.city;
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PlaceViewController *cityVC = [[PlaceViewController alloc]init];
    
    CityModel *model = self.dataArray[indexPath.row];
    
    cityVC.city_id = model.sId;
    
    cityVC.city = model.city;
    
    cityVC.province = self.province;
    
    [self.navigationController pushViewController:cityVC animated:YES];
    
}


@end