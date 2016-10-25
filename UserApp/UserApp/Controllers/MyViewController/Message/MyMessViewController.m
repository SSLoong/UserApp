//
//  MyMessViewController.m
//  UserApp
//
//  Created by perfect on 16/4/12.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "MyMessViewController.h"
#import "MessageViewCell.h"
#import "MessageModel.h"



@interface MyMessViewController ()

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isLoading;//是否在加载中

@end

@implementation MyMessViewController

-(id)initWithStyle:(UITableViewStyle)style{
   self= [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        
    }
    return self;
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.tableView registerClass:[MessageViewCell class] forCellReuseIdentifier:@"MessageViewCell"];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];

    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.hidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    

}


-(void)loadMore{
    
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
    
    _page ++;
    
    [self loadData];
    
}

-(void)loadData{
    
    [AFHttpTool customerMsg:Cust_id page:_page progress:^(NSProgress *progress) {
        
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
        if (_page == 1 && _dataArray.count > 0) {
            
            [self.dataArray removeAllObjects];
        }
        

        for (NSDictionary * dic in response[@"data"][@"dataList"]) {
            MessageModel * model = [[MessageModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [self.dataArray addObject:model];
        }
        
        _isLoading = NO;
        
        if (self.tableView.mj_footer.hidden) {
            self.tableView.mj_footer.hidden = NO;
        }
        
        
        if ([self.tableView.mj_header isRefreshing]) {

            [self.tableView.mj_header endRefreshing];
        }
        
        
        if (_page == [response[@"data"][@"totalPage"] integerValue] || 0 == [response[@"data"][@"totalPage"] integerValue]) {
            
              [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
        
            if ([self.tableView.mj_footer isRefreshing]) {
                    
                    [self.tableView.mj_footer endRefreshing];
                }
        }

        [self.tableView reloadData];

        
    } failure:^(NSError *err) {
        
        _isLoading = NO;
        
        if ([self.tableView.mj_header isRefreshing]) {
            
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
        }
        
        _hud = [AppUtil createHUD];
        _hud.userInteractionEnabled = NO;
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];


}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    MessageModel * model = _dataArray[indexPath.section];
    
    return [tableView fd_heightForCellWithIdentifier:@"MessageViewCell" cacheByIndexPath:indexPath configuration:^(MessageViewCell *cell) {
        
        [cell configModel:model];
    }];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"MessageViewCell";
    
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    MessageModel * model = _dataArray[indexPath.section];
    
    [cell configModel:model];
 
    return cell;
}



@end
