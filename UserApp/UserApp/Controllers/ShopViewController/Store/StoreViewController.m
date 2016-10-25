//
//  StoreViewController.m
//  UserApp
//
//  Created by prefect on 16/4/25.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "StoreViewController.h"
#import "StoreHeaderViewCell.h"
#import "StoreModel.h"
#import "HeaderReusableView.h"
#import "SpecialCollectionViewCell.h"
#import "SpecialModel.h"
#import "RecommendViewCell.h"
#import "GoodsModel.h"
#import "StoreHotViewCell.h"
#import "CartViewController.h"
#import "GoodsDetailViewController.h"
#import "StoreSpeciaController.h"
#import "SpeciaDetailController.h"
#import "ManagerViewController.h"

#import "SaoYiSaoViewController.h"
#import "CouponViewController.h"
#import "StoreCartViewController.h"

static NSString * const KStoreHeaderViewCell = @"StoreHeaderViewCell";
static NSString * const kSpecialCollectionViewCell = @"SpecialCollectionViewCell";
static NSString * const kRecommendViewCell = @"RecommendViewCell";
static NSString * const kStoreHotViewCell = @"StoreHotViewCell";

@interface StoreViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)HeaderReusableView *headeView;

@property(nonatomic,strong)NSMutableArray *dataArray;//门店信息数据源

@property(nonatomic,strong)NSMutableArray *SpecialArray;//特卖的数据源

@property(nonatomic,strong)NSMutableArray *recommendArray;//推荐的数据源

@property(nonatomic,strong)NSMutableArray *hotArray;//推荐的数据源

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isLoading;//是否在加载中


@end

@implementation StoreViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"加载中...";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self createCollectionView];
    
    [self createTabBar];

}


-(void)createTabBar{

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-44, self.view.bounds.size.width, 44)];
    view.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
    [self.view addSubview:view];
    
    CGFloat w = self.view.bounds.size.width;
    UIImageView *storeImage = [[UIImageView alloc]initWithFrame:CGRectMake((w/3)/2-22, 0, 44, 44)];
    storeImage.image = [UIImage imageNamed:@"store_store"];
    [view addSubview:storeImage];
    
    UIButton *cartBtn = [[UIButton alloc]initWithFrame:CGRectMake(w/2-22, 0, 44, 44)];
    [cartBtn setImage:[UIImage imageNamed:@"store_cart"] forState:UIControlStateNormal];
    [cartBtn addTarget:self action:@selector(cartAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cartBtn];
    
    UIButton *orderBtn = [[UIButton alloc]initWithFrame:CGRectMake(w/3*2+w/3/2-22, 0, 44, 44)];
    [orderBtn setImage:[UIImage imageNamed:@"store_order"] forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(orderAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:orderBtn];
    
}




-(void)createCollectionView{

    UICollectionViewFlowLayout *flowayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64, [AppUtil getScreenWidth], [AppUtil getScreenHeight]-108) collectionViewLayout:flowayout];
    _collectionView.dataSource=self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[StoreHeaderViewCell class] forCellWithReuseIdentifier:KStoreHeaderViewCell];
    [_collectionView registerClass:[SpecialCollectionViewCell class] forCellWithReuseIdentifier:kSpecialCollectionViewCell];
    [_collectionView registerClass:[RecommendViewCell class] forCellWithReuseIdentifier:kRecommendViewCell];
    [_collectionView registerClass:[StoreHotViewCell class] forCellWithReuseIdentifier:kStoreHotViewCell];
    
    
    [_collectionView registerClass:[HeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"emptyHeaderView"];
    
    
    
    _collectionView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    
    [_collectionView.mj_header beginRefreshing];
    
    
    _collectionView.mj_footer = ({
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.refreshingTitleHidden = YES;
        footer.hidden = YES;
        footer;
    });


}





-(void)refresh{
    
    if (_isLoading) {
        
        return;
    }
    
    _isLoading = YES;
    
    _page = 1;
    
    [self loadStoreData];
    
    [self loadSpecialData];
    
    [self loadRecommendData];
    
    [self loadHotData];
    
}


