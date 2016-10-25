//
//  InformationViewController.m
//  UsersApp
//
//  Created by perfect on 16/3/24.
//  Copyright © 2016年 prefect. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController ()

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于闪酒客";
    
    self.view.backgroundColor  = [UIColor groupTableViewBackgroundColor];
    
    UIView * allView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 150)];
    allView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:allView];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-20, 100, 40, 40)];
    imageView.image = [UIImage imageNamed:@"my-logo"];
    [self.view addSubview:imageView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 15)];
    titleLabel.text = @"闪酒客";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel * versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 175, self.view.bounds.size.width, 15)];
    NSString *ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    versionLabel.text = [NSString stringWithFormat:@"V %@",ver];
    versionLabel.font = [UIFont systemFontOfSize:15];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    
    
    UILabel * gslabel = [[UILabel alloc]initWithFrame:CGRectMake(0,230, [[UIScreen mainScreen] bounds].size.width, 15)];
    gslabel.text = @"上海嘉逸网络科技有限公司";
    gslabel.textAlignment = NSTextAlignmentCenter;
    gslabel.textColor = [UIColor blackColor];
    gslabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:gslabel];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 256, self.view.bounds.size.width, 14)];
    label2.text = @"Copyright © 2015-2016 SJK";
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = [UIColor lightGrayColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 275, self.view.bounds.size.width, 20)];
    label3.text =@"all right reserved";
    label3.textColor = [UIColor lightGrayColor];
    label3.font = [UIFont systemFontOfSize:14];
    label3.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label3];
    
    
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
