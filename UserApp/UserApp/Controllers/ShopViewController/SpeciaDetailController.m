//
//  SpeciaDetailController.m
//  UserApp
//
//  Created by prefect on 16/5/6.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SpeciaDetailController.h"

#import "HeaderReusableView.h"
#import "SpeciaInfoViewCell.h"
#import "SpecialnfoModel.h"
#import "StoreHotViewCell.h"
#import "GoodsModel.h"
#import "WZLBadgeImport.h"
#import "CartViewController.h"
#import "GoodsDetailViewController.h"

@interface SpeciaDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)MBProgressHUD *hud;//提示

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)HeaderReusableView *headeView;

@property(nonatomic,strong)NSMutableArray *infoArray;//专场信息数据源

@property(nonatomic,strong)NSMutableArray *dataArray;//专场数据源

@property(nonatomic,assign)NSInteger num;

@property(nonatomic,strong)UIButton *cartBtn;

@end

@implementation SpeciaDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"专场特卖";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _num = 0;
    
    [self createCollectionView];
    
    [self loadInfoData];
    
    [self loadData];
}


-(void)createCollectionView{
    
    UICollectionViewFlowLayout *flowayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64, [AppUtil getScreenWidth], [AppUtil getScreenHeight]-108) collectionViewLayout:flowayout];
    _collectionView.dataSource=self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[SpeciaInfoViewCell class] forCellWithReuseIdentifier:@"SpeciaInfoViewCell"];
    [_collectionView registerClass:[StoreHotViewCell class] forCellWithReuseIdentifier:@"StoreHotViewCell"];
    

    [_collectionView registerClass:[HeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"emptyHeaderView"];

}



-(void)cartView{
    
    UIView *cartView = [[UIView alloc]initWithFrame:CGRectMake(0, [AppUtil getScreenHeight]-44, [AppUtil getScreenHeight], 44)];
    cartView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:cartView];
    
    //购物车
    _cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cartBtn setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    _cartBtn.frame = CGRectMake(self.view.bounds.size.width-60, 2, 40,40);
    [_cartBtn addTarget:self action:@selector(cartAction) forControlEvents:UIControlEventTouchUpInside];
    [cartView addSubview:_cartBtn];
    
}



-(void)loadInfoData{
    
    [AFHttpTool specialDetail:_special_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        NSDictionary *dic = response[@"data"];
        SpecialnfoModel *model = [[SpecialnfoModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.infoArray addObject: model];
        [self.collectionView reloadData];
        
    } failure:^(NSError *err) {
        
        _hud = [AppUtil createHUD];
        _hud.userInteractionEnabled = NO;
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:2];
        
    }];
    
}



-(void)loadData{


    [AFHttpTool specialGoods:_special_id
                    store_id:_store_id
                    progress:^(NSProgress *progress) {
        
    } success:^(id response) {

        
        
        NSLog(@"%@",response);
        
        for (NSDictionary *dic in response[@"data"]) {
            
            GoodsModel *model = [[GoodsModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            model.sub_amount = model.special_subamount;
            
            [self.dataArray addObject:model];
            
        }
        
        [self cartView];
        
        [_collectionView reloadData];
        
    } failure:^(NSError *err) {
        
        _hud = [AppUtil createHUD];
        _hud.userInteractionEnabled = NO;
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:2];
        
    }];


}


#pragma mark - CollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        SpeciaInfoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpeciaInfoViewCell" forIndexPath:indexPath];
        
        SpecialnfoModel *model = _infoArray[indexPath.row];
        
        [cell configModel:model];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
        
    }else if (indexPath.section == 1){
    
        StoreHotViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreHotViewCell" forIndexPath:indexPath];
        
        GoodsModel *model = _dataArray[indexPath.row];
        
        [cell configModel:model];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        
        cell.addBlock = ^()
        {
            
            _hud = [AppUtil createHUD];
            [AFHttpTool addCart:Cust_id store_id:_store_id special_id:_special_id sg_id:model.sg_id buy_num:@"+1"  progress:^(NSProgress *progress) {
                
            } success:^(id response) {
                
                if (!([response[@"code"]integerValue]==0000)) {
                    NSString *errorMessage = response [@"msg"];
                    _hud.mode = MBProgressHUDModeCustomView;
                    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                    _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                    [_hud hide:YES afterDelay:2];
                    return;
                }
                
                _num++;
                
                [_cartBtn showBadgeWithStyle:WBadgeStyleNumber value:_num animationType:WBadgeAnimTypeNone];
                _cartBtn.badgeCenterOffset = CGPointMake(-10, 5);
                
                [_hud hide:YES];
                
            } failure:^(NSError *err) {
                
                _hud.mode = MBProgressHUDModeCustomView;
                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                _hud.labelText = @"Error";
                _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                [_hud hide:YES afterDelay:2];
                
            }];
            
        };
        
        return cell;

    }
    
    return nil;
    
}




-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return _infoArray.count>0 ? 1:0;
            break;
        case 1:
            return _dataArray.count;
            break;
        default:
            return 0;
            break;
    }
    
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0) {
        
        return CGSizeMake([AppUtil getScreenWidth]-20,70);
        
    }else{
    
        CGFloat w = ([AppUtil getScreenWidth]-30)/2;
        
        return CGSizeMake(w,w+10+30+5+12+5+12);
        
    }
}



- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {

        UICollectionReusableView *emptyHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"emptyHeaderView" forIndexPath:indexPath];
        emptyHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return emptyHeaderView;
        
    }else{
        
        HeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView" forIndexPath:indexPath];
        headerView.titleLabel.text = @"专场商品";
        headerView.moreImage.hidden = YES;
        headerView.moreBtn.hidden = YES;
        headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return headerView;
        
    }

}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    switch (section) {

        case 0:
            return self.infoArray.count>0 ? CGSizeMake([AppUtil getScreenWidth], 10):CGSizeMake(0, 0);
            break;
        case 1:
            return self.dataArray.count>0 ? CGSizeMake([AppUtil getScreenWidth], 44):CGSizeMake(0, 0);
            break;
        default:
            return CGSizeMake(0, 0);
            break;
    }
    
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 1) {
        
        GoodsModel *model = _dataArray[indexPath.row];
        
        GoodsDetailViewController *vc = [[GoodsDetailViewController alloc]init];
        
        vc.store_id = _store_id;
        
        vc.sg_id = model.sg_id;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    

}


#pragma mark - Action

-(void)cartAction{
    
    CartViewController *vc= [[CartViewController alloc]init];
    
    vc.store_id = _store_id;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 懒加载数据源



-(NSMutableArray *)infoArray{
    
    if(_infoArray == nil){
        
        _infoArray = [NSMutableArray array];
        
    }
    return _infoArray;
}

-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
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
