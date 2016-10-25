//
//  SearchViewController.m
//  BusinessApp
//
//  Created by prefect on 16/5/12.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "AllGoodsViewCell.h"
#import "AllGoodsModel.h"



@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UISearchBar *searchBar;

@property(nonatomic,strong)UITableView *leftTableView;

@property(nonatomic,strong)UICollectionView *rightCollectionView;

@property(nonatomic,strong)NSMutableArray *listArray;

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation SearchViewController

//懒加载数组
-(NSMutableArray *)listArray{
    
    if(_listArray == nil){
        
        _listArray = [NSMutableArray array];
        
    }
    return _listArray;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"搜索商品";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [self createSearchBar];
    
    [self createView];
    
    [self loadData];
    
}

-(void)loadData{

    _hud = [AppUtil createHUD];
    _hud.labelText = @"加载中...";
    _hud.userInteractionEnabled = NO;
    
    [AFHttpTool siteGoods:SiteCode
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

                     NSArray *dicArray = response[@"data"];
                     
                     for (NSDictionary *dic in dicArray) {
                         
                         AllGoodsModel *model = [[AllGoodsModel alloc]init];
                         
                         [model setValuesForKeysWithDictionary:dic];
                         
                         [self.listArray addObject:model];
                         
                     }
                     
                     [_hud hide:YES];
                     
                     [self.leftTableView reloadData];
                     
                     [self.rightCollectionView reloadData];
                     
                 } failure:^(NSError *err) {
                     
                     _hud.mode = MBProgressHUDModeCustomView;
                     _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                     _hud.labelText = @"Error";
                     _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                     [_hud hide:YES afterDelay:2];
                     
                 }];

}


-(void)createSearchBar{
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 74, self.view.bounds.size.width, 30)];
    
    [[[[ _searchBar.subviews objectAtIndex:0 ]subviews ]objectAtIndex:0 ] removeFromSuperview];

    _searchBar.placeholder = @"请输入商品名称";
    
    _searchBar.delegate = self;
    
    [self.view addSubview:_searchBar];
    
}

-(void)createView{


    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, self.view.bounds.size.width*0.25, self.view.bounds.size.height-114) style:UITableViewStylePlain];
    _leftTableView.rowHeight = 44;
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _leftTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _leftTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_leftTableView];
    
    UICollectionViewFlowLayout *flowayout = [[UICollectionViewFlowLayout alloc]init];
    flowayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width*0.75, 30);
    _rightCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.25,114, self.view.bounds.size.width*0.75, self.view.bounds.size.height-114) collectionViewLayout:flowayout];
    _rightCollectionView.dataSource=self;
    _rightCollectionView.delegate = self;
    _rightCollectionView.backgroundColor = [UIColor whiteColor];
    [_rightCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    [_rightCollectionView registerClass:[AllGoodsViewCell class] forCellWithReuseIdentifier:@"AllGoodsViewCell"];
    [self.view addSubview:_rightCollectionView];
}




#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    return _listArray.count;
    
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.rightCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    AllGoodsModel *model = _listArray[indexPath.row];
    cell.textLabel.text = model.name;
    UIView *sView = [[UIView alloc] init];
    sView.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = sView;
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.separatorInset = UIEdgeInsetsZero;
    
    if (0 == indexPath.row) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }

    return cell;
}



#pragma mark - UICollectionViewDatesource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _listArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    
    AllGoodsModel *model = _listArray[section];
    
    NSArray *array = model.brands;
    
    return array.count;
    
}


#pragma mark - UICollectionViewDelegate


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    AllGoodsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AllGoodsViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    AllGoodsModel *model = _listArray[indexPath.section];
 
    NSString *urlString = [model.brands[indexPath.row] objectForKey:@"logo"];
        
    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"store_header"]];

    
    return cell;
}



- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    //创建头视图
    UICollectionReusableView *headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
    
    //添加label
    UILabel *label = [[UILabel alloc]initWithFrame:headerCell.bounds];
    
    label.textColor = [UIColor grayColor];
    
    label.font = [UIFont systemFontOfSize:13.f];
    
    label.backgroundColor = [UIColor whiteColor];
    
    AllGoodsModel *model = _listArray[indexPath.section];

    NSString *titleString = [NSString stringWithFormat:@"  %@",model.name];
        
    label.text = titleString;
    
    [headerCell addSubview:label];
    
    return headerCell;
    
}





-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = (self.view.bounds.size.width*0.75-40)/3;
    
    return CGSizeMake(w,w);
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchResultViewController *vc = [[SearchResultViewController alloc]init];
    
    AllGoodsModel *model = _listArray[indexPath.section];
    
    NSString *name = [model.brands[indexPath.row] objectForKey:@"name"];
    
    vc.keyString = name;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - searchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    SearchResultViewController *vc = [[SearchResultViewController alloc]init];
    
    vc.keyString = searchBar.text;

    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 滚动表格

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self.rightCollectionView == scrollView) {
        
        
        NSArray *indexArr = [self.rightCollectionView indexPathsForVisibleItems];
        
        NSIndexPath *lastIndexPath = [indexArr lastObject];
        
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:lastIndexPath.section inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    }
    
    
}

//当单元格减速时调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (self.rightCollectionView == scrollView) {
        
        NSArray *indexArr = [self.rightCollectionView indexPathsForVisibleItems];
        
        NSIndexPath *lastIndexPath = [indexArr lastObject];
        
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:lastIndexPath.section inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    }
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
