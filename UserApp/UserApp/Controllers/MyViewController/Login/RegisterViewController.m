//
//  RegisterViewController.m
//  UserApp
//
//  Created by prefect on 16/4/27.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIButton+CountDown.h"
#import "ReactiveCocoa.h"

@interface RegisterViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UITextField *phoneField;
@property(nonatomic,strong)UIView *lineView1;

@property(nonatomic,strong)UILabel *pwdLabel;
@property(nonatomic,strong)UITextField *pwdField;
@property(nonatomic,strong)UIView *lineView2;

@property(nonatomic,strong)UILabel *rePwdLabel;
@property(nonatomic,strong)UITextField *rePwdField;
@property(nonatomic,strong)UIView *lineView3;

@property(nonatomic,strong)UILabel *codeLabel;
@property(nonatomic,strong)UITextField *codeField;
@property(nonatomic,strong)UIButton *codeBtn;

@property(nonatomic,strong)UIButton *regBtn;

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation RegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户注册";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setSubViews];
    
    [self setAutoLayout];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    RACSignal *valid = [RACSignal combineLatest:@[_phoneField.rac_textSignal, _pwdField.rac_textSignal,_rePwdField.rac_textSignal, _codeField.rac_textSignal]
                                         reduce:^(NSString *phone, NSString *password,NSString *repassword, NSString *code) {
                                             return @(phone.length > 10 && password.length > 3  && repassword.length > 3 && code.length == 4);
                                         }];
    RAC(_regBtn, enabled) = valid;
    RAC(_regBtn, alpha) = [valid map:^(NSNumber *b) {
        return b.boolValue ? @1: @0.4;
    }];
}


-(void)regAction{
    
    
    _hud = [AppUtil createHUD];
    _hud.userInteractionEnabled = NO;
    
    if (![_pwdField.text isEqualToString:_rePwdField.text]) {

        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = [NSString stringWithFormat:@"两次密码输入不相同"];
        [_hud hide:YES afterDelay:3];
        
        return;
    }
    
    
    [AFHttpTool customerRegister:_phoneField.text
                       login_pwd:_pwdField.text
                        sms_code:_codeField.text
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
    
                             
                             _hud.mode = MBProgressHUDModeCustomView;
                             _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                             _hud.labelText = @"注册成功";
                             [_hud hide:YES afterDelay:2];
                             [self.navigationController popViewControllerAnimated:YES];
                            
    
                         } failure:^(NSError *err) {
                             _hud.mode = MBProgressHUDModeCustomView;
                             _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                             _hud.labelText = @"Error";
                             _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                             [_hud hide:YES afterDelay:3];
                             
                         }];
    

    
}


-(void)codeAction:(UIButton *)button{
    
    _hud = [AppUtil createHUD];
    _hud.labelText = @"正在发送...";
    _hud.userInteractionEnabled = NO;
    [AFHttpTool sendsmsRegister:_phoneField.text
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
                         

                         _hud.mode = MBProgressHUDModeCustomView;
                         _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                         _hud.labelText = @"验证码发送成功";
                         [_hud hide:YES afterDelay:2];
                         
                         [button startWithTime:60 title:@"重新获取" countDownTitle:@"s重新获取" mainColor:[UIColor colorWithHex:0xFD5B44] countColor:[UIColor grayColor]];
                         
                     } failure:^(NSError *err) {
                         _hud.mode = MBProgressHUDModeCustomView;
                         _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                         _hud.labelText = @"Error";
                         _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                         [_hud hide:YES afterDelay:3];
                         
                     }];

    
}