-(void)loadMoreData{
    
    if (_isLoading) {
        
        return;
    }
    
    _isLoading = YES;
    
    _page++;
    
    [self loadHotData];
    
}


-(void)loadStoreData{
    
    [AFHttpTool storeDetail:_store_id
                    cust_id:Cust_id
                  longitude:Longitude
                   latitude:Latitude
                   progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        

        if(_page ==1 && self.dataArray.count>0){
            
            [self.dataArray removeAllObjects];
        }
        
        NSDictionary *dic = response[@"data"];
        self.title = response[@"data"][@"name"];
        StoreModel *model = [[StoreModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.dataArray addObject: model];
        [self.collectionView reloadData];
        
    } failure:^(NSError *err) {
        
        self.title = @"加载失败";

        [self loadFail:err];
    
    }];

}

-(void)loadSpecialData{

    [AFHttpTool storeSpecialList:_store_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if(_page ==1 && self.SpecialArray.count>0){
            
            [self.SpecialArray removeAllObjects];
        }


        NSArray *dataArray = response[@"data"][@"specials"];
        
        for (NSDictionary *dic in dataArray) {
            
            SpecialModel *model = [[SpecialModel alloc]init];
            
            [model mj_setKeyValues:dic];
            
            [self.SpecialArray addObject:model];
            
        }
        [_collectionView reloadData];
        
    } failure:^(NSError *err) {
        
        [self loadFail:err];
    }];

}



-(void)loadRecommendData{

    [AFHttpTool storeRecommend:_store_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if(_page ==1 && self.recommendArray.count>0){
            
            [self.recommendArray removeAllObjects];
        }
        
        for (NSDictionary *dic in response[@"data"]) {
            
            GoodsModel *model = [[GoodsModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [self.recommendArray addObject:model];
            
        }
        
        [_collectionView reloadData];
    
        
    } failure:^(NSError *err) {

        [self loadFail:err];

}];

}



-(void)loadHotData{

    [AFHttpTool goodsList:_store_id
                     page:_page
                 progress:^(NSProgress *progress) {
        
    } success:^(id response) {

        
        if(_page ==1 && self.hotArray.count>0){
            
            [self.hotArray removeAllObjects];
        }
        
        NSArray *dataArray = response[@"data"];

        for (NSDictionary *dic in dataArray) {
            
            GoodsModel *model = [[GoodsModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [self.hotArray addObject:model];
            
        }

        _isLoading = NO;
            
        if (_collectionView.mj_footer.hidden) {
            _collectionView.mj_footer.hidden = NO;
        }

        if (dataArray.count !=10 ) {
            
            [_collectionView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            [_collectionView.mj_footer endRefreshing];
        }
        
        if (_collectionView.mj_header.isRefreshing) {
            
            [_collectionView.mj_header endRefreshing];
        }

        
        [_collectionView reloadData];
        
        
    } failure:^(NSError *err) {
        
        [self loadFail:err];
        
    }];

}


-(void)loadFail:(NSError *)err{

    _hud = [AppUtil createHUD];
    _hud.userInteractionEnabled = NO;
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
    _hud.labelText = @"Error";
    _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
    [_hud hide:YES afterDelay:3];
    
    if (_isLoading) {
        _isLoading = NO;
    }
    if (_collectionView.mj_footer.isRefreshing) {
        [_collectionView.mj_footer endRefreshing];
    }
    if (_collectionView.mj_header.isRefreshing) {
        [_collectionView.mj_header endRefreshing];
    }

}



#pragma mark - CollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
    

        StoreHeaderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KStoreHeaderViewCell forIndexPath:indexPath];
   
        StoreModel *model = _dataArray[indexPath.row];
    
        [cell configModel:model];
    
        [cell.followBtn addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
    
        cell.followBtn.tag = [model.focus integerValue];
        
        [cell.oneBtn addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.twoBtn addTarget:self action:@selector(soAction) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.threeBtn addTarget:self action:@selector(couponAction) forControlEvents:UIControlEventTouchUpInside];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
        
    }else if(indexPath.section == 1){
        
        SpecialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSpecialCollectionViewCell forIndexPath:indexPath];
        
        
        SpecialModel *model = _SpecialArray[indexPath.row];
        
        cell.model = model;
        
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;

    }else if(indexPath.section == 2){

        RecommendViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendViewCell forIndexPath:indexPath];
        
        [cell configData:_recommendArray];
    
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.pushGoods = ^(NSString *sg_id){
            
            GoodsDetailViewController *vc= [[GoodsDetailViewController alloc]init];
            
            vc.sg_id = sg_id;
            
            vc.store_id = _store_id;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        };

        
        return cell;

    }else{
    
        StoreHotViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStoreHotViewCell forIndexPath:indexPath];
        
        
        GoodsModel *model = _hotArray[indexPath.row];
        
        [cell configModel:model];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.plus.hidden = YES;
        
        return cell;
    
    }

    return nil;

}




