//
//  MyViewController.m
//  UserApp
//
//  Created by prefect on 16/4/11.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "MyViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "MyOrderViewController.h"
#import "AddressListController.h"
#import "CodeViewController.h"
#import "MyFollowViewController.h"
#import "MyMessViewController.h"
#import "CouponViewController.h"
#import "ContactViewController.h"
#import "CodeLoginVC.h"


@interface MyViewController ()

@property(nonatomic,strong)UILabel * phoneLabel;





@end

@implementation MyViewController


-(void)viewWillAppear:(BOOL)animated{

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    
    self.tabBarController.navigationItem.titleView = nil;
    
    if (IsLogin) {
        _phoneLabel.text = LoginPhone;
    }else{
        _phoneLabel.text = @"点击登录";
    }

}


-(void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;

    [super viewWillDisappear:animated];

}


- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [self createBG];
    
    [self createView];
}


-(void)createBG{

    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 120)];
    headView.image = [UIImage imageNamed:@"my-top-bg"];
    [self.view addSubview:headView];

    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width/2 - 20, 40, 40, 40)];
    imageView.image = [UIImage imageNamed:@"my-logo"];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginAction)]];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width/2-75, 95, 150, 14)];
    _phoneLabel.textColor = [UIColor whiteColor];
    
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    _phoneLabel.font = [UIFont systemFontOfSize:14];
    [_phoneLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginAction)]];
    _phoneLabel.userInteractionEnabled = YES;
    [self.view addSubview:_phoneLabel];
    
    UIButton * setButton = [[UIButton alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width-44, 30, 24, 24)];
    [setButton setBackgroundImage:[UIImage imageNamed:@"my-setting"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setButton];
    
}




-(void)createView{
    
     UIButton *oneBtn = [UIButton new];
    oneBtn.backgroundColor = [UIColor whiteColor];
    [oneBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    oneBtn.tag = 1;
    [self.view addSubview:oneBtn];
    
    UILabel * orderLabel = [UILabel new];
    orderLabel.text = @"我的订单";
    orderLabel.font = [UIFont systemFontOfSize:14];
    [oneBtn addSubview:orderLabel];
    
    UILabel * allOrderLabel = [UILabel new];
    allOrderLabel.text = @"查看全部订单";
    allOrderLabel.textColor = [UIColor lightGrayColor];
    allOrderLabel.font = [UIFont systemFontOfSize:14];
    [oneBtn addSubview:allOrderLabel];
    
    UIImageView * markImage = [UIImageView new];
    markImage.image = [UIImage imageNamed:@"more"];
    [oneBtn addSubview:markImage];
    
    
    
    
    UIView *orderView = [UIView new];
    orderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:orderView];
    
    
    UIButton *addrBtn = [UIButton new];
    [addrBtn setImage:[UIImage imageNamed:@"my-1"] forState:UIControlStateNormal];
    [addrBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    addrBtn.adjustsImageWhenHighlighted = NO;
    addrBtn.tag = 2;
    [orderView addSubview:addrBtn];
    
    UIButton *payBtn = [UIButton new];
    [payBtn setImage:[UIImage imageNamed:@"my-2"] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.adjustsImageWhenHighlighted = NO;
    payBtn.tag = 3;
    [orderView addSubview:payBtn];
    
//    UIButton *eveBtn = [UIButton new];
//    [eveBtn setImage:[UIImage imageNamed:@"my-3"] forState:UIControlStateNormal];
//    [eveBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//    eveBtn.adjustsImageWhenHighlighted = NO;
//    eveBtn.tag = 4;
//    [orderView addSubview:eveBtn];
    
    
    
    
    
    UIView *subView = [UIView new];
    subView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:subView];
    
    UIButton *addressBtn = [UIButton new];
    addressBtn.backgroundColor = [UIColor whiteColor];
    [addressBtn setImage:[UIImage imageNamed:@"my-4"] forState:UIControlStateNormal];
    [addressBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    addressBtn.adjustsImageWhenHighlighted = NO;
    addressBtn.tag = 5;
    [subView addSubview:addressBtn];
    
    UIButton *attBtn = [UIButton new];
    attBtn.backgroundColor = [UIColor whiteColor];
    [attBtn setImage:[UIImage imageNamed:@"my-5"] forState:UIControlStateNormal];
    [attBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    attBtn.adjustsImageWhenHighlighted = NO;
    attBtn.tag = 6;
    [subView addSubview:attBtn];
    
    UIButton *couBtn = [UIButton new];
    couBtn.backgroundColor = [UIColor whiteColor];
    [couBtn setImage:[UIImage imageNamed:@"my-6"] forState:UIControlStateNormal];
    [couBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    couBtn.adjustsImageWhenHighlighted = NO;
    couBtn.tag = 7;
    [subView addSubview:couBtn];
    
    UIButton *messBtn = [UIButton new];
    messBtn.backgroundColor = [UIColor whiteColor];
    [messBtn setImage:[UIImage imageNamed:@"my-7"] forState:UIControlStateNormal];
    [messBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    messBtn.adjustsImageWhenHighlighted = NO;
    messBtn.tag = 8;
    [subView addSubview:messBtn];
    
    UIButton *baBtn = [UIButton new];
    baBtn.backgroundColor = [UIColor whiteColor];
    [baBtn setImage:[UIImage imageNamed:@"my-8"] forState:UIControlStateNormal];
    [baBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    baBtn.adjustsImageWhenHighlighted = NO;
    baBtn.tag = 9;
    [subView addSubview:baBtn];
    
    UIButton *shBtn = [UIButton new];
    shBtn.backgroundColor = [UIColor whiteColor];
    [shBtn setImage:[UIImage imageNamed:@"my-9"] forState:UIControlStateNormal];
    [shBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    shBtn.adjustsImageWhenHighlighted = NO;
    shBtn.tag = 10;
    [subView addSubview:shBtn];
    

    
    
    __weak typeof(self) weakSelf = self;
    
    CGFloat w = weakSelf.view.bounds.size.width;
    
    CGFloat orderH = w * (85.f/375.f);
    
    
    
    
    [oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(125);
        make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width, 44));
        
    }];
    [orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(30);
        make.height.mas_equalTo(14);
    }];
    
    [allOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(14);
    }];
    [markImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-17);
        make.size.mas_equalTo(CGSizeMake(7, 14));
    }];
    
    
    
    
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(oneBtn.mas_bottom).offset(1.f);
        
        make.left.mas_equalTo(0);
        
        make.size.mas_equalTo(CGSizeMake(w, orderH));
        
    }];
    
    
    
    [addrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(w/3.f,orderH));
    }];
    
    
    
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-30);
        make.size.mas_equalTo(CGSizeMake(w/3.f,orderH));
    }];
    
