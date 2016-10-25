//
//  OrderTableController.m
//  UserApp
//
//  Created by prefect on 16/4/12.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OrderTableController.h"
#import "OrderViewCell.h"
#import "OrderModel.h"
#import "OrderDetailViewController.h"
#import "UMSocial.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"

#import "ALActionSheetView.h"

@interface OrderTableController ()

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,assign)BOOL isLoading;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation OrderTableController

-(id)initWithStyle:(UITableViewStyle)style{

    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        
        [self.tableView registerClass:[OrderViewCell class] forCellReuseIdentifier:@"OrderViewCell"];
        
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _isLoading = YES;
    
    self.tableView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    
    
    self.tableView.mj_footer = ({
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.refreshingTitleHidden = YES;
        footer.hidden = YES;
        footer;
    });
    
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(weixinNotice:) name:@"weixinNotice" object:nil];
    
}


-(void)weixinNotice:(NSNotification *)not{

    if([not.userInfo[@"payResoult"] isEqualToString:@"支付成功"]){
    
        _hud = [AppUtil createHUD];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
        _hud.labelText = @"支付成功";
        [_hud hide:YES afterDelay:2];
        [self.tableView.mj_header beginRefreshing];
        
    }else{
    
        _hud = [AppUtil createHUD];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = not.userInfo[@"payResoult"];
        [_hud hide:YES afterDelay:2];
    
    }
    
}




-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_isLoading) {
        
        [self.tableView.mj_header beginRefreshing];
        
        _isLoading = NO;
    }
}


-(void)refresh{
    
    if (_isLoading) {
        
        return;
    }
    
    _isLoading = YES;
    
    _page = 1;
    
    [self loadData];
    
}


-(void)loadMoreData{
    
    
    if (_isLoading) {
        
        return;
    }
    
    _isLoading = YES;
    
    _page++;
    
    [self loadData];
}





#pragma mark - Table view data source



-(void)loadData{
    
    [AFHttpTool orderQueryList:Cust_id
                        status:_status
                    pay_result:_pay_result
                          page:_page
                  progress:^(NSProgress *progress) {
                      
                  } success:^(id response) {

                      
                      if(_page ==1 && self.dataArray.count>0){
                          
                          [self.dataArray removeAllObjects];
                      }
                      
                      for (NSDictionary * dic in response[@"data"][@"dataList"]) {
                          OrderModel * model = [[OrderModel alloc]init];
                          [model setValuesForKeysWithDictionary:dic];
                          [self.dataArray addObject:model];
                      }
                      
                      
                      if (self.tableView.mj_footer.hidden) {
                          self.tableView.mj_footer.hidden = NO;
                      }
                      
                      _isLoading = NO;
                      
                      if(_page == [response[@"data"][@"totalPage"] integerValue] || [response[@"data"][@"totalPage"] integerValue] == 0){
                          
                          [self.tableView.mj_footer endRefreshingWithNoMoreData];
                          
                      }else{
                          
                          [self.tableView.mj_footer endRefreshing];
                          
                      }
                      
                      
                      if (self.tableView.mj_header.isRefreshing) {
                          
                          [self.tableView.mj_header endRefreshing];
                      }
                      
                      [self.tableView reloadData];
                      
                  } failure:^(NSError *err) {
                      
                      _hud = [AppUtil createHUD];
                      _hud.mode = MBProgressHUDModeCustomView;
                      _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                      _hud.labelText = @"Error";
                      _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                      [_hud hide:YES afterDelay:3];
                      
                      _isLoading = NO;
                      
                      if (self.tableView.mj_footer.isRefreshing) {
                          
                          [self.tableView.mj_footer endRefreshing];
                          
                      }
                      if (self.tableView.mj_header.isRefreshing) {
                          
                          [self.tableView.mj_header endRefreshing];
                      }
                      
                  }];
}


