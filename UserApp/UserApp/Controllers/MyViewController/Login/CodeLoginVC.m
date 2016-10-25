//
//  CodeLoginVC.m
//  UserApp
//
//  Created by wangyebin on 16/9/6.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "CodeLoginVC.h"
#import "LoginViewController.h"
#import "Tool.h"

@interface CodeLoginVC ()<UITextFieldDelegate>

{
    UIView * bgView;
}

@property(nonatomic,strong)UITextField *accountField;
@property(nonatomic,strong)UITextField *passwordField;

@property(nonatomic,strong)UIButton *loginBtn;
@property (nonatomic, strong) UIButton * getBtn;


@property (nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic,copy)NSString *store_id;
@property (assign, nonatomic) NSInteger count;//计数
@property (strong, nonatomic) NSTimer * timer;

@end

@implementation CodeLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 60;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(gotoLogin)];
    self.title = @"登录";
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"密码登录" style:UIBarButtonItemStylePlain target:self action:@selector(gotoLogin)];
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = item;
    
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissAction)];
    ;
    self.navigationItem.leftBarButtonItem = item1;

    
    
    [self setSubViews];
    // Do any additional setup after loading the view.
}

- (void)gotoLogin
{
    LoginViewController * vc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)dismissAction{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)setSubViews{
    
//    UIImageView *logo = [UIImageView new];
//    logo.contentMode = UIViewContentModeScaleAspectFit;
//    logo.image = [UIImage imageNamed:@"my-logo"];
//    [logo setCornerRadius:30];
//    [self.view addSubview:logo];
    
    bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bgView addSubview:lineView];
    
    
    UILabel *PhoneLabel = [UILabel new];
    PhoneLabel.text=@"手机号";
    PhoneLabel.font = HelveticaNeueFont(14);
    [bgView addSubview:PhoneLabel];
    
    UILabel *PassLabel = [UILabel new];
    PassLabel.text=@"验证码";
    PassLabel.font = HelveticaNeueFont(14);
    [bgView addSubview:PassLabel];
    
    _accountField = [UITextField new];
    _passwordField = [UITextField new];
    _accountField.keyboardType = UIKeyboardTypeNumberPad;
    _passwordField.keyboardType = UIKeyboardTypeNumberPad;
    _accountField.font = HelveticaNeueLightFont(14);
    _passwordField.font = HelveticaNeueLightFont(14);
    _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.returnKeyType = UIReturnKeyGo;
    _passwordField.secureTextEntry = YES;
    _accountField.placeholder = @"请填写手机号";
    _passwordField.placeholder = @"请填写验证码";
    _accountField.delegate = self;
    _passwordField.delegate = self;
    _accountField.text = [self getDefaultUserName];
    [bgView addSubview:_accountField];
    [bgView addSubview:_passwordField];
    
//    [_passwordField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    
    
    _loginBtn = [UIButton new];
    [_loginBtn setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius = 3;
    [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    _getBtn = [UIButton new];
    _getBtn.backgroundColor = [UIColor colorWithHex:0xFD8607];
    
    //[_getBtn setTitleColor:[UIColor colorWithHex:0xFD5B44] forState:UIControlStateNormal];
    [_getBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:11]];
    [_getBtn addTarget:self action:@selector(getAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_getBtn];
    
    
       //__weak typeof(self) weakSelf = self;
    
   
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo([AppUtil getScreenWidth]);
        make.height.mas_equalTo(81);
        make.left.mas_equalTo(self.view);
        make.top.equalTo(self.view).offset(8);
        
        
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(1);
        
        make.left.mas_equalTo(20);
        
        make.right.mas_equalTo(0);
        
        make.top.mas_equalTo(40);
        
    }];
    
    
    [PhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView.mas_top).offset(0);
        
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(50);
        
        
    }];
    
    [PassLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView.mas_top).offset(41);
        
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(50);
        
    }];
    
    
    
    
    [_accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(bgView.mas_left).offset(90);
        
        make.top.equalTo(bgView.mas_top).offset(0);
        
        make.height.mas_equalTo(40);
        
        make.right.equalTo(bgView.mas_right).offset(0);
        
        
    }];
    
    
    
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(bgView.mas_left).offset(90);
        
        make.top.equalTo(bgView.mas_top).offset(41);
        
        make.height.mas_equalTo(40);
        
        make.right.equalTo(bgView.mas_right).offset(60);
        
    }];
    
    
    
    
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView.mas_bottom).offset(20.f);
        
        make.left.mas_equalTo(10);
        
        make.right.mas_equalTo(-10);
        
        make.height.mas_equalTo(36);
        
    }];
    
    [_loginBtn setCornerRadius:18];
    
   [_getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-12);
       make.width.mas_equalTo(80);
       make.height.mas_equalTo(20);
       make.centerY.equalTo(_passwordField);
    }];
    [_getBtn setCornerRadius:10];
      
    
    
    
    
}

