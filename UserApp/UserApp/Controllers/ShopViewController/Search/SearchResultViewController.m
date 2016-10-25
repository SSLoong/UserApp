//
//  SearchResultViewController.m
//  BusinessApp
//
//  Created by prefect on 16/5/13.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchResultViewCell.h"
#import "SearchResultModel.h"
#import "StoreSaleViewController.h"


@interface SearchResultViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)UILabel *numLabel;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,assign)BOOL isLoading;//是否在加载中

@end

@implementation SearchResultViewController

-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"相关商品";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createBtn];
    
    [self createCollectionView];

}


-(void)createBtn{
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:bgView];
    
    
    UIView *saleImage = [UIView new];
    saleImage.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    [self.view addSubview:saleImage];

    
    
    UILabel *nowLabel = [UILabel new];
    nowLabel.textColor = [UIColor grayColor];
    nowLabel.font = [UIFont systemFontOfSize:14];
    nowLabel.text = @"相关商品";
    [bgView addSubview:nowLabel];
    
    _numLabel = [UILabel new];
    _numLabel.textColor = [UIColor orangeColor];
    _numLabel.font = [UIFont systemFontOfSize:14];
    _numLabel.text = @"(0)";
    [bgView addSubview:_numLabel];
    
    
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(44);
        
    }];
    

    [saleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(bgView.mas_centerY);
        
        make.left.mas_equalTo(10);
        
        make.size.mas_equalTo(CGSizeMake(3, 16));
        
    }];
    
    
    [nowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(bgView.mas_centerY);
        
        make.left.equalTo(saleImage.mas_right).offset(5.f);
        
        make.height.mas_equalTo(14);
        
    }];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(bgView.mas_centerY);
        
        make.left.equalTo(nowLabel.mas_right);
        
        make.height.mas_equalTo(14);
        
    }];
    
}


-(void)createCollectionView{
    
    UICollectionViewFlowLayout *flowayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,108,[AppUtil getScreenWidth], [AppUtil getScreenHeight]-108) collectionViewLayout:flowayout];
    _collectionView.dataSource=self;
    _collectionView.delegate = self;
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[SearchResultViewCell class] forCellWithReuseIdentifier:@"SearchResultViewCell"];
    [self.view addSubview:_collectionView];
    
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


-(void)loadData{
    
    [AFHttpTool siteSearch:SiteCode
                  keywords:_keyString
                      page:_page
                   progress:^(NSProgress *progress) {
                       
                   } success:^(id response) {
                       WYBLog(@"%@",response);
 
                               if(_page ==1 && self.dataArray.count>0){
                       
                                   [self.dataArray removeAllObjects];
                               }
    
                               for (NSDictionary * dic in response[@"data"]) {
                                   SearchResultModel * model = [[SearchResultModel alloc]init];
                                   [model setValuesForKeysWithDictionary:dic];
                                   [self.dataArray addObject:model];
                               }
                       
                               _isLoading = NO;

                               if (self.dataArray.count > 0) {
                                   
                                   if (_collectionView.mj_footer.hidden) {
                                       _collectionView.mj_footer.hidden = NO;
                                   }
                               }
                       
                                    NSArray *array = response[@"data"];
                       
                               if   (array.count == 10){
                                   
                                    [_collectionView.mj_footer endRefreshing];
                       
                               }else{
                       
                                    [_collectionView.mj_footer endRefreshingWithNoMoreData];
                               }
     
                               if (_collectionView.mj_header.isRefreshing) {
                                   
                                   [_collectionView.mj_header endRefreshing];
                               }

                               _numLabel.text = [NSString stringWithFormat:@"(%zd)",_dataArray.count];
                       
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
                               
                               [_collectionView reloadData];
                               
                               if (_collectionView.mj_footer.isRefreshing) {
                                   
                                   [_collectionView.mj_footer endRefreshing];
                                   
                               }
                               if (_collectionView.mj_header.isRefreshing) {
                                   
                                   [_collectionView.mj_header endRefreshing];
                               }
                               
                       
                   }];
    
    
    
}


#pragma mark - CollectionViewDelegate


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchResultViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchResultViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    SearchResultModel *model = _dataArray[indexPath.row];
    
    [cell configModel:model];
    
    return cell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return self.dataArray.count;
    
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = (self.view.bounds.size.width - 30)/2;

    return CGSizeMake(w,w+10+28+10);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
        SearchResultModel *model = _dataArray[indexPath.row];
    
        StoreSaleViewController * vc= [[StoreSaleViewController alloc]init];
    
        vc.goods_id = model.goods_id;
    
        [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
