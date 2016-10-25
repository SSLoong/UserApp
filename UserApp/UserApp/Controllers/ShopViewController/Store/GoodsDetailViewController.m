//
//  GoodsDetailViewController.m
//  UserApp
//
//  Created by prefect on 16/4/28.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "GoodsImageCell.h"
#import "OKTableViewCell.h"
#import "GoodsGiftViewCell.h"
#import "DetailTableViewCell.h"
#import "GoodsDetailModel.h"
#import "WZLBadgeImport.h"
#import "CartViewController.h"



@interface GoodsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *detailArray;

@property(nonatomic,strong)UITableView *tbView;

@property(nonatomic,strong)UIButton *cartBtn;

@property(nonatomic,strong)UILabel *moneyLabel;

@property(nonatomic,assign)NSInteger num;

@property(nonatomic,assign)CGFloat money;

@property(nonatomic,assign)CGFloat totalMoney;



@property(nonatomic,assign)NSInteger goods_type;

@property(nonatomic,copy)NSString *special_id;


@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"商品详情";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _num = 0;
    
    [self loadGoodsData];

}


-(void)createTableView{
    
    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64-44) style:UITableViewStyleGrouped];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    [self.view addSubview:_tbView];
    [self.tbView registerClass:[GoodsImageCell class] forCellReuseIdentifier:@"GoodsImageCell"];
    [self.tbView registerClass:[DetailTableViewCell class] forCellReuseIdentifier:@"DetailTableViewCell"];
    [self.tbView registerClass:[OKTableViewCell class] forCellReuseIdentifier:@"OKTableViewCell"];
    [self.tbView registerClass:[GoodsGiftViewCell class] forCellReuseIdentifier:@"GoodsGiftViewCell"];
    
}

-(void)cartView{

    UIView *cartView = [[UIView alloc]initWithFrame:CGRectMake(0, [AppUtil getScreenHeight]-44, [AppUtil getScreenHeight], 44)];
    cartView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:cartView];
    
    //购物车
    _cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cartBtn setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    _cartBtn.frame = CGRectMake(20, 2, 40,40);
    [_cartBtn addTarget:self action:@selector(cartAction) forControlEvents:UIControlEventTouchUpInside];
    [cartView addSubview:_cartBtn];

    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 7, 100, 30)];
    _moneyLabel.textColor = [UIColor whiteColor];
    _moneyLabel.font = [UIFont systemFontOfSize:18];
    _moneyLabel.hidden = YES;
    [cartView addSubview:_moneyLabel];
    

    //加入购物车按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    addBtn.frame = CGRectMake(self.view.bounds.size.width-100, 0, 100,44);
    addBtn.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    [addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [cartView addSubview:addBtn];
}



