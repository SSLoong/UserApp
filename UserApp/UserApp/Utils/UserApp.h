//
//  UserApp.h
//  UserApp
//
//  Created by prefect on 16/4/11.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#ifndef UserApp_h
#define UserApp_h

#endif /* UserApp_h */
#define DEFAULTS [NSUserDefaults standardUserDefaults]
#define ShareApplicationDelegate [[UIApplication sharedApplication] delegate]



//#define SITE_SERVER @"http://10.211.55.117:8081/rest"
#define SITE_SERVER @"http://139.196.13.82:88/rest"
//#define SITE_SERVER @"http://api.appsjk.com/rest"


#define Cust_id [DEFAULTS objectForKey:@"cust_id"]
#define LoginPhone [DEFAULTS objectForKey:@"userName"]
#define SiteCode [DEFAULTS objectForKey:@"siteCode"]
#define Longitude [DEFAULTS objectForKey:@"longitude"]
#define Latitude [DEFAULTS objectForKey:@"latitude"]
#define IsLogin [DEFAULTS boolForKey:@"isLogin"]


#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height


#define UmengAppKey @"54866d3cfd98c5b466000906"
#define  KEY_USERNAME_PASSWORD @"api.appsjk.com"

#define AppBackgroundColor [UIColor colorWithHex:0xFD5B44]

#define AppBigFont [UIFont systemFontOfSize:15]
#define AppMediumFont [UIFont systemFontOfSize:13]
#define AppSmallFont [UIFont systemFontOfSize:11]










