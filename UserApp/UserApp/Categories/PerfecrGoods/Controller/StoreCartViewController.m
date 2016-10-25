//
//  StoreCartViewController.m
//  UserApp
//
//  Created by prefect on 16/5/27.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "StoreCartViewController.h"
#import "StoreCartViewCell.h"
#import "StoreBrandModel.h"
#import "CartSaleModel.h"
#import "WZLBadgeImport.h"
#import "CartViewController.h"
//#import "ShoppingCartView.h"
//#import "ShoppingCartCell.h"
//#import "BadgeView.h"


//#import "CartModel.h"


@interface StoreCartViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)MBProgressHUD *hud;

@property (nonatomic,strong) UITableView *leftTableView;//左边表格

@property (nonatomic,strong) UITableView *rightTableView;//右边表格

@property (nonatomic,strong) NSMutableArray *leftArray;//左边数据源

@property (nonatomic,strong) NSMutableArray *rightArray;//右边数据源

@property (nonatomic,assign)BOOL isHot;//是否热卖

@property (nonatomic,copy)NSString *brand_id;//品牌id


@property (nonatomic,strong)UIButton *cartBtn;

@property (nonatomic,assign)float money;

@property (nonatomic,strong)UILabel *moneyLabel;

@property(nonatomic,assign)NSInteger cartNum;

@property (nonatomic,strong) CALayer *dotLayer;

@property (nonatomic,assign) CGFloat endPointX;

@property (nonatomic,assign) CGFloat endPointY;

@property (nonatomic,strong) UIBezierPath *path;

@end


@implementation StoreCartViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"选购商品";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createTableView];
    
    [self createCartView];
    
    [self loadLeftData];
    
}

-(void)createTableView{

    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth/7*2, ScreenHeight - 108)];
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.leftTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.leftTableView];
    
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth/7*2, 64, ScreenWidth/7*5, ScreenHeight - 108)];
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    self.rightTableView.backgroundColor = [UIColor whiteColor];
    [self.rightTableView registerClass:[StoreCartViewCell class] forCellReuseIdentifier:@"StoreCartViewCell"];
    self.rightTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.rightTableView];

}

-(void)createCartView{
    
    _cartNum = 0;
    
    _money = 0.00;
    
    UIView *cartView = [[UIView alloc]initWithFrame:CGRectMake(0,ScreenHeight-44, ScreenWidth, 44)];
    cartView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:cartView];

    //购物车
    _cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cartBtn setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    _cartBtn.frame = CGRectMake(20, 2, 40,40);
    [_cartBtn addTarget:self action:@selector(cartAction) forControlEvents:UIControlEventTouchUpInside];
    [cartView addSubview:_cartBtn];
    
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 100, 30)];
    _moneyLabel.textColor = [UIColor whiteColor];
    _moneyLabel.font = [UIFont systemFontOfSize:18];
    [cartView addSubview:_moneyLabel];
    
    //加入购物车按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    addBtn.frame = CGRectMake(self.view.bounds.size.width-90, 0, 90,44);
    addBtn.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    [addBtn setTitle:@"选好了" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(cartAction) forControlEvents:UIControlEventTouchUpInside];
    [cartView addSubview:addBtn];
    
    CGRect rect = [self.view convertRect:_cartBtn.frame fromView:cartView];
    _endPointX = rect.origin.x + 15;
    _endPointY = rect.origin.y + 35;
}

-(void)cartAction{

    CartViewController *vc = [[CartViewController alloc]init];
    
    vc.store_id = _store_id;
    
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)loadLeftData{
    
    [AFHttpTool storeBrand:_store_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        for (NSDictionary * dic in response[@"data"]) {
            StoreBrandModel * model = [[StoreBrandModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.leftArray addObject:model];
        }
        
        [self.leftTableView reloadData];
        
        _isHot = YES;
        
        [self loadHotData];
        
    } failure:^(NSError *err) {
        
    }];
    
}


-(void)loadHotData{
    
    
    if (self.rightArray.count>0) {
        
        [self.rightArray removeAllObjects];
    }
    
    
    if(_isHot){
        
        [AFHttpTool storeHotsale:_store_id
                        progress:^(NSProgress *progress) {
                            
                        } success:^(id response) {
                            
                            for (NSDictionary *dic in response[@"data"]) {
                                    
                                    CartSaleModel *model = [[CartSaleModel alloc]init];
                                    
                                    [model setValuesForKeysWithDictionary:dic];
                                    
                                    [self.rightArray addObject:model];
                            }
                            
                            [self.rightTableView reloadData];
                            
                        } failure:^(NSError *err) {
                            
                        }];
        
    }else{
        
        [AFHttpTool storeBrandGoods:_store_id
                           brand_id:_brand_id
                           progress:^(NSProgress *progress) {
                               
                           } success:^(id response) {
                               
                               for (NSDictionary *dic in response[@"data"]) {
                                   
                                   if ([dic[@"type"] integerValue] == 0){
                                   
                                       CartSaleModel *model = [[CartSaleModel alloc]init];
                                       
                                       [model setValuesForKeysWithDictionary:dic];
                                       
                                       [self.rightArray addObject:model];
                                       
                                   }
                                   
                               }
                               
                               [self.rightTableView reloadData];
                               
                           } failure:^(NSError *err) {
                               
                           }];
        
    }
    
}



