//
//  UIView+Extension.m
//  WhiteSharkBusiness
//
//  Created by 久远的回忆 on 15/12/22.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setBoardColorWithColor:(UIColor *)color
                            andWidth:(CGFloat)width
{
    [self.layer setBorderWidth:width];
    [self.layer setBorderColor:color.CGColor];
}


//- (void)setCornerRadius:(float)radius
//{
//    self.layer.cornerRadius = radius;
//    self.layer.masksToBounds = YES;
//    
//}

// 添加虚线
- (void)addBoardImaginaryLine
{
    CAShapeLayer *border = [CAShapeLayer layer];
    
    border.strokeColor = [UIColor groupTableViewBackgroundColor].CGColor;
    border.fillColor = nil;
    
    border.path = [UIBezierPath bezierPathWithRect:self.layer.bounds].CGPath;
    
    border.frame = self.layer.bounds;
    border.lineWidth = 1.5f;
    border.lineCap = @"round";
    border.lineDashPattern = @[@4, @2];
    [self.layer addSublayer:border];
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)showLoading
{
    [self showLoadingWithMessage:nil];
}

- (void)showLoadingWithMessage:(NSString *)message
{
    [self showLoadingWithMessage:message hideAfter:0];
}

- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second
{
    [self showLoadingWithMessage:message onView:self hideAfter:second];
}

- (void)showLoadingWithMessage:(NSString *)message onView:(UIView *)aView hideAfter:(NSTimeInterval)second
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    
    if (message) {
        hud.labelText = message;
        hud.mode = MBProgressHUDModeText;
    }
    else {
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    
    if (second > 0) {
        [hud hide:YES afterDelay:second];
    }
}

- (void)hideLoading
{
    [self hideLoadingOnView:self];
}

- (void)hideLoadingOnView:(UIView *)aView
{
    [MBProgressHUD hideAllHUDsForView:aView animated:YES];
}


/**
 *  功能:添加视图顶部一个像素的分割线
 */
- (void)addTopOnePixelDevider
{
    CGFloat lineWidth;
    
    if (ScreenWidth == 414) {
        lineWidth = 0.334;
    }else if(ScreenWidth == 320){
        lineWidth = 1;
    }else {
        lineWidth = 0.5;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, lineWidth)];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:label];
}


/**
 *  功能:添加底部一个像素的分割线
 */
- (void)addBottomOnePixelDevider
{
    CGFloat lineWidth;
    
    if (ScreenWidth == 414) {
        lineWidth = 0.334;
    }else if(ScreenWidth == 320){
        lineWidth = 1;
    }else {
        lineWidth = 0.5;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height -lineWidth, self.bounds.size.width, lineWidth)];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:label];
}

#pragma mark - 设置当前所有subview中tag为911的分割线为一个像素
- (void)resetDeviderLineToOnePixel
{
    if ([self shouldResetDeviderLineToOnePixel]) {
        [self layoutIfNeeded];
        [self updateConstraints];
    }
}

- (BOOL)shouldResetDeviderLineToOnePixel
{
    // 找出每一个view下所有的分割线，更新它的高度或者宽度为0.5, iPhone 6plus为0.334
    // 分割线的tag固定为 911
    BOOL flag = NO;
    
    for (UIView *view in self.subviews) {
        if (view.tag == 911) {
            // 枚举view下所有的subview
            for (NSLayoutConstraint *constraint in view.constraints)
            {
                if (constraint.firstAttribute == NSLayoutAttributeWidth ||
                    constraint.firstAttribute == NSLayoutAttributeHeight) {
                    
                    if (ScreenWidth == 414) {
                        constraint.constant = 0.334;
                    }else{
                        constraint.constant = 0.5;
                    }
                    
                    flag = YES;
                }
            }
        }else{
            if ([view shouldResetDeviderLineToOnePixel]) {
                flag = YES;
            }
        }
    }
    return flag;
}

/**
 * 功能:晃动UIView动画
 */
- (void)shake
{
    CGRect originFrame = self.frame;
    __block CGRect frame;
    
    CGFloat duration = 0.1;
    __block CGFloat vibration = originFrame.size.width / 14;
    CGFloat delta = vibration / 7;
    
    
    [UIView animateWithDuration:duration animations:^{
        vibration -= delta;
        frame = originFrame;
        frame.origin.x -= vibration;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration animations:^{
            vibration -= delta;
            frame = originFrame;
            frame.origin.x += vibration;
            self.frame = frame;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration animations:^{
                vibration -= delta;
                frame = originFrame;
                frame.origin.x -= vibration;
                self.frame = frame;
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:duration animations:^{
                    vibration -= delta;
                    frame = originFrame;
                    frame.origin.x += vibration;
                    self.frame = frame;
                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:duration animations:^{
                        vibration -= delta;
                        frame = originFrame;
                        frame.origin.x -= vibration;
                        self.frame = frame;
                    } completion:^(BOOL finished) {
                        
                        [UIView animateWithDuration:duration animations:^{
                            vibration -= delta;
                            frame = originFrame;
                            frame.origin.x += vibration;
                            self.frame = frame;
                        } completion:^(BOOL finished) {
                            
                            [UIView animateWithDuration:duration animations:^{
                                frame = originFrame;
                                self.frame = frame;
                            } completion:^(BOOL finished) {
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}


@end
