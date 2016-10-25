//
//  ScanStoreViewController.m
//  UserApp
//
//  Created by prefect on 16/5/26.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ScanStoreViewController.h"
#import "StoreViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "CouponViewCell.h"
#import "CouponModel.h"

@interface ScanStoreViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,strong)UITableView *tbView;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)UIButton *followBtn;

@property(nonatomic,copy)NSString *phoneString;

@property(nonatomic,copy)NSString *msgString;

@end

@implementation ScanStoreViewController

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"扫一扫领券";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createTableView];
    
    [self loadData];

}


-(void)loadData{
    
    _hud= [AppUtil createHUD];
    
    [AFHttpTool storeDetail:_store_id
                    cust_id:Cust_id
                  longitude:Longitude
                   latitude:Latitude
                   progress:^(NSProgress *progress) {
                       
                   } success:^(id response) {
                       
                       if (!([response[@"code"]integerValue]==0000)) {
                           
                           NSString *errorMessage = response [@"msg"];
                           _hud.mode = MBProgressHUDModeCustomView;
                           _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                           _hud.labelText =  errorMessage;
                           [_hud hide:YES afterDelay:2];
                           
                           return;
                       }
                       
                       [self createUI:response[@"data"]];
                       
                       [self loadCoupon];
                       
                   } failure:^(NSError *err) {
                       
                       _hud.mode = MBProgressHUDModeCustomView;
                       _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                       _hud.labelText = @"error";
                       _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                       [_hud hide:YES afterDelay:2];
                       
                   }];
    
    
}



-(void)loadCoupon{
    

    [AFHttpTool storeScan:_store_id
                  cust_id:Cust_id
                   progress:^(NSProgress *progress) {
                       
                   } success:^(id response) {

                       
                       if (!([response[@"code"]integerValue]==0000)) {
                           
                           NSString *errorMessage = response [@"msg"];
                           _hud.mode = MBProgressHUDModeCustomView;
                           _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                           _hud.labelText = errorMessage;
                           [_hud hide:YES afterDelay:2];
                           _msgString = errorMessage;
                           [self.tbView reloadData];
                           return;
                       }

                       NSArray * dicDataArray = response[@"data"];
                       for (NSDictionary * dic in dicDataArray) {
                           CouponModel * model = [[CouponModel alloc]init];
                           [model setValue:@"本店" forKey:@"use_store"];
                           [model setValuesForKeysWithDictionary:dic];
                           [self.dataArray addObject:model];
                       }

                       [_hud hide:YES];
                       [self.tbView reloadData];
                       
                   } failure:^(NSError *err) {
                       
                       _hud.mode = MBProgressHUDModeCustomView;
                       _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                       _hud.labelText = @"error";
                       _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                       [_hud hide:YES afterDelay:2];
                       
                   }];
    
    
}



-(void)createTableView{
    
    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 155, self.view.bounds.size.width, self.view.bounds.size.height-155-56) style:UITableViewStyleGrouped];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    _tbView.emptyDataSetSource = self;
    _tbView.emptyDataSetDelegate = self;
    [_tbView registerClass:[CouponViewCell class] forCellReuseIdentifier:@"CouponViewCell"];
    [self.view addSubview:_tbView];
    
}



