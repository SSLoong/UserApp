//
//  AFHttpTool.h
//  
//
//  Created by prefect on 16/3/4.
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

typedef NS_ENUM(NSInteger, RequestMethodType){
    RequestMethodTypePost = 1,
    RequestMethodTypeGet = 2

};



@interface AFHttpTool : NSObject



//生成32位不同数字字符串
+(NSString *)getSuiJINum;

//MD5加密
+(NSString *) md5: (NSString *) str ;


+(void) requestWihtMethod:(RequestMethodType)methodType
                     url : (NSString *)url
                   params:(NSDictionary *)params
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;



//上传图片
+(void) uploadPictureWithURL:(NSString *)url
                   nameArray:(NSArray *)names
                 imagesArray:(NSArray *)images
                      params:(NSDictionary *)params
                    progress:(void (^)(NSProgress *progress))progress
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure;



//手机号码登录
+(void)customerLoginPhone:(NSString *)phone
                 sms_code:(NSString *)sms_code
                  devices:(NSString *)devices
               devices_id:(NSString *)devices_id
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;
//获取登录验证码
+(void)getLoginCdoe:(NSString *)phone
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;

//修改登录密码
+(void)customerLoginpwdUpdate:(NSString *)cust_id
                      old_pwd:(NSString *)old_pwd
                      new_pwd:(NSString *)new_pwd
                     progress:(void (^)(NSProgress *progress))progress
                      success:(void (^)(id response))success
                      failure:(void (^)(NSError *err))failure;
//重置登录密码
+(void)customerLoginpwdReset:(NSString *)phone
                   login_pwd:(NSString *)login_pwd
                    sms_code:(NSString *)sms_code
                    progress:(void (^)(NSProgress *progress))progress
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure;
//客户登录
+(void)customerLogin:(NSString *)phone
           login_pwd:(NSString *)login_pwd
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure;

//客户默认地址
+(void)addressDefault:(NSString *)cust_id
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure;


//设置默认地址
+(void)addressDefaultSet:(NSString *)cust_id
                 addr_id:(NSString *)addr_id
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure;



//获取省
+(void) getProvinceList:(NSString *)query
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;



//获取城市
+(void) getCityList:(NSString *)province_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;

//获取县区
+(void) getCountyList:(NSString *)city_id
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure;


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
          failure:(void (^)(NSError *err))failure;
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
              failure:(void (^)(NSError *err))failure;
//发送注册验证码
+(void)sendsmsRegister:(NSString *)phone
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;
//个人中心
+(void)customerCenter:(NSString *)cust_id
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure;
//修改资料
+(void)customerDetailUpdate:(NSString *)cust_id
                       name:(NSString *)name
                    id_card:(NSString *)id_card
                      email:(NSString *)email
                   progress:(void (^)(NSProgress *progress))progress
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;
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
             failure:(void (^)(NSError *err))failure;
//客户地址列表
+(void)addressList:(NSString *)cust_id
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure;


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
             failure:(void (^)(NSError *err))failure;


//删除地址
+(void)addressDelete:(NSString *)cust_id
             addr_id:(NSString *)addr_id
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure;

//优惠卷列表
+(void)couponList:(NSString *)cust_id
             page:(NSInteger)page
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;




//发送短信登录验证码
+(void)sendsmsLogin:(NSString *)phone
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;
//发送找回密码验证码
+(void)sendsmsFindpwd:(NSString *)phone
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure;

//app欢迎页广告
+(void)appLauncher:(NSString *)platform
         site_code:(NSString *)site_code
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure;
//客户登录(手机号码快速登录)
+(void)customerLoginPhone:(NSString *)phone
                 sms_code:(NSString *)sms_code
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;
//客户地址详细
+(void)addressDetail:(NSString *)cust_id
             addr_id:(NSString *)addr_id
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure;

