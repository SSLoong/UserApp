//
//  Macros.h
//  MyTool
//
//  Created by wangyebin on 15/9/23.
//  Copyright (c) 2015年 wangyebin. All rights reserved.
//

#ifndef FireShadow_Macros_h
#define FireShadow_Macros_h


//一个像素宽度
#define OnePixelWidth  (ScreenWidth == 414 ? 0.334 : 0.5)

//字号大小处理
#define HelveticaNeueFont(fontSize)  [UIFont fontWithName:@"HelveticaNeue" size:(fontSize)]
#define HelveticaNeueLightFont(fontSize)   [UIFont fontWithName:@"HelveticaNeue-Light" size:(fontSize)]


//弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define NSLog(fmt,...)
//个人日志输出
//#define WYB
#ifdef WYB
#define WYBLog(fmt,...) NSLog( @"%s------------\r\n%@",__FUNCTION__, [NSString stringWithFormat:(fmt), ##__VA_ARGS__]);
#else
#define WYBLog(fmt,...)
#endif



//从Storyboard加载控制器
#define VCWithStoryboardNameAndVCIdentity(name,idetity) [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:idetity];
//从xib加载视图
#define ViewFromNibName(name) [[[NSBundle mainBundle] loadNibNamed:(name) owner:nil options:nil] firstObject]




//判断是否为ios7.0以前
#define IsIOS7AndEarlier ([[[UIDevice currentDevice] systemVersion] doubleValue] < 7.1 ? YES : NO)
//判断是否是ipone4
#define IsIphone4 ([UIScreen mainScreen].bounds.size.height == 480 ? YES : NO)
//判断是否是ipone6plus
#define IsIphone6plus ([UIScreen mainScreen].bounds.size.height == 736 ? YES : NO)

/* 用户信息处理 */
#define checkNull(id)   (id != nil && ![id isEqual:[NSNull null]])




#endif
