
#import "AFHttpTool.h"
#import "AFNetworking.h"
#import "SecurityUtil.h"
#import "UserApp.h"

@implementation AFHttpTool


+(NSString *)getSuiJINum{

    NSMutableString *nubStr = [NSMutableString string];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    NSString *temp = nil;
    for(int i =0; i < [timeString length]; i++)
    {
        temp = [timeString substringWithRange:NSMakeRange(i, 1)];
        if(![temp isEqualToString:@"."]){
            
            [nubStr appendFormat:@"%@",temp];
            [nubStr appendFormat:@"%@",temp];
            
        }
    }

    return [NSString stringWithFormat:@"?req_no=%@",[SecurityUtil encryptAESData:nubStr]];;

}

+(NSString *) md5: (NSString *) str
{
    const char *cStr = [str UTF8String];

    unsigned char result[16];

    CC_MD5( cStr, strlen(cStr), result );
    
    return [NSString stringWithFormat:

            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
    
            result[0], result[1], result[2], result[3],

            result[4], result[5], result[6], result[7],

            result[8], result[9], result[10], result[11],
  
            result[12], result[13], result[14], result[15]];

}


+(void)requestWihtMethod:(RequestMethodType)methodType
                     url:(NSString *)url
                  params:(NSDictionary *)params
                progress:(void (^)(NSProgress *))progress
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure
{
    
    

    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",SITE_SERVER,url,[AFHttpTool getSuiJINum]];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    sessionManager.requestSerializer.timeoutInterval=30.0f;
    
    sessionManager.requestSerializer    = [AFHTTPRequestSerializer serializer];
    
    sessionManager.responseSerializer   = [AFHTTPResponseSerializer serializer];

    NSString *jiaMiParams = [SecurityUtil encryptAESData:[params mj_JSONString]];
    
    switch (methodType) {
            
        case RequestMethodTypeGet:
        {
            
            [sessionManager GET:urlString parameters:jiaMiParams progress:^(NSProgress *downloadProgress) {
                
                if (progress) {
                    progress(downloadProgress);
                }
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSDictionary *dicObject = [[SecurityUtil decryptAESHex:[responseObject mj_JSONString]] mj_JSONObject];
                
                if (success) {
                    success(dicObject);
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                if (failure) {
                    failure(error);
                }
                
            }];
            
        }
            break;
        case RequestMethodTypePost:
        {
            
            [sessionManager POST:urlString parameters:jiaMiParams progress:^(NSProgress * _Nonnull uploadProgress) {
                
                if (progress) {
                    progress(uploadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                NSDictionary *dicObject = [[SecurityUtil decryptAESHex:[responseObject mj_JSONString]] mj_JSONObject];
                
                if (success) {
                    success(dicObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (failure) {
                    failure(error);
                }
                
            }];
            
        }
            break;
        default:
            break;
    }
}



+(void) uploadPictureWithURL:(NSString *)url
                   nameArray:(NSArray *)names
                 imagesArray:(NSArray *)images
                      params:(NSDictionary *)params
                    progress:(void (^)(NSProgress *progress))progress
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure{

    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    sessionManager.requestSerializer.timeoutInterval=30.0f;

    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",SITE_SERVER,url,[AFHttpTool getSuiJINum]];

    [sessionManager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
        int i = 0;

        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:date];
        
        for (UIImage *image in images) {
            
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
            
            NSData *imageData;
            
            imageData = UIImageJPEGRepresentation(image, 1.0f);
            
            [formData appendPartWithFileData:imageData name:names[i] fileName:fileName mimeType:@"image/jpg/png/jpeg"];
            
            i++;
        }
    
        } progress:^(NSProgress * _Nonnull uploadProgress) {
    
            if (progress) {
                progress(uploadProgress);
            }
    
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
            if (success) {
                success(responseObject);
            }
    
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
            if (failure) {
                failure(error);
            }
        }];
}

#pragma mark - C端

//手机号码登录
+(void)customerLoginPhone:(NSString *)phone
                 sms_code:(NSString *)sms_code
                  devices:(NSString *)devices
               devices_id:(NSString *)devices_id
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure{
    
    NSString * longi = Longitude;
    NSString * lati = Latitude;
    if (longi == nil) {
        longi = @"0.0";
    }
    if (lati == nil) {
        lati = @"0.0";
    }
    
    NSDictionary *params = @{@"phone":phone,@"sms_code":sms_code,@"devices":devices,@"devices_id":devices_id,
                             @"longitude":longi,
                             @"latitude":lati};
    WYBLog(@"%@",params);
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/customer/login/phone"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
    
}
//获取登录验证码
+(void)getLoginCdoe:(NSString *)phone
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"phone":phone};
    
    WYBLog(@"%@",params);
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/sendsms/login"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
    
}



//修改登录密码
+(void)customerLoginpwdUpdate:(NSString *)cust_id
                      old_pwd:(NSString *)old_pwd
                      new_pwd:(NSString *)new_pwd
                     progress:(void (^)(NSProgress *progress))progress
                      success:(void (^)(id response))success
                      failure:(void (^)(NSError *err))failure{
    
    NSString *old = [AFHttpTool md5:old_pwd];
    NSString *new = [AFHttpTool md5:new_pwd];
    NSDictionary *params = @{@"cust_id":cust_id,@"old_pwd":old,@"new_pwd":new};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/customer/loginpwd/update"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}

//重置登录密码
+(void)customerLoginpwdReset:(NSString *)phone
                   login_pwd:(NSString *)login_pwd
                    sms_code:(NSString *)sms_code
                    progress:(void (^)(NSProgress *progress))progress
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure{
        NSString *pwd = [AFHttpTool md5:login_pwd];
    NSDictionary *params = @{@"phone":phone,@"login_pwd":pwd,@"sms_code":sms_code};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/customer/loginpwd/reset"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}

//客户登录
+(void)customerLogin:(NSString *)phone
           login_pwd:(NSString *)login_pwd
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure{
    
    NSString *pwd = [AFHttpTool md5:login_pwd];
    NSDictionary *params = @{@"phone":phone,@"login_pwd":pwd};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/customer/login"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}
//客户默认地址
+(void)addressDefault:(NSString *)cust_id
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"cust_id":cust_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/address/default"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}
//设置默认地址
+(void)addressDefaultSet:(NSString *)cust_id
                 addr_id:(NSString *)addr_id
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"cust_id":cust_id,@"addr_id":addr_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/address/default/set"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}




+(void)getProvinceList:(NSString *)query
              progress:(void (^)(NSProgress *))progress
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"query":query};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/address/province"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


+(void)getCityList:(NSString *)province_id
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"province_id":province_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/address/province/city"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


+(void)getCountyList:(NSString *)city_id
            progress:(void (^)(NSProgress *))progress
             success:(void (^)(id))success
             failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"city_id":city_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/address/province/city/area"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}









//app建议
+(void)appSuggest:(NSString *)cust_id
          contact:(NSString *)contact
          content:(NSString *)content
          devices:(NSString *)devices
       devices_id:(NSString *)devices_id
         platform:(NSString *)platform
       os_version:(NSString *)os_version
      app_version:(NSString *)app_version
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"cust_id":cust_id,@"contact":contact,@"content":content,@"devices":devices,@"devices_id":devices_id,@"platform":platform,@"os_version":os_version,@"app_version":app_version};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/app/suggest"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
    
}
//活跃记录
+(void)customerActive:(NSString *)cust_id
             latitude:(NSString *)latitude
            longitude:(NSString *)longitude
              devices:(NSString *)devices
           devices_id:(NSString *)devices_id
             platform:(NSString *)platform
           os_version:(NSString *)os_version
          app_version:(NSString *)app_version
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"cust_id":cust_id,@"latitude":latitude,@"longitude":longitude,@"devices":devices,@"devices_id":devices_id,@"platform":platform,@"os_version":os_version,@"app_version":app_version};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/customer/active"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
    
}