#pragma mark - TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"OrderViewCell";
    
    OrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    [cell.oneBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.oneBtn.tag = indexPath.section;
    
    [cell.twoBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.twoBtn.tag = indexPath.section;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    OrderModel *model = self.dataArray[indexPath.section];
    
    [cell configModel:model];
    
    return cell;
    
}

-(void)btnAction:(UIButton *)btn{

    OrderModel *model = self.dataArray[btn.tag];
    
    NSString *titleString = btn.titleLabel.text;
    
    if([titleString isEqualToString:@"确认收货"]){
    
        _hud = [AppUtil createHUD];
        
        [AFHttpTool orderConfirm:model.order_id
         
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
                                        
                                        model.status = @"1";
                                        
                                        [self.tableView reloadData];
                                        
                                        
                                    } failure:^(NSError *err) {
                                        
                                        _hud.mode = MBProgressHUDModeCustomView;
                                        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                        _hud.labelText = @"Error";
                                        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                                        [_hud hide:YES afterDelay:3];
                                        
                                    }];
 
    
    }else if ([titleString isEqualToString:@"分享拿券"]) {
        
        _hud = [AppUtil createHUD];
        
        [AFHttpTool orderShare:model.order_id
         
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
                            
                            NSString *title = response[@"data"][@"title"];
                            
                            NSString *connt = response[@"data"][@"connt"];
                            
                            NSString *img = response[@"data"][@"img"];
                            
                            NSString *url = [NSString stringWithFormat:@"%@%@",response[@"data"][@"url"],model.order_id];

                            [self downloadImage:title connt:connt img:img url:url];
                            
                        } failure:^(NSError *err) {
                            
                            _hud.mode = MBProgressHUDModeCustomView;
                            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                            _hud.labelText = @"Error";
                            _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                            [_hud hide:YES afterDelay:3];
                            
                        }];
        
    }else{
        
        
        ALActionSheetView *actionSheetView = [ALActionSheetView showActionSheetWithTitle:@"支付方式" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"微信", @"支付宝"] handler:^(ALActionSheetView *actionSheetView, NSInteger buttonIndex)
        
                {

                   
                    if (buttonIndex == 0) {
                        
                        [self orderRepay:model.order_id Paychanel:@"weixin"];

                    }else if (buttonIndex == 1){
                    
                        [self orderRepay:model.order_id Paychanel:@"alipay"];
                        
                    }else{
                    
                        return ;
                    }

        }];
        [actionSheetView show];
        
        
        


        
    }
}


-(void)orderRepay:(NSString *)order_id Paychanel:(NSString *)payChanel{


    _hud = [AppUtil createHUD];
    
    [AFHttpTool orderRepay:order_id
     
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
                      
                      NSString *order_id = response[@"data"][@"order_id"];
                      
                      [self orderChangePaychanel:order_id Paychanel:payChanel];
                      
                      
                  } failure:^(NSError *err) {
                      
                      _hud.mode = MBProgressHUDModeCustomView;
                      _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                      _hud.labelText = @"Error";
                      _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                      [_hud hide:YES afterDelay:3];
                      
                  }];

}


-(void)orderChangePaychanel:(NSString *)order_id Paychanel:(NSString *)payChanel{

    
    [AFHttpTool orderChangePaychanel:payChanel order_id:order_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:2];
            
            return;
        }
        
        [_hud hide:YES];
        
        if([payChanel isEqualToString:@"alipay"]){
        
            [self orderAlipay:order_id];
        
        }else{
        
            [self orderWeixin:order_id];
        
        }
        
        


        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:2];
        
    }];

    
}



