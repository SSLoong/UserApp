//
//  PlaceViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/7.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "PlaceViewController.h"
#import "CountyModel.h"
#import "CountyModel.h"


@interface PlaceViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation PlaceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择县区";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.tableView setTableFooterView:footView];
    
    [self loadData];
    
}



-(void)loadData{
    
    _hud = [AppUtil createHUD];
    _hud.labelText = @"加载中...";
    _hud.userInteractionEnabled = NO;
    
    [AFHttpTool getCountyList:self.city_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
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
            
            CountyModel *model = [[CountyModel alloc]init];
            
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
    
    CountyModel *model = self.dataArray[indexPath.row];
    
    cell.textLabel.text = model.area;
    
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

    UIViewController *temp = nil;
    NSArray *viewControllers = self.navigationController.viewControllers;
    temp = viewControllers[viewControllers.count -4];
    
    CountyModel *model = self.dataArray[indexPath.row];
    
    NSNotification * notice = [NSNotification notificationWithName:@"areaNotice" object:nil userInfo:@{@"province":self.province,@"city":self.city,@"site_code":self.city_id,@"area":model.area}];
    
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    [self.navigationController popToViewController:temp animated:YES];
    
}




-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];

}





@end