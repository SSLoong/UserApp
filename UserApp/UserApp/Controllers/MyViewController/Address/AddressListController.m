//
//  AddressListController.m
//  UserApp
//
//  Created by prefect on 16/4/13.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "AddressListController.h"
#import "AddrSViewCell.h"
#import "AddressModel.h"
#import "AddAddressController.h"

@interface AddressListController ()

@property(nonatomic,copy)NSMutableArray * dataArray;

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation AddressListController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"收货地址";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAddress)];
    
    self.navigationItem.rightBarButtonItem = item;
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.tableView registerClass:[AddrSViewCell class] forCellReuseIdentifier:@"AddrSViewCell"];

    
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    if (_dataArray.count>0) {
        
        [_dataArray removeAllObjects];
    }
    
     [self loadData];
    
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];

    [_hud hide:YES];
}


-(void)addAddress{

    UIStoryboard *story = [UIStoryboard storyboardWithName:@"AddAddress" bundle:nil];
    
    AddAddressController *vc = [story instantiateViewControllerWithIdentifier:@"AddAddress"];

    [self.navigationController pushViewController:vc animated:YES];
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
    
}


-(void)loadData{
    
    
    _hud = [AppUtil createHUD];
    
    _hud.userInteractionEnabled = NO;
    
    [AFHttpTool addressList:Cust_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (![response[@"code"]isEqualToString:@"0000"]) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
    
        NSArray * dicArray = response[@"data"];
    
        if (_address) {
            
            for (NSDictionary * dic in dicArray) {
                
                if([SiteCode isEqualToString:dic[@"site_code"]]){
                    
                    AddressModel * model = [[AddressModel alloc]init];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    [_dataArray addObject:model];
                }
    
            }

        }else{
        
        
        for (NSDictionary * dic in dicArray) {
            
            AddressModel * model = [[AddressModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];

            [_dataArray addObject:model];
        }
            
        }
        
        
        [self.tableView reloadData];
        
        [_hud hide:YES];
        
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    static NSString * str = @"AddrSViewCell";
    
    AddrSViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    
    AddressModel * model = self.dataArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell configModel:model];
    
    
    if([model.is_default integerValue]>0){

        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"删除"
                                             backgroundColor:[UIColor redColor]                                                             callback:^BOOL(MGSwipeTableCell *sender) {
                                                 
                                                 _hud = [AppUtil createHUD];
                                                 
                                                 _hud.userInteractionEnabled = NO;
                                                 
                                                 [AFHttpTool addressDelete:Cust_id
                                                                   addr_id:model.addr_id
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
                                                     
                                                     [_hud hide:YES];
                                                     
                                                     [weakSelf.dataArray removeAllObjects];
                                                     
                                                     [weakSelf loadData];
                                                     
                                                 } failure:^(NSError *err) {
                                                     
                                                     _hud.mode = MBProgressHUDModeCustomView;
                                                     _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                                     _hud.labelText = @"Error";
                                                     _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                                                     [_hud hide:YES afterDelay:3];
                                                     
                                                 }];
                                                 
                                                 
                                                 return YES;
                                             }]];
        
    }else{

        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"删除" backgroundColor:     [UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
            
            _hud = [AppUtil createHUD];
            
            _hud.userInteractionEnabled = NO;
            
            [AFHttpTool addressDelete:Cust_id
                              addr_id:model.addr_id
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
                
                [_hud hide:YES];
                
                [weakSelf.dataArray removeAllObjects];
                
                [weakSelf loadData];
                
            } failure:^(NSError *err) {
                
                _hud.mode = MBProgressHUDModeCustomView;
                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                _hud.labelText = @"Error";
                _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                [_hud hide:YES afterDelay:3];
                
            }];
            
            
            return YES;
        }],[MGSwipeButton buttonWithTitle:@"默认" backgroundColor:[UIColor lightGrayColor]callback:^BOOL(MGSwipeTableCell *sender) {


            _hud = [AppUtil createHUD];
            
            _hud.userInteractionEnabled = NO;
            
            [AFHttpTool addressDefaultSet:Cust_id
                                  addr_id:model.addr_id
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
                
                [_hud hide:YES];
                
                [weakSelf.dataArray removeAllObjects];
                
                [weakSelf loadData];
                
                
            } failure:^(NSError *err) {
                
                _hud.mode = MBProgressHUDModeCustomView;
                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                _hud.labelText = @"Error";
                _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                [_hud hide:YES afterDelay:3];
                
            }];
            
            return YES;
        }]];
        
    }
    
    cell.rightSwipeSettings.transition = MGSwipeTransition3D;
    
    cell.modBtn.tag = indexPath.row;
    
    [cell.modBtn addTarget:self action:@selector(updateAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}



-(void)updateAddress:(UIButton *)btn{


    AddressModel * model = self.dataArray[btn.tag];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"AddAddress" bundle:nil];
    
    AddAddressController *vc = [story instantiateViewControllerWithIdentifier:@"AddAddress"];
    
    vc.type = @"updata";
    vc.addr_id = model.addr_id;
    vc.receiver = model.receiver;
    vc.sex = model.sex;
    vc.phone = model.phone;
    vc.province = model.province;
    vc.city = model.city;
    vc.area = model.area;
    vc.address = model.address;
    vc.site_code = model.site_code;
    vc.defaultAddress = [model.is_default integerValue];

    [self.navigationController pushViewController:vc animated:YES];
    
    


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressModel * model = self.dataArray[indexPath.row];
    
    NSString *name  = model.receiver;
    
    NSString *address = model.address;
    
    NSString *addr_id = model.addr_id;
    
    NSString *phone = [NSString stringWithFormat:@"%@",model.phone];
    
    if (_address) {
        
        if (self.didSelect) {
            self.didSelect(name,phone,address,addr_id);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }


}


@end
