//
//  SettingViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/21.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SettingViewController.h"
#import "InformationViewController.h"
#import "SetPasswordViewController.h"

@interface SettingViewController ()<UIAlertViewDelegate>

@end

@implementation SettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"设置";
    self.view .backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    BOOL isLogin = IsLogin;
    if (isLogin) {

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 15, [AppUtil getScreenWidth], 44);
        btn.backgroundColor = [UIColor colorWithHex:0xFD5B44];
        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        self.tableView.tableFooterView = btn;
        
    }else{
    
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    }

}


-(void)logoutAction{


    [DEFAULTS removeObjectForKey:@"cust_id"];
    [DEFAULTS removeObjectForKey:@"isLogin"];
    [DEFAULTS removeObjectForKey:@"passWord"];
    [DEFAULTS synchronize];

    
    [self.navigationController popViewControllerAnimated:YES];

    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{


    return 10;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    BOOL isLogin = IsLogin;
    
    if (isLogin) {
        
        return 3;
    }
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [UITableViewCell new];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.textLabel.text = @[@"关于我们", @"清除缓存", @"修改密码"][indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    if (1 == indexPath.row) {
        //清除缓存
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"是否清理缓存？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        alertView.tag = 1011;
        [alertView show];
    }else if(indexPath.row == 0){
    
        InformationViewController *vc= [[InformationViewController alloc]init];

        [self.navigationController pushViewController:vc animated:YES];
    
    }else if (indexPath.row == 2){
    
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"SetPassword" bundle:nil];
        
        SetPasswordViewController *ctrlVc = [story instantiateViewControllerWithIdentifier:@"SetPasswordVc"];
        
        [self.navigationController pushViewController:ctrlVc animated:YES];
    
    }




}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1 && alertView.tag == 1011) {
        [self clearCache];
        
    }
}


//清理缓存
-(void) clearCache
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess)
                                              withObject:nil waitUntilDone:YES];});
}

-(void)clearCacheSuccess
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"缓存清理成功！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}



@end
