//
//  UIView+Extension.h
//  WhiteSharkBusiness
//
//  Created by 久远的回忆 on 15/12/22.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (Extension)

/**
 *  设置视图的边框颜色和粗细
 *
 *  @param color 颜色
 *  @param width 边框粗细
 */
- (void)setBoardColorWithColor:(UIColor *)color
                            andWidth:(CGFloat)width;

////设置圆角
//- (void)setCornerRadius:(float)radius;
// 添加虚线
- (void)addBoardImaginaryLine;


/**
 *  功能:添加视图顶部一个像素的分割线
 */
- (void)addTopOnePixelDevider;
/**
 *  功能:添加底部一个像素的分割线
 */
- (void)addBottomOnePixelDevider;
/**
 *  功能:该方法调用shouldResetDeviderLineToOnePixelInView 方法并 updateContraint
 */
- (void)resetDeviderLineToOnePixel;
/**
 *  功能:递归遍历所有subview，设置tag为911的分割线的 宽或高的约束为一个像素
 */
- (BOOL) shouldResetDeviderLineToOnePixel;


/**
 * 功能:晃动UIView动画
 */
- (void)shake;




//获取view的控制器(根据响应者链来找)
- (UIViewController*)viewController;

#pragma mark --- MB相关
/**
 *  功能:显示loading
 */
- (void)showLoading;

/**
 *  功能:显示loading
 */
- (void)showLoadingWithMessage:(NSString *)message;

/**
 *  功能:显示loading
 */
- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second;

/**
 *  功能:显示loading
 */
- (void)showLoadingWithMessage:(NSString *)message onView:(UIView *)aView hideAfter:(NSTimeInterval)second;

/**
 *  功能:隐藏loading
 */
- (void)hideLoading;

/**
 *  功能:隐藏loading
 */
- (void)hideLoadingOnView:(UIView *)aView;

@end