- (void)loginAction:(UIButton *)button
{
    if (self.accountField.text.length != 11) {
        [self.view showLoadingWithMessage:@"请填写正确的手机号" hideAfter:2.5];
        return;
    }
    if (self.passwordField.text.length != 4) {
        [self.view showLoadingWithMessage:@"请填写正确的验证码" hideAfter:2.5];
        return;
    }
    
    _hud = [AppUtil createHUD];
    _hud.labelText = @"正在登录...";
    
    [AFHttpTool customerLoginPhone:self.accountField.text sms_code:self.passwordField.text devices:[AppUtil deviceVersion] devices_id:[AppUtil UUIDString] progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        WYBLog(@"%@",response);
        
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        
        [DEFAULTS setBool:YES forKey:@"isLogin"];
        
        [DEFAULTS setObject:_accountField.text forKey:@"userName"];
        
        [DEFAULTS setObject:response[@"data"][@"cust_id"] forKey:@"cust_id"];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
            [_hud hide:YES];
        }];
        
    } failure:^(NSError *err) {
        WYBLog(@"%@",err);
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];


    
}

- (void)getAction:(UIButton *)button
{
    if (self.accountField.text.length != 11) {
        [self.view showLoadingWithMessage:@"请填写正确的手机号" hideAfter:2.5];
        return;
    }
    
    [self.view showLoading];
    [AFHttpTool getLoginCdoe:self.accountField.text progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        [self.view hideLoading];
        WYBLog(@"%@",response);
        NSDictionary * dic = response;
        if ([dic[@"code"] isEqualToString:@"0000"]) {
            [self updateUI];
        }else{
            [self.view showLoadingWithMessage:dic[@"msg"] hideAfter:2.5];
        }
        
    } failure:^(NSError *err) {
        [self.view hideLoading];
        
        [self.view showLoadingWithMessage:@"网络错误" hideAfter:2.5];
    }];
    
}

- (void)updateUI
{
    [bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(122);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bgView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(81);
    }];
    
    UILabel * message = [[UILabel alloc]init];
    message.text = @"您即将收到来自05148204327*的语音验证码";
    message.font = [UIFont systemFontOfSize:12.0];
    message.attributedText = [Tool addColorWithString:@"您即将收到来自05148204327*的语音验证码" atRange:NSMakeRange(7, 12) withColor:[UIColor colorWithHex:0xFD5B44]];
    [bgView addSubview:message];
    [message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(13);
        make.bottom.mas_equalTo(-15);
    }];
    
    
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    
    _timer.fireDate = [NSDate distantPast];

}

- (void)timerAction
{
    if (self.count == 0) {
        self.timer.fireDate = [NSDate distantFuture];
        self.count = 60;
        self.getBtn.userInteractionEnabled = YES;
        _getBtn.backgroundColor = [UIColor colorWithHex:0xFD8607];

        [self.getBtn setTitle:[NSString stringWithFormat:@"%@",@"获取验证码"] forState:UIControlStateNormal];

        
        
    }else{
        
        self.count--;
        self.getBtn.userInteractionEnabled = NO;
        self.getBtn.backgroundColor = [UIColor lightGrayColor];
        [self.getBtn setTitle:[NSString stringWithFormat:@"%ld 重新获取",(long)self.count] forState:UIControlStateNormal];
    }
}

- (NSString*)getDefaultUserName
{
    NSString* defaultUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    return defaultUser;
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

- (void)dealloc{
    [_timer invalidate];
}

@end
