//
//  SetPasswordViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/3.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "ReactiveCocoa.h"

@interface SetPasswordViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UISwitch *showPass;

@property (weak, nonatomic) IBOutlet UITextField *passFiled;

@property (weak, nonatomic) IBOutlet UITextField *againField;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _phoneLabel.text = [NSString stringWithFormat:@"手机号码    %@",LoginPhone];
    
    [self setSubViews];
    
    RACSignal *valid = [RACSignal combineLatest:@[_passFiled.rac_textSignal, _againField.rac_textSignal]
                                         reduce:^(NSString *account, NSString *password) {
                                             return @(account.length > 3 && password.length > 3);
                                         }];
    RAC(_nextBtn, enabled) = valid;
    RAC(_nextBtn, alpha) = [valid map:^(NSNumber *b) {
        return b.boolValue ? @1: @0.4;
    }];
}


-(void)setSubViews{

    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];

}



- (IBAction)onSwitch:(id)sender {

    if (_showPass.on) {
        

        _passFiled.secureTextEntry = NO;
        _againField.secureTextEntry = NO;
        _showPass.on=YES;
        NSString * text = _passFiled.text;
        _passFiled.text = @" ";
        _passFiled.text = text;
        NSString * text1 = _againField.text;
        _againField.text = @" ";
        _againField.text = text1;
        
    }else{
        
        _passFiled.secureTextEntry = YES;
        _againField.secureTextEntry = YES;
        _showPass.on = NO;
    }

}


- (IBAction)nextAction:(id)sender {

        
        _hud = [AppUtil createHUD];
        _hud.userInteractionEnabled = NO;
        
    [AFHttpTool customerLoginpwdUpdate:Cust_id
                               old_pwd:_passFiled.text
                               new_pwd:_againField.text
                              progress:^(NSProgress *progress) {
            
        } success:^(id response) {
            
            if (!([response[@"code"]integerValue]==0000)) {
                
                NSString *errorMessage = response [@"msg"];
                _hud.mode = MBProgressHUDModeCustomView;
                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                [_hud hide:YES afterDelay:2];
                
                return;
            }
            
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            _hud.labelText = [NSString stringWithFormat:@"修改成功"];
            [_hud hide:YES afterDelay:2];
            [self.navigationController popViewControllerAnimated:YES];

            
        } failure:^(NSError *err) {
            
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = @"Error";
            _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
            [_hud hide:YES afterDelay:2];
            
        }];

    
    
}



-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
 
    [_hud hide:YES];
}


- (void)hidenKeyboard
{
    [_passFiled resignFirstResponder];
    [_againField resignFirstResponder];
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