-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 4;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return _dataArray.count;
            break;
        case 1:
            return _SpecialArray.count>=2 ? 2 : _SpecialArray.count;
            break;
        case 2:
            return _recommendArray.count>0 ? 1 : 0;
            break;
        case 3:
            return _hotArray.count;
            break;
        default:
            return 0;
            break;
    }
    
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    
    switch (section) {
        case 0:
            return self.dataArray.count>0 ? UIEdgeInsetsMake(10, 10, 10, 10) : UIEdgeInsetsZero;
            break;
        case 1:
            return self.SpecialArray.count>0 ? UIEdgeInsetsMake(10, 10, 5, 10) : UIEdgeInsetsZero;
            break;
        case 2:
            return self.recommendArray.count>0 ? UIEdgeInsetsMake(10, 10, 10, 10) : UIEdgeInsetsZero;
            break;
        case 3:
            return self.hotArray.count>0 ? UIEdgeInsetsMake(10, 10, 10, 10) : UIEdgeInsetsZero;
            break;
        default:
            return UIEdgeInsetsZero;
            break;
    }

    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        return CGSizeMake(ScreenWidth-20,120);
        
    }else if(indexPath.section == 1){
        
        CGFloat w = (ScreenWidth-30)/2;
        
        return CGSizeMake(w,w+63);
        
    }else if(indexPath.section == 2){

        CGFloat w = ScreenWidth-20;
        CGFloat h = (ScreenWidth-30)/2+40;
        return CGSizeMake(w,h);
    }else{
    
        CGFloat w = (ScreenWidth-30)/2;
        
        return CGSizeMake(w,w+64);
    
    }
}



- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        UICollectionReusableView *emptyHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"emptyHeaderView" forIndexPath:indexPath];
        emptyHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        return nil;
        
    }else if(indexPath.section == 1) {
        
        HeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView" forIndexPath:indexPath];
        headerView.titleLabel.text = @"今日特卖";
        headerView.moreImage.hidden = NO;
        headerView.moreBtn.hidden = NO;
        headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [headerView.moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        return headerView;
        
    }else if(indexPath.section == 2){
        
        
        HeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView" forIndexPath:indexPath];
        headerView.titleLabel.text = @"店长推荐";
        headerView.moreImage.hidden = YES;
        headerView.moreBtn.hidden = YES;
        headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return headerView;
        
    }else{
    
        HeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView" forIndexPath:indexPath];
        headerView.titleLabel.text = @"本店热销";
        headerView.moreImage.hidden = YES;
        headerView.moreBtn.hidden = YES;
        headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return headerView;
    
    }
    
}




