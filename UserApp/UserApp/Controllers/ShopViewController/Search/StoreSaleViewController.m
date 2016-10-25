//
//  StoreSaleViewController.m
//  UserApp
//
//  Created by prefect on 16/5/16.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "StoreSaleViewController.h"
#import "StoreSaleViewCell.h"
#import "StoreSaleModel.h"
#import "StoreViewController.h"

@interface StoreSaleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UITableView *tbView;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isLoading;//是否在加载中

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,copy)NSString *logoString;

@property(nonatomic,copy)NSString *nameString;

@property(nonatomic,copy)NSString *numString;

@property(nonatomic,assign)BOOL isFrist;

@end

@implementation StoreSaleViewController

-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"商品在售门店";
    
    self.view.backgroundColor = [UIColor whiteColor];
 
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createTableView];
}


-(void)createTableView{

    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 183, self.view.bounds.size.width, self.view.bounds.size.height-183) style:UITableViewStylePlain];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    _tbView.backgroundColor = [UIColor whiteColor];
    _tbView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tbView];
    
    [self.tbView registerClass:[StoreSaleViewCell class] forCellReuseIdentifier:@"StoreSaleViewCell"];
    
    _tbView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    
    [_tbView.mj_header beginRefreshing];
    
    _tbView.mj_footer = ({
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
    
    [AFHttpTool goodsStores:SiteCode
                   goods_id:_goods_id
                       page:_page
                   progress:^(NSProgress *progress) {
        
    } success:^(id response) {
    
        //WYBLog(@"返回:%@",response);
        if(_page ==1 && self.dataArray.count>0){
            
            [self.dataArray removeAllObjects];
        }
        
        _logoString = response[@"data"][@"cover_img"];
        
        _nameString = response[@"data"][@"goods_name"];
        
        _numString = response[@"data"][@"stores"][@"totalCount"];
        
        if (!_isFrist) {
            
            [self createBtn];
        }
        
        _isFrist = YES;
        
        for (NSDictionary * dic in response[@"data"][@"stores"][@"dataList"]) {
            StoreSaleModel * model = [[StoreSaleModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        
        _isLoading = NO;
        
        if (_tbView.mj_footer.hidden) {
            _tbView.mj_footer.hidden = NO;
        }

        NSInteger totalPage = [response[@"data"][@"stores"][@"totalPage"] integerValue];
        
        if(_page == totalPage || totalPage == 0){
            
            [_tbView.mj_footer endRefreshing];
            
        }else{
            
            [_tbView.mj_footer endRefreshing];
        }
        
        if (_tbView.mj_header.isRefreshing) {
            
            [_tbView.mj_header endRefreshing];
        }
        
        [_tbView reloadData];
        
    } failure:^(NSError *err) {
        
        _hud = [AppUtil createHUD];
        _hud.userInteractionEnabled = NO;
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
        _isLoading = NO;
        
        if (_tbView.mj_footer.isRefreshing) {
            
            [_tbView.mj_footer endRefreshing];
            
        }
        if (_tbView.mj_header.isRefreshing) {
            
            [_tbView.mj_header endRefreshing];
        }
        
    }];
    
    
}



-(void)createBtn{
    
    UIImageView *logoImage = [UIImageView new];
    [logoImage sd_setImageWithURL:[NSURL URLWithString:_logoString] placeholderImage:[UIImage imageNamed:@"store_big_header"]];
    [self.view addSubview:logoImage];
    
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.text = _nameString;
    [self.view addSubview:nameLabel];
    
    
    UILabel *numLabel = [UILabel new];
    numLabel.font = [UIFont systemFontOfSize:14];
    numLabel.textColor = [UIColor orangeColor];
    numLabel.text = [NSString stringWithFormat:@"在售门店%@",_numString];
    [self.view addSubview:numLabel];
    
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(15);
        make.top.mas_offset(79);
        make.size.mas_offset(CGSizeMake(45, 45));
    }];
    
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(79);
        make.left.equalTo(logoImage.mas_right).offset(10.f);
        make.right.mas_offset(0);
    }];


    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(logoImage.mas_bottom);
        make.left.equalTo(logoImage.mas_right).offset(10.f);
    }];
    

    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:bgView];
    
    
    UIView *saleImage = [UIView new];
    saleImage.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    [self.view addSubview:saleImage];
    
    
    
    UILabel *nowLabel = [UILabel new];
    nowLabel.textColor = [UIColor grayColor];
    nowLabel.font = [UIFont systemFontOfSize:14];
    nowLabel.text = @"在售门店";
    [bgView addSubview:nowLabel];
    

    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(139);
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

    

}


#pragma mark - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"StoreSaleViewCell";
    
    StoreSaleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    StoreSaleModel *model = self.dataArray[indexPath.row];
    
    [cell configModel:model];
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StoreViewController *vc = [[StoreViewController alloc]init];
    
    StoreSaleModel *model = self.dataArray[indexPath.row];
    
    vc.store_id = model.store_id;
    
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