-(void)loadGoodsData{

    [AFHttpTool goodsDetail:_sg_id
                   progress:^(NSProgress *progress) {
        
    } success:^(id response) {

        
        if (!([response[@"code"]integerValue]==0000)) {
            
            _hud = [AppUtil createHUD];
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:2];
            
            return;
        }
        
        NSDictionary *dic = response[@"data"];
        
        GoodsDetailModel *model = [[GoodsDetailModel alloc]init];
        
        [model mj_setKeyValues:dic];
        
        _special_id = model.special_id;
        
        _money = [model.price floatValue];
        
        [self.detailArray addObject:model];
        
        [self createTableView];
        
        [self cartView];
        
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





#pragma mark - TableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0) {
        
        static NSString *cellId = @"GoodsImageCell";
        
        GoodsImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        GoodsDetailModel *model = self.detailArray [indexPath.row];
        
        [cell configImageArray:model.imgs];
        
        return cell;
        
    }else if(indexPath.section == 1) {
        
        static NSString *cellId = @"DetailTableViewCell";
        
        DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        GoodsDetailModel *model = self.detailArray[indexPath.row];
        
        [cell configModel:model];
        
        return cell;
        
    }else if (indexPath.section == 2){
    
        static NSString *cellId = @"GoodsGiftViewCell";
        
        GoodsGiftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        GoodsDetailModel *model = self.detailArray[indexPath.row];
        
        [cell configModel:model];
        
        return cell;
    
    }else if (indexPath.section == 3){
        
        static NSString *cellId = @"OKTableViewCell";
        
        OKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (indexPath.section == 4){
    
            
    static NSString * parameterCellId = @"parameterCellId";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:parameterCellId];
            if (cell == nil)
            {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:parameterCellId];
            }
        
        GoodsDetailModel *model = [self.detailArray lastObject];
        
        NSDictionary *dic = model.wine;
        
        switch (indexPath.row) {
            case 0:
            cell.textLabel.text= [NSString stringWithFormat:@"产地：%@",dic[@"winery"]];
                break;
            case 1:
                cell.textLabel.text= [NSString stringWithFormat:@"净含量：%@",dic[@"volume"]];
                break;
            case 2:
                cell.textLabel.text= [NSString stringWithFormat:@"酒精度：%@",dic[@"alcohol"]];
                break;
            case 3:
                cell.textLabel.text= [NSString stringWithFormat:@"规格：%@",dic[@"spec"]];
                break;
            case 4:
                cell.textLabel.text= [NSString stringWithFormat:@"香型：%@",dic[@"flavor"]];
                break;
            case 5:
                cell.textLabel.text= [NSString stringWithFormat:@"原料：%@",dic[@"material"]];
                break;
            default:
                break;
        }
            
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        
            cell.textLabel.textColor = [UIColor lightGrayColor];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;

    }else{
        
        
        static NSString * showUserInfoCellIdentifier = @"ShowUserInfoCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
        if (cell == nil)
        {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:showUserInfoCellIdentifier];
        }
        
        cell.textLabel.text= @"测试数据";
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }

    
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(self.detailArray.count>0){
    
        if (section == 4) {
        
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 35)];

            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 7.5, 3, 20)];
            lineView.backgroundColor = [UIColor colorWithHex:0xFD5B44];
            [view addSubview:lineView];
        
            UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(28, 7.5, 100, 20)];
            headerTitle.text = @"产品参数";
            headerTitle.font = [UIFont systemFontOfSize:14];
            [view addSubview:headerTitle];
            view.backgroundColor = [UIColor groupTableViewBackgroundColor];
      
            return view;
        }
    }
    
    return nil;
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    GoodsDetailModel *model = [self.detailArray lastObject];
    
    switch (section) {
        case 0:
        case 1:
            return 1;
            break;
        case 2:
            return [model.goods_type integerValue] > 1 ? 1 : 0;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 6;
            break;
        default:
            return 0;
            break;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    GoodsDetailModel *model = [self.detailArray lastObject];
    
    switch (indexPath.section) {

        case 0:
            return [AppUtil getScreenWidth] *0.8f;
            break;
        case 1:
            return 67;
            break;
        case 2:
            return [model.marketing[@"mk_strategy"] integerValue] ==3 ? 104:44;
            break;
        case 3:
        case 4:
            return 44;
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 0.1;
        case 1:
        case 2:
        case 3:
            return 5;
            break;
        case 4:
            return 35;
            break;
        default:
            return 0;
            break;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 懒加载数据源


-(NSMutableArray *)detailArray{
    
    if(_detailArray == nil){
        
        _detailArray = [NSMutableArray array];
        
    }
    return _detailArray;
}


#pragma mark - 按钮事件

-(void)cartAction{

    CartViewController *vc= [[CartViewController alloc]init];
    
    vc.store_id = _store_id;
    
    [self.navigationController pushViewController:vc animated:YES];

}


-(void)addAction{
    
    _hud = [AppUtil createHUD];
    
    _hud.userInteractionEnabled = YES;
    
    [AFHttpTool addCart:Cust_id store_id:_store_id special_id:_special_id sg_id:_sg_id buy_num:@"+1"  progress:^(NSProgress *progress) {
        
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
        
        [self setTotalMoney];
        
        [_hud hide:YES];
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:2];
        
    }];
    
    

}

-(void)setTotalMoney{

    if (_moneyLabel.hidden) {
        
        _moneyLabel.hidden = NO;
    }
    
    _totalMoney = _totalMoney + _money;
    
    _moneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",_totalMoney];

}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [_hud hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