//发送注册验证码
+(void)sendsmsRegister:(NSString *)phone
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"phone":phone};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/sendsms/register"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
    
}

//个人中心
+(void)customerCenter:(NSString *)cust_id
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"cust_id":cust_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/customer/center"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
    
}
//修改资料
+(void)customerDetailUpdate:(NSString *)cust_id
                       name:(NSString *)name
                    id_card:(NSString *)id_card
                      email:(NSString *)email
                   progress:(void (^)(NSProgress *progress))progress
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"cust_id":cust_id,@"name":name,@"id_card":id_card,@"email":email};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/customer/detail/update"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}
//新增地址
+(void)addressInsert:(NSString *)cust_id
                 sex:(NSString *)sex
               phone:(NSString *)phone
            province:(NSString *)province
                city:(NSString *)city
                area:(NSString *)area
             address:(NSString *)address
            receiver:(NSString *)receiver
           site_code:(NSString *)site_code
          is_default:(NSInteger)is_default
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure{
    
    NSString *isDefault = [NSString stringWithFormat:@"%ld",(long)is_default];
    
    NSDictionary *params = @{@"cust_id":cust_id,@"sex":sex,@"phone":phone,@"province":province,@"city":city,@"area":area,@"address":address,@"receiver":receiver,@"site_code":site_code,@"is_default":isDefault};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/address/insert"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}

//客户地址列表
+(void)addressList:(NSString *)cust_id
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"cust_id":cust_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/address/list"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}



//更新地址
+(void)addressUpdate:(NSString *)cust_id
             addr_id:(NSString *)addr_id
                 sex:(NSString *)sex
               phone:(NSString *)phone
            province:(NSString *)province
                city:(NSString *)city
                area:(NSString *)area
             address:(NSString *)address
           site_code:(NSString *)site_code
            receiver:(NSString *)receiver
          is_default:(NSInteger)is_default
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure{
    
    NSString *isDefault = [NSString stringWithFormat:@"%ld",(long)is_default];
    
    NSDictionary *params = @{@"cust_id":cust_id,@"addr_id":addr_id,@"sex":sex,@"phone":phone,@"province":province,@"city":city,@"area":area,@"address":address,@"receiver":receiver,@"site_code":site_code,@"is_default":isDefault};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/address/update"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}




//删除地址
+(void)addressDelete:(NSString *)cust_id
             addr_id:(NSString *)addr_id
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"cust_id":cust_id,@"addr_id":addr_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/address/delete"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}


//优惠卷列表
+(void)couponList:(NSString *)cust_id
             page:(NSInteger)page
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure{
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"cust_id":cust_id,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/coupon/list"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}








//发送短信登录验证码
+(void)sendsmsLogin:(NSString *)phone
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"phone":phone};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/sendsms/login"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}
//发送找回密码验证码
+(void)sendsmsFindpwd:(NSString *)phone
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"phone":phone};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/sendsms/findpwd"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}

//app欢迎页广告
+(void)appLauncher:(NSString *)platform
         site_code:(NSString *)site_code
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"platform":platform,@"site_code":site_code};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/app/launcher"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}

