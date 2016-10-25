//
//  NearSpecialViewCell.m
//  UserApp
//
//  Created by prefect on 16/7/8.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "NearSpecialViewCell.h"
#import "SpecialCollectionViewCell.h"
#import "SpecialModel.h"


@interface NearSpecialViewCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation NearSpecialViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
    }
    
    return self;
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    
    _dataArray = dataArray;
    
    [_collectionView reloadData];
}

-(void)initSubviews{

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, (ScreenWidth-30)/2+76)
                                         collectionViewLayout:flowLayout];

    _collectionView.dataSource = self;
    
    _collectionView.delegate = self;
    
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:_collectionView];
    
    [_collectionView registerClass:[SpecialCollectionViewCell class] forCellWithReuseIdentifier:@"SpecialCollectionViewCell"];
}

#pragma mark - collectionViewDelegate && dataSouce

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    SpecialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpecialCollectionViewCell" forIndexPath:indexPath];
    
    SpecialModel *model = _dataArray[indexPath.row];
    
    cell.model = model;
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;

}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    CGFloat w = (ScreenWidth-30)/2;
        
    return CGSizeMake(w,w+60);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataArray.count;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.index) {
        self.index(indexPath.row);
    }

}

@end
