//
//  SpeciaViewController.m
//  UserApp
//
//  Created by prefect on 16/4/22.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SpeciaViewController.h"
#import "SpecialCollectionViewCell.h"
#import "SpecialModel.h"
#import "SpeciaDetailController.h"
#import "LoginViewController.h"
#import "CodeLoginVC.h"

@interface SpeciaViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSMutableArray *SpecialArray;//特卖的数据源

@property(nonatomic,assign)BOOL isLoading;//是否在加载中

@property(nonatomic,assign)NSInteger page;//页数

@property(nonatomic,strong)MBProgressHUD *hud;//提示


@end

@implementation SpeciaViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"附近特卖";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *flowayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64, [AppUtil getScreenWidth], [AppUtil getScreenHeight]-64) collectionViewLayout:flowayout];
    _collectionView.dataSource=self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[SpecialCollectionViewCell class] forCellWithReuseIdentifier:@"SpecialCollectionViewCell"];
    
    
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
    
    [self loadSpecialData];
    
}


-(void)loadMoreData{
    
    
    if (_isLoading) {
        
        return;
    }
    
    _isLoading = YES;
    
    _page++;
    
    [self loadSpecialData];
}




-(void)loadSpecialData{
    

    
    
    
    [AFHttpTool nearbySpecial:SiteCode longitude:Longitude latitude:Latitude page:_page rows:10 progress:^(NSProgress *progress) {
        
    } success:^(id response) {

        
        if (!([response[@"code"]integerValue]==0000)) {
            _hud = [AppUtil createHUD];
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        
        if(_page ==1 && self.SpecialArray.count>0){
            
            [self.SpecialArray removeAllObjects];
        }
        
        
        NSArray *dataArray = response[@"data"][@"specials"];
        
        for (NSDictionary *dic in dataArray) {
            
            SpecialModel *model = [[SpecialModel alloc]init];
            
            [model mj_setKeyValues:dic];
            
            [self.SpecialArray addObject:model];
            
            
        }
        
        _isLoading = NO;
        
        if (self.SpecialArray.count > 0) {
            
            if (_collectionView.mj_footer.hidden) {
                _collectionView.mj_footer.hidden = NO;
            }
        }else{
            if (!_collectionView.mj_footer.hidden) {
                _collectionView.mj_footer.hidden = YES;
            }
        }
        
        if (dataArray.count!=10) {
            
            [_collectionView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            [_collectionView.mj_footer endRefreshing];
        }
        
        if (_collectionView.mj_header.isRefreshing) {
            
            [_collectionView.mj_header endRefreshing];
        }
        
        [_collectionView reloadData];
        
        
    } failure:^(NSError *err) {

        _hud = [AppUtil createHUD];
        _hud.userInteractionEnabled = NO;
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];

            _isLoading = NO;
        
        if (_collectionView.mj_footer.isRefreshing) {
            
            [_collectionView.mj_footer endRefreshing];
            
        }
        if (_collectionView.mj_header.isRefreshing) {
            
            [_collectionView.mj_header endRefreshing];
        }
        
    }];
    
    
}




#pragma mark - CollectionViewDelegete

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        
    SpecialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpecialCollectionViewCell" forIndexPath:indexPath];
        
    SpecialModel *model = _SpecialArray[indexPath.row];
        
    cell.model = model;
        
    cell.backgroundColor = [UIColor whiteColor];
        
    return cell;
        
 }


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
        
    return _SpecialArray.count;

}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

        
        CGFloat w = ([AppUtil getScreenWidth]-30)/2;
        
        return CGSizeMake(w,w+10+30+5+12+5+12);

    
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(IsLogin){
            
            SpeciaDetailController *vc = [[SpeciaDetailController alloc]init];
            
            SpecialModel *model = _SpecialArray[indexPath.row];
        
            vc.special_id = model.special_id;
        
            vc.store_id = model.store_id;
            
            [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        CodeLoginVC *vc = [[CodeLoginVC alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
}






-(NSMutableArray *)SpecialArray{
    
    if(_SpecialArray == nil){
        
        _SpecialArray = [NSMutableArray array];
        
    }
    return _SpecialArray;
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
