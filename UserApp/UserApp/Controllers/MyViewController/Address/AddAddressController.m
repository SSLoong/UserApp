//
//  AddAddressController.m
//  UserApp
//
//  Created by prefect on 16/4/13.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "AddAddressController.h"
#import "AreaViewController.h"

@interface AddAddressController ()

@property (weak, nonatomic) IBOutlet UIButton *nanBtn;

@property (weak, nonatomic) IBOutlet UIButton *nvBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameFiled;

@property (weak, nonatomic) IBOutlet UITextField *phoneFiled;

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@property (weak, nonatomic) IBOutlet UITextField *detailFiled;

@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation AddAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加地址";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(addAction)];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    

    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"areaNotice" object:nil];
    
    
    if (_type) {
        
        _nameFiled.text = _receiver;
        
        if ([_sex isEqualToString:@"M"]) {
            
            _nanBtn.selected = YES;
            
        }else{
            
            _nvBtn.selected = YES;
        }
        
        
        _phoneFiled.text = _phone;
        
        if (_defaultAddress == 1 ) {
            
            _defaultBtn.selected = YES;
            
            _defaultBtn.userInteractionEnabled = NO;
        }
        
        _areaLabel.text =[NSString stringWithFormat:@"%@ %@ %@",_province,_city,_area];
        
        _areaLabel.textColor = [UIColor blackColor];
        
        _detailFiled.text = _address;

        
    }else{
    
        _nanBtn.selected = YES;
        
        _sex = @"M";
        
        _defaultBtn.selected = YES;
        
        _defaultAddress = 1;

    }
}


-(void)notice:(NSNotification *)not{
    
    _province = not.userInfo[@"province"];
    
    _city = not.userInfo[@"city"];
    
    _site_code = not.userInfo[@"site_code"];
    
    _area = not.userInfo[@"area"];
    
    _areaLabel.text =[NSString stringWithFormat:@"%@ %@ %@",_province,_city,_area];
    
    _areaLabel.textColor = [UIColor blackColor];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


-(void)addAction{

    _hud = [AppUtil createHUD];
    _hud.labelText = @"请稍后...";
    _hud.userInteractionEnabled = YES;
    
    
    if (_nameFiled.text.length == 0) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = [NSString stringWithFormat:@"请输入收货人姓名"];
        [_hud hide:YES afterDelay:2];
        
        return;
    }

    if (_phoneFiled.text.length == 0) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = [NSString stringWithFormat:@"请输入手机号码"];
        [_hud hide:YES afterDelay:2];
        
        return;
    }
    
    if ([_areaLabel.text isEqualToString:@"请选择收货人的地区"]) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = [NSString stringWithFormat:@"请选择收货人的地区"];
        [_hud hide:YES afterDelay:2];
        
        return;
    }
    
    if (_detailFiled.text.length == 0) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = [NSString stringWithFormat:@"请输入详细地址"];
        [_hud hide:YES afterDelay:2];
        
        return;
    }
    
    
    
    if (_type) {

        [AFHttpTool addressUpdate:Cust_id
                          addr_id:_addr_id
                              sex:_sex
                            phone:_phoneFiled.text
                         province:_province
                             city:_city
                             area:_area
                          address:_detailFiled.text
                        site_code:_site_code
                         receiver:_nameFiled.text
                       is_default:_defaultAddress
                         progress:^(NSProgress *progress) {
                             
                         } success:^(id response) {
                             
                             if (![response[@"code"]isEqualToString:@"0000"]) {
                                 
                                 NSString *errorMessage = response [@"msg"];
                                 _hud.mode = MBProgressHUDModeCustomView;
                                 _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                 _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                                 [_hud hide:YES afterDelay:3];
                                 
                                 return;
                             }
                             
                             
                             [_hud hide:YES];
                             
                             [self.navigationController popViewControllerAnimated:YES];
                             
                             
                         } failure:^(NSError *err) {
                             
                             _hud.userInteractionEnabled = NO;
                             _hud.mode = MBProgressHUDModeCustomView;
                             _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                             _hud.labelText = @"error";
                             _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                             [_hud hide:YES afterDelay:3];
                             
                         }];
        
        
    }else{

    
    [AFHttpTool addressInsert:Cust_id
                          sex:_sex
                        phone:_phoneFiled.text
                     province:_province
                         city:_city
                         area:_area
                      address:_detailFiled.text
                     receiver:_nameFiled.text
                    site_code:_site_code
                   is_default:_defaultAddress
                   progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (![response[@"code"]isEqualToString:@"0000"]) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        
        
        [_hud hide:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *err) {
        
        _hud.userInteractionEnabled = NO;
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
    
    }
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    [_hud hide:YES];
    
}

- (IBAction)nanAction:(UIButton *)sender {
    
    
    if (sender.selected) {
        
        return;
    }
    sender.selected = YES;
    _nvBtn.selected = NO;
    _sex = @"M";
    
}
- (IBAction)nvAction:(UIButton *)sender {
    
    if (sender.selected) {
        
        return;
    }
    sender.selected = YES;
    _nanBtn.selected = NO;
    _sex = @"F";
    
}



- (IBAction)defaultAction:(UIButton *)sender {
    
    if (sender.selected) {
        
        sender.selected = NO;
        _defaultAddress = 0;
    }else{
        
        sender.selected = YES;
        _defaultAddress = 1;
    }
    
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row == 3){
        
        AreaViewController *vc = [[AreaViewController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
    
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