-(void)orderWeixin:(NSString *)order_id{
    
    [AFHttpTool orderSignWeixin:order_id
                     devices_id:[AppUtil UUIDString]
                       progress:^(NSProgress *progress) {
                           
                       } success:^(id response) {
                           
                           if (!([response[@"code"]integerValue]==0000)) {
                               NSString *errorMessage = response [@"msg"];
                               _hud.mode = MBProgressHUDModeCustomView;
                               _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                               _hud.detailsLabelText = errorMessage;
                               [_hud hide:YES afterDelay:2];
                               return;
                           }
                           
                           PayReq *request = [[PayReq alloc] init];
                           request.partnerId = response[@"data"][@"partnerId"];
                           request.prepayId= response[@"data"][@"prepayId"];
                           request.package = response[@"data"][@"package"];
                           request.nonceStr= response[@"data"][@"nonceStr"];
                           request.timeStamp= [response[@"data"][@"timeStamp"] intValue];
                           request.sign= response[@"data"][@"sign"];
                           
                           [WXApi sendReq:request];
                           
                           [_hud hide:YES];
                           
                       } failure:^(NSError *err) {
                           
                           _hud.userInteractionEnabled = NO;
                           _hud.mode = MBProgressHUDModeCustomView;
                           _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                           _hud.labelText = @"Error";
                           _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                           [_hud hide:YES afterDelay:2];
                           
                       }];
    
}





-(void)orderAlipay:(NSString *)order_id{
    
    [AFHttpTool orderSignAlipay:order_id
                       progress:^(NSProgress *progress) {
                           
                       } success:^(id response) {
                           
                           if (!([response[@"code"]integerValue]==0000)) {
                               NSString *errorMessage = response [@"msg"];
                               _hud.mode = MBProgressHUDModeCustomView;
                               _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                               _hud.labelText = errorMessage;
                               [_hud hide:YES afterDelay:2];
                               return;
                           }
                           
                           [_hud hide:YES];
                           
                           NSString *orderString = response[@"data"][@"sign"];
                           
                           NSString *appScheme = @"sjkuser";
                           
                           [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                               
                               
                               NSInteger code = [resultDic[@"resultStatus"] integerValue];
                               
                               if (code == 9000) {
                                   _hud = [AppUtil createHUD];
                                   _hud.mode = MBProgressHUDModeCustomView;
                                   _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                                   _hud.labelText = @"支付成功";
                                   [_hud hide:YES afterDelay:2];
                                   [self.tableView.mj_header beginRefreshing];
                                   
                                   
                               }else{
                                   _hud = [AppUtil createHUD];
                                   _hud.mode = MBProgressHUDModeCustomView;
                                   _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                   _hud.labelText = resultDic[@"memo"];
                                   [_hud hide:YES afterDelay:2];
                               }
                               
                               
                           }];
                           
                           
                       } failure:^(NSError *err) {
                           
                           _hud.userInteractionEnabled = NO;
                           _hud.mode = MBProgressHUDModeCustomView;
                           _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                           _hud.labelText = @"Error";
                           _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                           [_hud hide:YES afterDelay:2];
                           
                       }];
}




-(void)downloadImage:(NSString *)title connt:(NSString *)connt img:(NSString *)img url:(NSString *)url{
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:img]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            
                            
                            if (finished) {
                                
                                if (image) {
                                    
                                    [self shareAction:title connt:connt img:image url:url];
                                    [_hud hide:YES];
                                    
                                }else{
                                    [self shareAction:title connt:connt img:[UIImage imageNamed:@"icon"] url:url];
                                    [_hud hide:YES];
                                    
                                }
                                
                            }
                            
                            
                            
                        }];
    
}




-(void)shareAction:(NSString *)title connt:(NSString *)connt img:(UIImage *)img url:(NSString *)url {
    
    
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppKey
                                      shareText:connt
                                     shareImage:img
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:nil];
    
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
        [UMSocialData defaultData].extConfig.qqData.url = url;
        [UMSocialData defaultData].extConfig.qzoneData.url = url;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
        [UMSocialData defaultData].extConfig.qqData.title = title;
        [UMSocialData defaultData].extConfig.qzoneData.title = title;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 193;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 5;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        OrderDetailViewController *vc = [[OrderDetailViewController alloc]init];
    
        OrderModel *model = self.dataArray[indexPath.section];
    
        vc.order_id = model.order_id;
    
        [self.navigationController pushViewController:vc animated:YES];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