//客户登录(手机号码快速登录)
+(void)customerLoginPhone:(NSString *)phone
                 sms_code:(NSString *)sms_code
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"phone":phone,@"sms_code":sms_code};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/customer/login/phone"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}

//客户地址详细
+(void)addressDetail:(NSString *)cust_id
             addr_id:(NSString *)addr_id
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"cust_id":cust_id,@"addr_id":addr_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/address/detail"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}



//app版本检查
+(void)appVersionCheck:(NSString *)platform
           app_version:(NSString *)app_version
              cer_type:(NSString *)cer_type
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"platform":platform,@"app_version":app_version,@"cer_type":cer_type};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/app/version/check"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}

//查询订单列表
+(void)orderQueryList:(NSString *)cust_id
               status:(NSString *)status
           pay_result:(NSString *)pay_result
                 page:(NSInteger)page
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure{
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"cust_id":cust_id,@"cust_id":cust_id,@"pay_result":pay_result,@"status":status,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/query/list"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


//订单详情
+(void) orderQueryDetail:(NSString *)order_id
                progress:(void (^)(NSProgress *))progress
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure{
    
    NSDictionary *params=@{@"order_id":order_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/query/detail"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}


//门店信息
+(void)storeDetail:(NSString *)store_id
           cust_id:(NSString *)cust_id
         longitude:(NSString *)longitude
          latitude:(NSString *)latitude
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"store_id":store_id,@"cust_id":cust_id,@"longitude":longitude,@"latitude":latitude};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/detail"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}
//查看附近门店
+(void)nearbyStore:(NSString *)site_code
         longitude:(NSString *)longitude
          latitude:(NSString *)latitude
              sort:(NSString *)sort
              page:(NSInteger)page
              rows:(NSInteger)rows
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure{
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSString *rowsString = [NSString stringWithFormat:@"%ld",(long)rows];
    NSDictionary *params = @{@"site_code":site_code,@"longitude":longitude,@"latitude":latitude,@"sort":sort,@"page":pageString,@"rows":rowsString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/v2/nearby/store"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}



//附近特卖
+(void)nearbySpecial:(NSString *)site_code
           longitude:(NSString *)longitude
            latitude:(NSString *)latitude
                page:(NSInteger)page
                rows:(NSInteger)rows
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure{
    
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSString *rowsString = [NSString stringWithFormat:@"%ld",(long)rows];
    NSDictionary *params = @{@"site_code":site_code,@"longitude":longitude,@"latitude":latitude,@"page":pageString,@"rows":rowsString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/nearby/special"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}

//查看附近商品
+(void)nearbyGoods:(NSString *)site_code
         longitude:(NSString *)longitude
          latitude:(NSString *)latitude
              sort:(NSString *)sort
              page:(NSInteger)page
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure{
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"site_code":site_code,@"longitude":longitude,@"latitude":latitude,@"sort":sort,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/nearby/goods"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}

//优惠卷列表
+(void)couponList:(NSString *)cust_id
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"cust_id":cust_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/coupon/list"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}

//客户注册
+(void)customerRegister:(NSString *)phone
              login_pwd:(NSString *)login_pwd
               sms_code:(NSString *)sms_code
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure{
    NSString *pwd = [AFHttpTool md5:login_pwd];
    NSDictionary *params = @{@"phone":phone,@"login_pwd":pwd,@"sms_code":sms_code,@"mode":@"1"};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/customer/register"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}
//客户详细信息
+(void)customerDetail:(NSString *)cust_id
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"cust_id":cust_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/customer/detail"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
    
}
////修改客户资料
//+(void)customerDetailUpdate:(NSString *)cust_id
//                       name:(NSString *)name
//                    id_card:(NSString *)id_card
//                      email:(NSString *)email
//                   progress:(void (^)(NSProgress *progress))progress
//                    success:(void (^)(id response))success
//                    failure:(void (^)(NSError *err))failure{
//
//
//}

//客户活跃记录
+(void)cutsomerActive:(NSString *)cust_id
          app_version:(NSString *)app_version
           os_version:(NSString *)os_version
             platform:(NSString *)platform
              devices:(NSString *)devices
           devices_id:(NSString *)devices_id
            longitude:(NSString *)longitude
             latitude:(NSString *)latitude
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"cust_id":cust_id,@"app_version":app_version,@"os_version":os_version,@"platform":platform,@"platform":platform,@"devices":devices,@"devices_id":devices_id,@"longitude":longitude,@"latitude":latitude};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/cutsomer/active"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}

//站点商品类别
+(void)siteCategory:(NSString *)site_code
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"site_code":site_code};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/site/category"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}

//我关注的店
+(void)customerFocusStore:(NSString *)site_code
                  cust_id:(NSString *)cust_id
                longitude:(NSString *)longitude
                 latitude:(NSString *)latitude
                     page:(NSInteger)page
                     rows:(NSInteger)rows
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure{
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSString *rowsString = [NSString stringWithFormat:@"%ld",(long)rows];
    NSDictionary *params = @{@"site_code":site_code,@"cust_id":cust_id,@"longitude":longitude,@"latitude":latitude,@"page":pageString,@"rows":rowsString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/customer/focus/store"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}

//添加我关注的店
+(void)customerFocusStoreAdd:(NSString *)site_code
                     cust_id:(NSString *)cust_id
                    store_id:(NSString *)store_id
                    progress:(void (^)(NSProgress *progress))progress
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"site_code":site_code,@"cust_id":cust_id,@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/customer/focus/store/add"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}

//删除我关注的店
+(void)customerFocusStoreDelete:(NSString *)cust_id
                       store_id:(NSString *)store_ids
                       progress:(void (^)(NSProgress *progress))progress
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure{
    
    NSArray *array = [NSArray arrayWithObject:store_ids];
    NSDictionary *params = @{@"cust_id":cust_id,@"store_ids":array};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/customer/focus/store/delete"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}


//客户消息列表
+(void)customerMsg:(NSString *)cust_id
              page:(NSInteger)page
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure{
    
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"cust_id":cust_id,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/customer/msg"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}

//客户消息已读
+(void)customerMsgRead:(NSString *)msg_id
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"msg_id":msg_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/customer/msg/read"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}

//删除客户消息
+(void)customerMsgDelete:(NSString *)msg_id
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"msg_id":msg_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/customer/msg/delete"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}

//获取站点代码
+(void)siteCode:(NSString *)city_code
       progress:(void (^)(NSProgress *progress))progress
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure{
    
    
    if (!checkNull(city_code)) {
        city_code = @"";
    }
    
    NSDictionary *params = @{@"city_code":city_code};
   
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/site/code"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}

//站点商品品牌
+(void)siteCategoryBrand:(NSString *)city_code
             category_id:(NSString *)category_id
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"city_code":city_code,@"category_id":category_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/site/category/brand"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}
//站点商品
+(void)siteCategoryBrandGoods:(NSString *)city_code
                     brand_id:(NSString *)brand_id
                    longitude:(NSString *)longitude
                     latitude:(NSString *)latitude
                     progress:(void (^)(NSProgress *progress))progress
                      success:(void (^)(id response))success
                      failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"city_code":city_code,@"brand_id":brand_id,@"longitude":longitude,@"latitude":latitude};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/site/category/brand/goods"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}
//站点所有商品类别品牌
+(void)siteGoods:(NSString *)site_code
        progress:(void (^)(NSProgress *progress))progress
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"site_code":site_code};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/site/goods"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}

//站点搜索
+(void)siteSearch:(NSString *)site_code
         keywords:(NSString *)keywords
             page:(NSInteger)page
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure{

    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"site_code":site_code,@"keywords":keywords,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/site/search"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


//商品在售门店
+(void)goodsStores:(NSString *)site_code
          goods_id:(NSString *)goods_id
              page:(NSInteger)page
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure{

    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"site_code":site_code,@"goods_id":goods_id,@"page":pageString};
    
    //WYBLog(@"参数:%@",params);
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/stores"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}



//商品详情
+(void)goodsDetail:(NSString *)sg_id
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"sg_id":sg_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/detail"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}


//门店售卖商品品牌分类
+(void)storeBrand:(NSString *)store_id
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/brand"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}



//门店热销
+(void)goodsList:(NSString *)store_id
            page:(NSInteger)page
        progress:(void (^)(NSProgress *progress))progress
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure{
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"store_id":store_id,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/goods/list"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}

//门店店长推荐商品
+(void)storeRecommend:(NSString *)store_id
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/recommend"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}

//门店特卖
+(void)storeSpecialList:(NSString *)store_id
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"store_id":store_id,@"rows":@"2"};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/special/list"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}



//门店热卖商品
+(void)storeHotsale:(NSString *)store_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure{


    NSDictionary *params = @{@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/hotsale"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}



//门店商品根据品牌查询
+(void)storeBrandGoods:(NSString *)store_id
              brand_id:(NSString *)brand_id
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"store_id":store_id,@"brand_id":brand_id,@"rows":@"1000"};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/brand/goods"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}




//专场详情
+(void)specialDetail:(NSString *)special_id
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure{


    NSDictionary *params = @{@"special_id":special_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/special/detail"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}

//专场商品
+(void)specialGoods:(NSString *)special_id
           store_id:(NSString *)store_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"special_id":special_id,@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/special/goods"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


//添加购物车
+(void)addCart:(NSString *)cust_id
      store_id:(NSString *)store_id
    special_id:(NSString *)special_id
         sg_id:(NSString *)sg_id
       buy_num:(NSString *)buy_num
      progress:(void (^)(NSProgress *progress))progress
       success:(void (^)(id response))success
       failure:(void (^)(NSError *err))failure{


    NSDictionary *params = @{@"cust_id":cust_id,@"store_id":store_id,@"special_id":special_id,@"sg_id":sg_id,@"buy_num":buy_num};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/cart/add"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];


}



//购物车详情
+(void)cartDetail:(NSString *)cust_id
         store_id:(NSString *)store_id
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"cust_id":cust_id,@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/cart/detail"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}






//提交订单
+(void)orderSubmit:(NSString *)cust_id          //用户id
          store_id:(NSString *)store_id         //商户id
           cart_id:(NSString *)cart_id          //购物车ID
           devices:(NSString *)devices          //设备类型
        devices_id:(NSString *)devices_id       //设备id
          buy_type:(NSString *)buy_type         //购买方式
         site_code:(NSString *)site_code        //站点代码
          latitude:(NSString *)latitude         //经度
         longitude:(NSString *)longitude        //纬度
      receive_type:(NSString *)receive_type     //收货方式
           addr_id:(NSString *)addr_id          //收货ID
      receive_time:(NSString *)receive_time     //收货时间
              memo:(NSString *)memo             //备注
       pay_channel:(NSString *)pay_channel      //支付方式  weixin/alipay
         coupon_id:(NSString *)coupon_id        //优惠券id
          generals:(NSDictionary *)generals     //普通商品
          specials:(NSDictionary *)specials     //专场商品
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"cart_id":cart_id,@"cust_id":cust_id,@"store_id":store_id,@"devices":devices,@"devices_id":devices_id,@"buy_type":buy_type,@"site_code":site_code,@"latitude":latitude,@"longitude":longitude,@"receive_type":receive_type,@"addr_id":addr_id,@"receive_time":receive_time,@"memo":memo,@"pay_channel":pay_channel,@"coupon_id":coupon_id,@"generals":generals,@"specials":specials,};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/submit"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


//扫二维码购物车
+(void)cartQrcode:(NSString *)cust_id
          cart_id:(NSString *)cart_id
       devices_id:(NSString *)devices_id
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"cust_id":cust_id,@"cart_id":cart_id,@"devices_id":devices_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/cart/qrcode"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


//扫码获取门店优惠卷
+(void)storeScan:(NSString *)store_id
         cust_id:(NSString *)cust_id
        progress:(void (^)(NSProgress *progress))progress
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"cust_id":cust_id,@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/scan/coupon"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}



//店铺优惠券
+(void)couponStore:(NSString *)cust_id
          store_id:(NSString *)store_id
              page:(NSInteger)page
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure{
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"cust_id":cust_id,@"store_id":store_id,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/coupon/store"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}



//店铺可用优惠券
+(void)storeCoupon:(NSString *)cust_id
          store_id:(NSString *)store_id
        devices_id:(NSString *)devices_id //设备id
          generals:(NSDictionary *)generals
          specials:(NSDictionary *)specials
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"cust_id":cust_id,@"store_id":store_id,@"devices_id":devices_id,@"specials":specials,@"generals":generals};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/coupon"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


//店铺订单列表
+(void)storeOrder:(NSString *)cust_id
         store_id:(NSString *)store_id
             page:(NSInteger)page
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure{

    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"cust_id":cust_id,@"store_id":store_id,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/order"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


//确认订单
+(void)orderConfirm:(NSString *)order_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"order_id":order_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/confirm"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}

//重新付款-验证订单状态
+(void)orderRepay:(NSString *)order_id
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"order_id":order_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/repay"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}



//改变付款方式
+(void)orderChangePaychanel:(NSString *)pay_channel
                   order_id:(NSString *)order_id
                   progress:(void (^)(NSProgress *progress))progress
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"order_id":order_id,@"pay_channel":pay_channel};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/change/paychannel"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}


+(void)orderShare:(NSString *)order_id
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"order_id":order_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/share"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


//支付宝 支付签名
+(void)orderSignAlipay:(NSString *)order_id
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"order_id":order_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/sign/alipay"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


//微信支付签名
+(void)orderSignWeixin:(NSString *)order_id
            devices_id:(NSString *)devices_id
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"order_id":order_id,@"devices_id":devices_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/sign/weixin"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}

//检查版本
+(void)appVersion:(NSString *)platform
      app_version:(NSString *)app_version
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"platform":platform,@"app_version":app_version};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/app/version/check"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}



@end
