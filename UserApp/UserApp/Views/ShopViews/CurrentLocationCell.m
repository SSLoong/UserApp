//
//  CurrentLocationCell.m
//
//
//  Created by Sam Lau on 6/17/15.
//
//

#import "CurrentLocationCell.h"

@implementation CurrentLocationCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}


-(void)initSubviews{
    
    _currentLocationLabel = [UILabel new];
    _currentLocationLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_currentLocationLabel];
    
    _locationImageView = [UIImageView new];
    _locationImageView.image = [UIImage imageNamed:@"icon_current"];
    [self.contentView addSubview:_locationImageView];
    

    _activityIndicatorView = [UIActivityIndicatorView new];
    _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.contentView addSubview:_activityIndicatorView];
    
    
    _repositionButton = [UIButton new];
    [_repositionButton setTitle:@"重新定位" forState:UIControlStateNormal];
    _repositionButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_repositionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_repositionButton];
    
}

-(void)setLayout{

    [_currentLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.height.mas_offset(14);
        make.left.mas_offset(20);
        
    }];
    
    
    [_repositionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.height.mas_offset(14);
        make.right.mas_offset(-15);
        
    }];
    
    
    
    [_activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(_repositionButton.mas_left).offset(-5);
        make.centerY.equalTo(self);
    }];
    
    
    [_locationImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_offset(CGSizeMake(14, 14));
        make.right.equalTo(_repositionButton.mas_left).offset(-5);
        make.centerY.equalTo(self);
    }];
    
}


@end
