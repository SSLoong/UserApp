//
//  MyOrderViewController.m
//  UserApp
//
//  Created by prefect on 16/4/12.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "MyOrderViewController.h"
#import "OrderTableController.h"
#import "WSFSlideTitlesView.h"

@interface MyOrderViewController () <WSFSlideTitlesViewDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) WSFSlideTitlesView *titlesView;

@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的订单";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self createView];

    [self.titlesView selectButtonAtIndex:_type-1];
}

- (void)createView
{

    WSFSlideTitlesViewSetting *titlesSetting = [[WSFSlideTitlesViewSetting alloc] init];
    titlesSetting.titlesArr = @[ @"全部订单", @"待付款", @"待收货" ];
    titlesSetting.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 44);
    
    // 通过设置创建 WSFSlideTitlesView
    WSFSlideTitlesView *titlesView = [[WSFSlideTitlesView alloc] initWithSetting:titlesSetting];
    titlesView.delegate = self;
    self.titlesView = titlesView;
    [self.view addSubview:titlesView];
    
    
    for (int i=0 ; i<3 ;i++){
        
        OrderTableController *ctrl = [[OrderTableController alloc]init];
        
        if (i==0) {
            ctrl.status = @"";
            ctrl.pay_result = @"";
        }else if (i== 1){
            ctrl.status = @"0";
            ctrl.pay_result = @"0";
        }else if (i==2){
            ctrl.status = @"4";
            ctrl.pay_result = @"1";
        }
        [self addChildViewController:ctrl];
    }
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 108, [AppUtil getScreenWidth],[AppUtil getScreenHeight]-64-44)];
    
    _scrollView.delegate = self;
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.scrollEnabled = NO;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGFloat contentX = self.childViewControllers.count * _scrollView.bounds.size.width;
    
    _scrollView.contentSize = CGSizeMake(contentX, 0);
    
    [self.view addSubview:_scrollView];
    
    UITableViewController *vc = [self.childViewControllers firstObject];
    
    vc.view.frame = _scrollView.bounds;
    
    [_scrollView addSubview:vc.view];

}


- (void)slideTitlesView:(WSFSlideTitlesView *)titlesView
        didSelectButton:(UIButton *)button
                atIndex:(NSUInteger)index
{
    CGFloat offsetX = index * _scrollView.frame.size.width;
    
    CGFloat offsetY = _scrollView.contentOffset.y;
    
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [_scrollView setContentOffset:offset animated:YES];
    
}

#pragma mark - scrollView代理

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    NSUInteger index = scrollView.contentOffset.x / _scrollView.frame.size.width;
    
    OrderTableController *newsVc = self.childViewControllers[index];
    
    if (newsVc.view.superview) return;
    
    newsVc.view.frame = scrollView.bounds;
    
    [_scrollView addSubview:newsVc.view];
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
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
