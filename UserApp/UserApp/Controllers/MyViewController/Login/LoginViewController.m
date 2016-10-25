//
//  LoginViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/2.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ReactiveCocoa.h"
#import "RetPwdViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UITextField *accountField;

@property(nonatomic,strong)UITextField *passwordField;

@property(nonatomic,strong)UIButton *loginBtn;

@property (nonatomic, strong) MBProgressHUD *hud;

@property(nonatomic,copy)NSString *store_id;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"密码登录";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
       
    
    [self setSubViews];
    
    
    RACSignal *valid = [RACSignal combineLatest:@[_accountField.rac_textSignal, _passwordField.rac_textSignal]
                                         reduce:^(NSString *account, NSString *password) {
                                             return @(account.length > 10 && password.length > 3);
                                         }];
    RAC(_loginBtn, enabled) = valid;
    RAC(_loginBtn, alpha) = [valid map:^(NSNumber *b) {
        return b.boolValue ? @1: @0.4;
    }];
}




-(void)setSubViews{
    
    //    UIImageView *logo = [UIImageView new];
    //    logo.contentMode = UIViewContentModeScaleAspectFit;
    //    logo.image = [UIImage imageNamed:@"my-logo"];
    //    [logo setCornerRadius:30];
    //    [self.view addSubview:logo];
    
   UIView * bgView = [UIView new];
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
    
    
    
    
    
}


-(void)viewDidDisappear:(BOOL)animated{


    [super viewDidDisappear:animated];
    
    [_hud hide:YES];
    
}


-(void)loginAction:(id)sender{

    
    _hud = [AppUtil createHUD];
    _hud.labelText = @"正在登录...";
    _hud.userInteractionEnabled = NO;

    [AFHttpTool customerLogin:_accountField.text
                    login_pwd:_passwordField.text
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

        [DEFAULTS setBool:YES forKey:@"isLogin"];
        
        [DEFAULTS setObject:_accountField.text forKey:@"userName"];
        
        [DEFAULTS setObject:response[@"data"][@"cust_id"] forKey:@"cust_id"];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
            [_hud hide:YES];
        }];

    } failure:^(NSError *err) {
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
    
    
    
    
}




-(void)getAction:(id)sender{
    

    RegisterViewController *vc= [[RegisterViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];


}


-(void)comeAction:(id)sender{

    RetPwdViewController *vc= [[RetPwdViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}



- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    
    if (textField == _accountField) {
        [DEFAULTS removeObjectForKey:@"userName"];
        _accountField.text = nil;
    }
    return YES;
}



- (NSString*)getDefaultUserName
{
    NSString* defaultUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    return defaultUser;
}

#pragma mark - 键盘操作

- (void)returnOnKeyboard:(UITextField *)sender
{
    
 if (sender == _passwordField) {

     [self hidenKeyboard];
     if (_loginBtn.enabled) {

         [self loginAction:self];
         
     }

 }
}

- (void)hidenKeyboard
{
    [_accountField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

#pragma mark - textField的代理方法

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _accountField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    
    return YES;
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
