//
//  AreaViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/7.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "AreaViewController.h"
#import "CityViewController.h"
#import "AreaModel.h"


@interface AreaViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation AreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择区域";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.tableView setTableFooterView:footView];
    
    [self loadData];
    
}



-(void)loadData{

    
    _hud = [AppUtil createHUD];
    _hud.labelText = @"加载中...";
    _hud.userInteractionEnabled = NO;
    
    [AFHttpTool getProvinceList:@"Province" progress:^(NSProgress *progress) {
        
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

                AreaModel *model = [[AreaModel alloc]init];
                
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
    
    AreaModel *model = self.dataArray[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = model.province;
    
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


    CityViewController *cityVC = [[CityViewController alloc]init];
    
    AreaModel *model = self.dataArray[indexPath.row];

    cityVC.province = model.province;
    
    cityVC.province_id = model.sId;
    
    [self.navigationController pushViewController:cityVC animated:YES];

}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