//app版本检查
+(void)appVersionCheck:(NSString *)platform
           app_version:(NSString *)app_version
              cer_type:(NSString *)cer_type
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;
//查询订单列表
+(void)orderQueryList:(NSString *)cust_id
               status:(NSString *)status
           pay_result:(NSString *)pay_result
                 page:(NSInteger)page
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure;

//订单详情
+(void) orderQueryDetail:(NSString *)order_id
                progress:(void (^)(NSProgress *))progress
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure;


//门店信息
+(void)storeDetail:(NSString *)store_id
           cust_id:(NSString *)cust_id
         longitude:(NSString *)longitude
          latitude:(NSString *)latitude
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure;
//查看附近门店
+(void)nearbyStore:(NSString *)site_code
         longitude:(NSString *)longitude
          latitude:(NSString *)latitude
              sort:(NSString *)sort
              page:(NSInteger)page
              rows:(NSInteger)rows
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure;
//附近特卖
+(void)nearbySpecial:(NSString *)site_code
           longitude:(NSString *)longitude
            latitude:(NSString *)latitude
                page:(NSInteger)page
                rows:(NSInteger)rows
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure;
//查看附近商品
+(void)nearbyGoods:(NSString *)site_code
         longitude:(NSString *)longitude
          latitude:(NSString *)latitude
              sort:(NSString *)sort
              page:(NSInteger)page
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure;

//优惠卷列表
+(void)couponList:(NSString *)cust_id
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;
//客户注册
+(void)customerRegister:(NSString *)phone
              login_pwd:(NSString *)login_pwd
               sms_code:(NSString *)sms_code
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;
//客户详细信息
+(void)customerDetail:(NSString *)cust_id
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure;

////修改客户资料
//+(void)customerDetailUpdate:(NSString *)cust_id
//                       name:(NSString *)name
//                    id_card:(NSString *)id_card
//                      email:(NSString *)email
//                   progress:(void (^)(NSProgress *progress))progress
//                    success:(void (^)(id response))success
//                    failure:(void (^)(NSError *err))failure;

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
              failure:(void (^)(NSError *err))failure;

//站点商品类别
+(void)siteCategory:(NSString *)site_code
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;

//我关注的店
+(void)customerFocusStore:(NSString *)site_code
                  cust_id:(NSString *)cust_id
                longitude:(NSString *)longitude
                 latitude:(NSString *)latitude
                     page:(NSInteger)page
                     rows:(NSInteger)rows
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;
//添加我关注的店
+(void)customerFocusStoreAdd:(NSString *)site_code
                     cust_id:(NSString *)cust_id
                    store_id:(NSString *)store_id
                    progress:(void (^)(NSProgress *progress))progress
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure;

//删除我关注的店
+(void)customerFocusStoreDelete:(NSString *)cust_id
                       store_id:(NSString *)store_ids
                       progress:(void (^)(NSProgress *progress))progress
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure;

//客户消息列表
+(void)customerMsg:(NSString *)cust_id
              page:(NSInteger)page
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure;

//客户消息已读
+(void)customerMsgRead:(NSString *)msg_id
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;
//删除客户消息
+(void)customerMsgDelete:(NSString *)msg_id
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure;
//获取站点代码
+(void)siteCode:(NSString *)city_code
       progress:(void (^)(NSProgress *progress))progress
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure;
//站点商品品牌
+(void)siteCategoryBrand:(NSString *)city_code
             category_id:(NSString *)category_id
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure;
//站点商品
+(void)siteCategoryBrandGoods:(NSString *)city_code
                     brand_id:(NSString *)brand_id
                    longitude:(NSString *)longitude
                     latitude:(NSString *)latitude
                     progress:(void (^)(NSProgress *progress))progress
                      success:(void (^)(id response))success
                      failure:(void (^)(NSError *err))failure;

//站点所有商品类别品牌
+(void)siteGoods:(NSString *)site_code
        progress:(void (^)(NSProgress *progress))progress
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;