#pragma mark - UITableViewDelegete

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.leftTableView])
    {
        return 44;
    }
    
    return 60;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSUInteger count = 0;
    if ([tableView isEqual:self.rightTableView]) {
        count = self.rightArray.count;
    }else{
        
        count = 1+self.leftArray.count;
    }
    return count;
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if ([tableView isEqual:self.leftTableView]) {
        
        static NSString *identifier = @"leftTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        
        UIView *sView = [[UIView alloc] init];
        sView.backgroundColor = [UIColor whiteColor];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 44)];
        view.backgroundColor = [UIColor colorWithHex:0xFD5B44];
        [sView addSubview:view];
        
        cell.selectedBackgroundView = sView;
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.separatorInset = UIEdgeInsetsZero;
        
        
        if (indexPath.row == 0) {
            
            UIImage *image =[UIImage imageNamed:@"hot"];
            cell.imageView.image = image;
            cell.textLabel.text = @"热销";
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
        }else{
            
            StoreBrandModel *model = _leftArray[indexPath.row-1];
            cell.textLabel.text = model.name;
            cell.imageView.image = nil;
        }
        
        return cell;
        
    }else if([tableView isEqual:self.rightTableView]){
        
        static NSString * str = @"StoreCartViewCell";
        
        StoreCartViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CartSaleModel * model = self.rightArray[indexPath.row];
        
        [cell configModel:model];
    
        
        __weak __typeof(&*cell)weakCell =cell;
        
        
        cell.addBlock = ^()
        {
            
            CGRect parentRect = [weakCell convertRect:weakCell.addBtn.frame toView:self.view];
            
            [AFHttpTool addCart:Cust_id store_id:_store_id special_id:@"" sg_id:model.sg_id buy_num:@"+1"  progress:^(NSProgress *progress) {
                
            } success:^(id response) {
                
                if (!([response[@"code"]integerValue]==0000)) {
                    NSString *errorMessage = response [@"msg"];
                    _hud = [AppUtil createHUD];
                    _hud.mode = MBProgressHUDModeCustomView;
                    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                    _hud.detailsLabelText = errorMessage;
                    [_hud hide:YES afterDelay:2];
                    return;
                }
                
                _money += ([model.price floatValue]-[model.sub_amount floatValue]);
                _moneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",_money];
                _cartNum++;
                [_cartBtn showBadgeWithStyle:WBadgeStyleNumber value:_cartNum animationType:WBadgeAnimTypeNone];
                _cartBtn.badgeCenterOffset = CGPointMake(-10, 5);
                [self JoinCartAnimationWithRect:parentRect];

                
            } failure:^(NSError *err) {
                
                _hud = [AppUtil createHUD];
                _hud.mode = MBProgressHUDModeCustomView;
                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                _hud.labelText = @"Error";
                _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                [_hud hide:YES afterDelay:2];
                
            }];
            
        };

        
        
        return cell;
        
    }
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.leftTableView]) {
        
        if(indexPath.row == 0){
            
            _isHot = YES;
            
            [self loadHotData];
            
        }else{
            
            _isHot = NO;
            
            StoreBrandModel *model = self.leftArray[indexPath.row-1];
            
            _brand_id = [NSString stringWithFormat:@"%@",model.brand_id];
            
            [self loadHotData];
            
        }
        
    }
    
}




#pragma mark -加入购物车动画
-(void) JoinCartAnimationWithRect:(CGRect)rect
{
    
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y;
    
    _path= [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(startX, startY)];
    //三点曲线
    [_path addCurveToPoint:CGPointMake(_endPointX, _endPointY)
             controlPoint1:CGPointMake(startX, startY)
             controlPoint2:CGPointMake(startX - 180, startY - 200)];
    
    _dotLayer = [CALayer layer];
    _dotLayer.backgroundColor = [UIColor redColor].CGColor;
    _dotLayer.frame = CGRectMake(0, 0, 15, 15);
    _dotLayer.cornerRadius = (15 + 15) /4;
    [self.view.layer addSublayer:_dotLayer];
    [self groupAnimation];
    
}
#pragma mark - 组合动画
-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.duration = 0.5f;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation];
    groups.duration = 0.8f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [_dotLayer addAnimation:groups forKey:nil];
    
    [self performSelector:@selector(removeFromLayer:) withObject:_dotLayer afterDelay:0.8f];
    
}

- (void)removeFromLayer:(CALayer *)layerAnimation{
    
    [layerAnimation removeFromSuperlayer];
}


#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
        if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
    
            CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            shakeAnimation.duration = 0.25f;
            shakeAnimation.fromValue = [NSNumber numberWithFloat:0.9];
            shakeAnimation.toValue = [NSNumber numberWithFloat:1];
            shakeAnimation.autoreverses = YES;
            [_cartBtn.layer addAnimation:shakeAnimation forKey:nil];
        }
    
}



#pragma Mark -懒加载数据源

-(NSMutableArray *)leftArray{
    
    if (_leftArray == nil) {
        
        _leftArray = [NSMutableArray array];
    }
    return _leftArray;
}

-(NSMutableArray *)rightArray{
    
    if (_rightArray == nil) {
        
        _rightArray = [NSMutableArray array];
    }
    return _rightArray;
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
