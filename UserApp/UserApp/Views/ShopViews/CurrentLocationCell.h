//
//  CurrentLocationCell.h
//  
//
//  Created by Sam Lau on 6/17/15.
//
//

#import <UIKit/UIKit.h>


@interface CurrentLocationCell : UITableViewCell

@property (strong, nonatomic) UILabel *currentLocationLabel;
@property (strong, nonatomic) UIImageView *locationImageView;
@property (strong, nonatomic) UIButton *repositionButton;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end
