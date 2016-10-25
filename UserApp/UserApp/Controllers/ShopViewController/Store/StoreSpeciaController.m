//
//  StoreSpeciaController.m
//  UserApp
//
//  Created by prefect on 16/5/6.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "StoreSpeciaController.h"
#import "SpecialCollectionViewCell.h"
#import "SpecialModel.h"
#import "HeaderReusableView.h"
#import "SpeciaDetailController.h"
#import "GoodsDetailViewController.h"

@interface StoreSpeciaController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSMutableArray *SpecialArray;//特卖的数据源

@property(nonatomic,strong)MBProgressHUD *hud;//提示

@end

@implementation StoreSpeciaController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _titleString;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *flowayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64, [AppUtil getScreenWidth], [AppUtil getScreenHeight]-64) collectionViewLayout:flowayout];
    _collectionView.dataSource=self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[SpecialCollectionViewCell class] forCellWithReuseIdentifier:@"SpecialCollectionViewCell"];
    
    [_collectionView registerClass:[HeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView"];
    
    [self loadSpecialData];
    
}


-(void)loadSpecialData{
    
    [AFHttpTool storeSpecialList:_store_id progress:^(NSProgress *progress) {
        
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
        
        NSArray *dataArray = response[@"data"][@"specials"];
        
        for (NSDictionary *dic in dataArray) {
            
            SpecialModel *model = [[SpecialModel alloc]init];
            
            [model mj_setKeyValues:dic];
            
            [self.SpecialArray addObject:model];
            
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


- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

        HeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView" forIndexPath:indexPath];
        headerView.titleLabel.text = @"今日特卖";
        headerView.moreImage.hidden = YES;
        headerView.moreBtn.hidden = YES;
        headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return headerView;
    
    
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
   return self.SpecialArray.count>0 ? CGSizeMake([AppUtil getScreenWidth], 44):CGSizeMake(0, 0);
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        
//        SpeciaDetailController *vc = [[SpeciaDetailController alloc]init];
//        
//        SpecialModel *model = _SpecialArray[indexPath.row];
//        
//        vc.special_id = model.special_id;
//        
//        vc.store_id = _store_id;
//        
//        [self.navigationController pushViewController:vc animated:YES];
    
    
    
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


@end
