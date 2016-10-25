//
//  AppDelegate.m
//  UserApp
//
//  Created by prefect on 16/4/8.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import <AlipaySDK/AlipaySDK.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "IQKeyboardManager.h"
#import "WXApi.h"

@interface AppDelegate ()<BMKGeneralDelegate,WXApiDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)BMKMapManager *mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    /**
     *  设置tabbar选中颜色
     */
    [[UITabBar appearance] setTintColor:[UIColor colorWithHex:0xFD5B44]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFD5B44]} forState:UIControlStateSelected];
 
    /**
     *  设置导航颜色
     */
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"app_header"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    

    /**
     *  设置状态栏颜色
     */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    /**
     *  设置NavigationBar标题文字颜色
     */
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    /**
     *  去掉返回文字
     */
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    

    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    [UMSocialData setAppKey:UmengAppKey];
    
    //分享控件
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    
    [UMSocialQQHandler setQQWithAppId:@"1104014809" appKey:@"0jLuaFoIw7WoeQRM" url:@"http://www.appsjk.com"];
    
    [UMSocialWechatHandler setWXAppId:@"wxe4542900ffa6e183" appSecret:@"caff321a7008484c54262393db3050fb" url:@"http://www.appsjk.com"];
    
    [WXApi registerApp:@"wxe4542900ffa6e183" withDescription:@"闪酒客微信订单"];
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"9COctp1CcnuSLo7e8izxEs3CdGcMwr2u" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    if ([DEFAULTS objectForKey:@"latitude"]) {
        [DEFAULTS removeObjectForKey:@"latitude"];
        [DEFAULTS removeObjectForKey:@"longitude"];
        [DEFAULTS removeObjectForKey:@"siteCode"];
        [DEFAULTS synchronize];
    }
    
    [self appVersion];

    return YES;
}




-(void)appVersion{
    
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    
    [AFHttpTool appVersion:@"iOS" app_version:appVersion
     
                  progress:^(NSProgress *progress) {
        
                  } success:^(id response) {
        
        
        if([response[@"code"] integerValue] == 0000){
            
            
            NSString *title = [NSString stringWithFormat:@"发现新版本:%@",response[@"data"][@"version_no"]];
            
            NSString *update_content = response[@"data"][@"update_content"];
            
            NSString *cancelString = [response[@"data"][@"is_update"] integerValue] > 0 ? nil:@"忽略升级";
            
            [[[UIAlertView alloc] initWithTitle:title message:update_content delegate:self cancelButtonTitle:cancelString otherButtonTitles:@"现在升级", nil] show];
            
        }
        
    } failure:^(NSError *err) {
        
    }];
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.numberOfButtons == 2 && buttonIndex==0) {
        
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1118444326?mt=8"]];
}


//
////9.0前的方法，为了适配低版本 保留
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    return [WXApi handleOpenURL:url delegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return [WXApi handleOpenURL:url delegate:self];
//}
//
////9.0后的方法
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
//    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
//    return  [WXApi handleOpenURL:url delegate:self];
//}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
 
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
//            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
//            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{

    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {

        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {

        }];
    }
    

    if([url.host isEqualToString:@"pay"]){
        
        return [WXApi handleOpenURL:url delegate:self] ;
        
    }
    
    return YES;

}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"weixinNotice" object:nil];
    
}

-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付成功";
                break;
            case -1:
                payResoult = @"支付失败";
                break;
            case -2:
                payResoult = @"用户退出支付";
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败 retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
        
        
        NSNotification * notice = [NSNotification notificationWithName:@"weixinNotice" object:nil userInfo:@{@"payResoult":payResoult}];
        
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }
}



- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}



@end