-(void)createUI:(NSDictionary *)data{
    
    _phoneString = data[@"phone"];

    UIButton *comeBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, ScreenHeight - 46, ScreenWidth-40, 36)];
    [comeBtn setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    [comeBtn setTitle:@"进店逛逛" forState:UIControlStateNormal];
    comeBtn.layer.cornerRadius = 3;
    [comeBtn addTarget:self action:@selector(comeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comeBtn];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 74, ScreenWidth, 80)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];

    
    UIImageView *logoImage = [UIImageView new];
    [logoImage sd_setImageWithURL:[NSURL URLWithString:data[@"img"]] placeholderImage:[UIImage imageNamed:@"logo_place"]];
    [view addSubview:logoImage];
    
    
    _followBtn = [UIButton new];
    [_followBtn setSelected:[data[@"focus"] integerValue] == 0 ? NO:YES];
    [_followBtn setImage:[UIImage imageNamed:@"follow_off"] forState:UIControlStateNormal];
    [_followBtn setImage:[UIImage imageNamed:@"follow_on"] forState:UIControlStateSelected];
    [_followBtn addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_followBtn];
    
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = data[@"name"];
    nameLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:nameLabel];
    
    
    UIImageView *starGaryImage = [UIImageView new];
    starGaryImage.image = [UIImage imageNamed:@"star-gray"];
    [view addSubview:starGaryImage];
    
    UIImageView *starImage = [UIImageView new];
    starImage.image = [UIImage imageNamed:@"star"];
    starImage.contentMode = UIViewContentModeLeft;
    starImage.clipsToBounds = YES;
    [view addSubview:starImage];
    
    UILabel *gradeLabel = [UILabel new];
    gradeLabel.text = [NSString stringWithFormat:@"%@",data[@"score"]];
    gradeLabel.textColor = [UIColor orangeColor];
    gradeLabel.font = [UIFont systemFontOfSize:11.f];
    [view addSubview:gradeLabel];
    
    UILabel *addressLabel = [UILabel new];
    addressLabel.text = data[@"address"];
    addressLabel.textColor = [UIColor lightGrayColor];
    addressLabel.font = [UIFont systemFontOfSize:12.f];
    [view addSubview:addressLabel];
    
    
    UIView *oneView = [UIView new];
    oneView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:oneView];
    
    UILabel *typeLabel = [UILabel new];
    if ([data[@"deliver"] integerValue] == 0) {
        typeLabel.text = @"仅限自提";
    }else{
        typeLabel.text = [NSString stringWithFormat:@"¥%@起送",data[@"deliver_amount"]];
    }
    typeLabel.textColor = [UIColor orangeColor];
    typeLabel.font = [UIFont systemFontOfSize:13.f];
    [view addSubview:typeLabel];
    
    
    UIImageView *mapImage = [UIImageView new];
    mapImage.image = [UIImage imageNamed:@"map-gray"];
    [view addSubview:mapImage];
    
    
    UILabel *disLabel = [UILabel new];
    disLabel.text = data[@"distance"];
    disLabel.textColor = [UIColor lightGrayColor];
    disLabel.font = [UIFont systemFontOfSize:12.f];
    [view addSubview:disLabel];
    
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.equalTo(logoImage.mas_right).offset(5.f);
        make.height.mas_equalTo(14);
    }];
    
    

    
    [starGaryImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nameLabel.mas_bottom).offset(5.f);
        make.left.equalTo(logoImage.mas_right).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(51, 9));
        
    }];
    
    CGFloat score = [data[@"score"] floatValue];
    CGFloat w = 51*score/5.f;
    [starImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nameLabel.mas_bottom).offset(5.f);
        make.left.equalTo(logoImage.mas_right).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(w, 9));
        
    }];
    
    [gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(starGaryImage.mas_right).offset(2.f);
        make.top.equalTo(starGaryImage.mas_top);
        make.height.mas_equalTo(11);
    }];
    
    
    
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressLabel.mas_bottom).offset(5.f);
        make.left.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
    
    
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(starGaryImage.mas_bottom).offset(5.f);
        make.height.mas_equalTo(12);
        
    }];
    
    
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(addressLabel.mas_bottom).offset(5.f);
        make.left.equalTo(nameLabel.mas_left);
        make.right.mas_equalTo(10);
        make.height.mas_equalTo(0.5);
    }];
    
    
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(oneView.mas_bottom).offset(5.f);
        make.left.equalTo(nameLabel.mas_left);
        make.height.mas_equalTo(13);
        
    }];
    
    [disLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(oneView.mas_bottom).offset(5.f);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(12);
        
    }];
    
    
    [mapImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(oneView.mas_bottom).offset(5.f);
        make.right.equalTo(disLabel.mas_left).offset(-2.f);
        make.size.mas_equalTo(CGSizeMake(9, 12));
        
    }];
    


}



-(void)followAction:(UIButton *)btn{
    
    if (btn.selected) {
        
        _hud = [AppUtil createHUD];
        _hud.userInteractionEnabled = NO;
        [AFHttpTool customerFocusStoreDelete:Cust_id
                                    store_id:_store_id
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
                                        
                                        [btn setSelected:NO];

                                        
                                    } failure:^(NSError *err) {
                                        
                                        _hud.mode = MBProgressHUDModeCustomView;
                                        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                        _hud.labelText = @"Error";
                                        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                                        [_hud hide:YES afterDelay:3];
                                        
                                    }];
        
    }else{
        
        _hud = [AppUtil createHUD];
        [AFHttpTool customerFocusStoreAdd:SiteCode
                                  cust_id:Cust_id
                                 store_id:_store_id
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
                                     
                                    [btn setSelected:YES];

                                     
                                 } failure:^(NSError *err) {
                                     
                                     _hud.mode = MBProgressHUDModeCustomView;
                                     _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                     _hud.labelText = @"Error";
                                     _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                                     [_hud hide:YES afterDelay:3];
                                     
                                 }];
        
    }
    
}




-(void)comeAction{

    StoreViewController *vc = [[StoreViewController alloc]init];
    vc.store_id = _store_id;
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat h = (self.view.bounds.size.width-30) / 345 * 105;
    
    return h;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return self.dataArray.count > 0 ? @"已领该店优惠券":nil;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.dataArray.count > 0 ? 30 : 10;
    }
    
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CouponViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CouponModel * model = _dataArray[indexPath.section];
    [cell configModel:model];
    return cell;
}



#pragma mark - DZNEmptyDelegate

//返回的图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    if (_msgString){
        return [UIImage imageNamed:@"empty_prompt"];
    }
    return nil;
;
  
}


//标题提示
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    if (_msgString) {
        
        NSString *text = _msgString;
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                     NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                     NSParagraphStyleAttributeName: paragraph};
        
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
    
    return nil;

}



//是否允许下滑
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{

        return NO;
}



//视图之间的间距
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    
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