//站点搜索
+(void)siteSearch:(NSString *)site_code
         keywords:(NSString *)keywords
             page:(NSInteger)page
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;

//商品在售门店
+(void)goodsStores:(NSString *)site_code
          goods_id:(NSString *)goods_id
              page:(NSInteger)page
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure;




#pragma mark - 搜索

//商品详情
+(void)goodsDetail:(NSString *)sg_id
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure;











//门店热销
+(void)goodsList:(NSString *)store_id
            page:(NSInteger)page
        progress:(void (^)(NSProgress *progress))progress
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;
//门店店长推荐商品
+(void)storeRecommend:(NSString *)store_id
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure;


//门店特卖
+(void)storeSpecialList:(NSString *)store_id
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;


//门店售卖商品品牌分类
+(void)storeBrand:(NSString *)store_id
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;


//门店热卖商品
+(void)storeHotsale:(NSString *)store_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;


//门店商品根据品牌查询
+(void)storeBrandGoods:(NSString *)store_id
              brand_id:(NSString *)brand_id
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;



//专场详情
+(void)specialDetail:(NSString *)special_id
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure;

//专场商品
+(void)specialGoods:(NSString *)special_id
           store_id:(NSString *)store_id
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure;

//添加购物车
+(void)addCart:(NSString *)cust_id
      store_id:(NSString *)store_id
    special_id:(NSString *)special_id
         sg_id:(NSString *)sg_id
       buy_num:(NSString *)buy_num
      progress:(void (^)(NSProgress *progress))progress
       success:(void (^)(id response))success
       failure:(void (^)(NSError *err))failure;




//购物车详情
+(void)cartDetail:(NSString *)cust_id
         store_id:(NSString *)store_id
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;







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
      receive_type:(NSString *)receive_type     //收货方式  1自提 2门店配送
           addr_id:(NSString *)addr_id          //收货ID
      receive_time:(NSString *)receive_time     //收货时间
              memo:(NSString *)memo             //备注
       pay_channel:(NSString *)pay_channel      //支付方式  weixin/alipay
         coupon_id:(NSString *)coupon_id        //优惠券id
          generals:(NSDictionary *)generals     //普通商品
          specials:(NSDictionary *)specials     //专场商品
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure;



//扫二维码购物车
+(void)cartQrcode:(NSString *)cust_id
          cart_id:(NSString *)cart_id
       devices_id:(NSString *)devices_id
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;


//扫码获取门店优惠卷
+(void)storeScan:(NSString *)store_id
         cust_id:(NSString *)cust_id
        progress:(void (^)(NSProgress *progress))progress
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;


//店铺优惠券
+(void)couponStore:(NSString *)cust_id
          store_id:(NSString *)store_id
              page:(NSInteger)page
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure;


//店铺可用优惠券
+(void)storeCoupon:(NSString *)cust_id
          store_id:(NSString *)store_id
        devices_id:(NSString *)devices_id //设备id
          generals:(NSDictionary *)generals
          specials:(NSDictionary *)specials
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;


//店铺订单列表
+(void)storeOrder:(NSString *)cust_id
         store_id:(NSString *)store_id
             page:(NSInteger)page
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;


//确认订单
+(void)orderConfirm:(NSString *)order_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;


//重新付款-验证订单状态
+(void)orderRepay:(NSString *)order_id
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;

//改变付款方式
+(void)orderChangePaychanel:(NSString *)pay_channel
                   order_id:(NSString *)order_id
                   progress:(void (^)(NSProgress *progress))progress
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;


//分享订单
+(void)orderShare:(NSString *)order_id
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;





//支付宝 支付签名
+(void)orderSignAlipay:(NSString *)order_id
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;


//微信支付签名
+(void)orderSignWeixin:(NSString *)order_id
            devices_id:(NSString *)devices_id
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;

//检查版本
+(void)appVersion:(NSString *)platform
      app_version:(NSString *)app_version
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;

@end