-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return CGSizeZero;
            break;
        case 1:
            return self.SpecialArray.count>0 ? CGSizeMake([AppUtil getScreenWidth], 44):CGSizeZero;
            break;
        case 2:
            return self.recommendArray.count>0 ? CGSizeMake([AppUtil getScreenWidth], 44):CGSizeZero;
            break;
        case 3:
            return self.hotArray.count>0 ? CGSizeMake([AppUtil getScreenWidth], 44):CGSizeZero;
            break;
        default:
            return CGSizeZero;
            break;
    }
    
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section == 1){
    
        SpecialModel *model = _SpecialArray[indexPath.row];
        
        if([model.type integerValue] ==1){

            GoodsDetailViewController *vc= [[GoodsDetailViewController alloc]init];
            
            vc.store_id = _store_id;
            
            vc.sg_id = [NSString stringWithFormat:@"%@",model.goods[@"sg_id"]];
            
            [self.navigationController pushViewController:vc animated:YES];

        
        }else{
        
            SpeciaDetailController *vc = [[SpeciaDetailController alloc]init];
            
            vc.special_id = model.special_id;
            
            vc.store_id = _store_id;
            
            [self.navigationController pushViewController:vc animated:YES];
        
        }

    
    }else if (indexPath.section == 3) {
        
        
        GoodsDetailViewController *vc= [[GoodsDetailViewController alloc]init];
        
        GoodsModel *model = _hotArray[indexPath.row];

        vc.store_id = _store_id;

        vc.sg_id = [NSString stringWithFormat:@"%@",model.sg_id];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}






-(void)followAction:(UIButton *)btn{
    
    
    StoreModel *model = [_dataArray lastObject];
    
    if ([model.focus integerValue]== 1) {
        
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
                                        model.focus = @"0";
                                        model.fans_num = [NSString stringWithFormat:@"%zd",[model.fans_num integerValue]-1];
                                        [_collectionView reloadData];
                                        
                                    } failure:^(NSError *err) {
                                        
                                        _hud.mode = MBProgressHUDModeCustomView;
                                        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                        _hud.labelText = @"Error";
                                        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                                        [_hud hide:YES afterDelay:3];
                                        
                                    }];
        
    }else{
        
        _hud = [AppUtil createHUD];
        _hud.userInteractionEnabled = NO;
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
                                     model.focus = @"1";
                                     model.fans_num = [NSString stringWithFormat:@"%zd",[model.fans_num integerValue]+1];
                                     [_collectionView reloadData];
                                     
                                 } failure:^(NSError *err) {
                                     
                                     _hud.mode = MBProgressHUDModeCustomView;
                                     _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                     _hud.labelText = @"Error";
                                     _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                                     [_hud hide:YES afterDelay:3];
                                     
                                 }];
        
    }
    
}

#pragma mark - 懒加载数据源

-(NSMutableArray *)hotArray{
    if (_hotArray == nil) {
        
        _hotArray = [NSMutableArray array];
    }
    
    return _hotArray;
}

-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

-(NSMutableArray *)recommendArray{
    
    if(_recommendArray == nil){
        
        _recommendArray = [NSMutableArray array];
        
    }
    return _recommendArray;
}

-(NSMutableArray *)SpecialArray{
    
    if(_SpecialArray == nil){
        
        _SpecialArray = [NSMutableArray array];
        
    }
    return _SpecialArray;
}


#pragma mark - Action

-(void)cartAction{
    
    CartViewController *vc = [[CartViewController alloc]init];
    
    vc.store_id = _store_id;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}



-(void)orderAction{

    ManagerViewController *vc = [ManagerViewController new];
    
    vc.titleString = self.title;
    
    vc.store_id = _store_id;
    
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)scanAction{
    
    SaoYiSaoViewController *sao = [[SaoYiSaoViewController alloc] init];
    
    [self.navigationController pushViewController:sao animated:YES];
    
}

-(void)soAction{
    
    StoreCartViewController *vc= [[StoreCartViewController alloc]init];
    
    vc.store_id = _store_id;
    
    StoreModel *model = [_dataArray lastObject];
    
    vc.isDelivery = [model.deliver integerValue] > 0 ? YES : NO;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)couponAction{
        
    CouponViewController *vc= [[CouponViewController alloc]init];
        
    vc.store_id = _store_id;
        
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)moreAction{
    
    StoreSpeciaController *vc= [[StoreSpeciaController alloc]init];
    
    vc.store_id = _store_id;
    
    vc.titleString = self.title;
    
    [self.navigationController pushViewController:vc animated:YES];
    
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