//    [eveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(w/3.f,orderH));
//    }];
    

    
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(w, 2 * w * (95.f/375.f)+1));
        make.left.mas_equalTo(0);
        make.top.equalTo(orderView.mas_bottom).offset(5.f);
        
    }];

    
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake((w-2)/3.f, w * (95.f/375.f)));
    }];
    
    
    [attBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(addressBtn.mas_right).offset(1.f);
        make.size.mas_equalTo(CGSizeMake((w-2)/3.f, w * (95.f/375.f)));
    }];
    
    
    [couBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake((w-2)/3.f, w * (95.f/375.f)));
    }];
    
    
    [messBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake((w-2)/3.f, w * (95.f/375.f)));
    }];
    
    [baBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.equalTo(messBtn.mas_right).offset(1.f);
        make.size.mas_equalTo(CGSizeMake((w-2)/3.f, w * (95.f/375.f)));
    }];
    
    [shBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake((w-2)/3.f, w * (95.f/375.f)));
    }];
    
    

}



-(void)setAction{
    
    SettingViewController *vc = [[SettingViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)loginAction{
    
    BOOL isLogin = IsLogin;
    
    if (isLogin) {
        return;
    }
    
    //LoginViewController *vc = [[LoginViewController alloc]init];
    CodeLoginVC * vc = [[CodeLoginVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
    
    
    
    
    
}

-(void)btnAction:(UIButton *)btn{

    
    if(!IsLogin){
    
        CodeLoginVC *vc = [[CodeLoginVC alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:nil];

    }else{

        if (btn.tag == 1 || btn.tag == 2 || btn.tag == 3 || btn.tag == 4) {
            
            MyOrderViewController *vc= [[MyOrderViewController alloc]init];
            
            vc.type = btn.tag;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if(btn.tag == 5){
        
            AddressListController *vc =[[AddressListController alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
        
        }else if(btn.tag == 6){
            
            MyFollowViewController *vc =[[MyFollowViewController alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if(btn.tag == 7){
            
            CouponViewController *vc =[[CouponViewController alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if(btn.tag == 8){
            
            MyMessViewController *vc = [[MyMessViewController alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if(btn.tag == 9){
        
            CodeViewController *vc = [[CodeViewController alloc]init];
        
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if(btn.tag == 10){
        
            ContactViewController *vc = [[ContactViewController alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    
    }
    

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