-(void)setSubViews{
    
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    //--------手机号
    
    _phoneLabel = [UILabel new];
    _phoneLabel.text=@"手机号码";
    [_phoneLabel setFont:[UIFont systemFontOfSize:14]];
    [_bgView addSubview:_phoneLabel];

    _phoneField = [UITextField new];
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneField.font = [UIFont systemFontOfSize:14];
    _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneField.placeholder = @"请输入手机号码";
    [_bgView addSubview:_phoneField];
    
    _lineView1 = [UIView new];
    _lineView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_bgView addSubview:_lineView1];
    
    
    //---------密码
    
    _pwdLabel = [UILabel new];
    _pwdLabel.text=@"密码";
    [_pwdLabel setFont:[UIFont systemFontOfSize:14]];
    [_bgView addSubview:_pwdLabel];
    
    _pwdField = [UITextField new];
    _pwdField.placeholder = @"请输入密码";
    _pwdField.font = [UIFont systemFontOfSize:14];
    _pwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdField.secureTextEntry = YES;
    [_bgView addSubview:_pwdField];
    
    _lineView2 = [UIView new];
    _lineView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_bgView addSubview:_lineView2];
    
    
    //---------确认密码
    
    _rePwdLabel = [UILabel new];
    _rePwdLabel.text=@"确认密码";
    [_rePwdLabel setFont:[UIFont systemFontOfSize:14]];
    [_bgView addSubview:_rePwdLabel];
    
    _rePwdField = [UITextField new];
    _rePwdField.placeholder = @"请输入确认密码";
    _rePwdField.font = [UIFont systemFontOfSize:14];
    _rePwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _rePwdField.secureTextEntry = YES;
    [_bgView addSubview:_rePwdField];
    
    _lineView3 = [UIView new];
    _lineView3.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_bgView addSubview:_lineView3];
    
    
    //--------验证码
    

    _codeLabel = [UILabel new];
    _codeLabel.text=@"验证码";
    [_codeLabel setFont:[UIFont systemFontOfSize:14]];
    [_bgView addSubview:_codeLabel];
    
    _codeField = [UITextField new];
    _codeField.keyboardType = UIKeyboardTypeNumberPad;
    _codeField.font = [UIFont systemFontOfSize:14];
    _codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeField.placeholder = @"输入验证码";
    [_bgView addSubview:_codeField];

    
    _codeBtn = [UIButton new];
    [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_codeBtn setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    [_codeBtn addTarget:self action:@selector(codeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_codeBtn];
    
    
    
    //注册按钮
    _regBtn = [UIButton new];
    [_regBtn setTitle:@"完成注册" forState:UIControlStateNormal];
    _regBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_regBtn setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    _regBtn.layer.cornerRadius = 3;
    [_regBtn addTarget:self action:@selector(regAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_regBtn];

}


-(void)setAutoLayout{

    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo([AppUtil getScreenWidth]);
        
        make.height.mas_equalTo(163);
        
        make.top.mas_equalTo(84);
    }];

    [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(40);
    }];
    
    [_lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(81);
    }];
    
    
    [_lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(122);
    }];
    

    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(14);
    }];
    
    
    [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(86);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(0);
    }];
    

    
    [_pwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView1.mas_bottom).offset(13);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(14);
    }];
    
    
    [_pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView1.mas_bottom).offset(10);
        make.left.mas_equalTo(86);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];

    
    [_rePwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView2.mas_bottom).offset(13);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(14);
    }];
    
    
    [_rePwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView2.mas_bottom).offset(10);
        make.left.mas_equalTo(86);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView3.mas_bottom).offset(13);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(14);
    }];
    
    
    [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView3.mas_bottom).offset(10);
        make.left.mas_equalTo(86);
        make.right.mas_equalTo(-95);
        make.height.mas_equalTo(20);
    }];
    
    
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView3.mas_bottom).offset(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(95);
        make.height.mas_equalTo(40);
    }];
    
    
    [_regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_bottom).offset(20.f);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(36);
    }];
    

}




-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_hud hide:YES];

}



- (void)hidenKeyboard
{
    [_phoneField resignFirstResponder];
    [_pwdField resignFirstResponder];
    [_rePwdField resignFirstResponder];
    [_codeField resignFirstResponder];
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
