//
//  OpenKicketViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/23.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OpenKicketViewController.h"
#import "OpenTicketViewCell.h"

@interface OpenKicketViewController ()

@end

@implementation OpenKicketViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择发票";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.tableView registerClass:[OpenTicketViewCell class] forCellReuseIdentifier:@"OpenTicketCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _num == 0 ? 1 : 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellId = @"OpenTicketCell";
    
    OpenTicketViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

    NSString *str = _num ==1 ? @"普通发票":@"增值税发票";
    
    cell.nameLabel.text = @[@"不需要",str] [indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    return cell;
    
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    OpenTicketViewCell *cell = (OpenTicketViewCell*)[tableView cellForRowAtIndexPath:indexPath];

    if (self.selectRows) {
        self.selectRows(cell.nameLabel.text);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
