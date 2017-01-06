//
//  HLHttpClient.m
//  SmartCoach
//
//  Created by AlexYang on 15/8/6.
//  Copyright (c) 2015年 SmartCoach. All rights reserved.
//

#import "HLHttpClient.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
//#import "const.h"



/**第1步: 存储唯一实例*/
static HLHttpClient *_instance = nil;

/**
 *  错误信息返回
 */
static NSString *errorStr = nil;

@interface HLHttpClient ()
@property (nonatomic , strong) NSURLSessionConfiguration *config;
@property (nonatomic , strong) AFHTTPSessionManager *mgr;
@property (nonatomic , strong) NSURLSessionDataTask *dataTask;
@end

@implementation HLHttpClient

-(AFHTTPSessionManager *)mgr {
    if (_mgr == nil) {
        _mgr = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:self.config];
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"Internet Widgits Pty Ltd" ofType:@"cer"];
//        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"httpsSmartcoach" ofType:@"cer"];
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        NSSet *certSet =[NSSet setWithObject:certData];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey withPinnedCertificates:certSet];

        [securityPolicy setValidatesDomainName:NO];
        [securityPolicy setAllowInvalidCertificates:YES];
        _mgr.securityPolicy = securityPolicy;
    }
    
    return _mgr;
}

-(NSURLSessionConfiguration *)config {
    if (_config == nil) {
        _config = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    
    return _config;
}

/**第2步: 分配内存孔家时都会调用这个方法. 保证分配内存alloc时都相同*/
+(id)allocWithZone:(struct _NSZone *)zone{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

/**第3步: 保证init初始化时都相同*/
+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[HLHttpClient alloc] init];
    });
    return _instance;
}

/**第4步: 保证copy时都相同*/
-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}



/**
 *  状态网络是否通
 */
-(BOOL)isNetworkReachable
{
    return  [[AFNetworkReachabilityManager sharedManager] isReachable];
    
}

/**
 *  wifi状态
 */
-(BOOL)isNetworkReachableViaWifi
{
    return  [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
    
}

/**
 *  3G/4G/蜂窝网络状态
 */
-(BOOL)isNetworkReachableViaWWAN
{
    return  [[AFNetworkReachabilityManager sharedManager] isReachableViaWWAN];
    
}

/**
 *  开始网络监测
 */
-(void)startNetworkMonitor
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *reachabeMgr = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [reachabeMgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                HLLog(@"未知网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                HLLog(@"没有网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                HLLog(@"蜂窝数据网");
                if (![self isTokenValid]) {
                    __weak __typeof(self) weakSelf = self;
                    [self loginServerAutomaticSuccess:^(NSDictionary * responseObject) {
                        NSNumber *expire = responseObject[@"expire"];
                        NSTimeInterval expireStand = expire.doubleValue / 1000.0;
                        NSString *token = responseObject[@"token"];
                        [weakSelf updateToken:token AndExpireTime:@(expireStand)];
                    }];
                }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                if (![self isTokenValid]) {
                    __weak __typeof(self) weakSelf = self;
                    [self loginServerAutomaticSuccess:^(NSDictionary * responseObject) {
                        NSNumber *expire = responseObject[@"expire"];
                        NSTimeInterval expireStand = expire.doubleValue / 1000.0;
                        NSString *token = responseObject[@"token"];
                        [weakSelf updateToken:token AndExpireTime:@(expireStand)];
                    }];
                }
                HLLog(@"WIFI网络");
                break;
        }
    }];
    
    // 3.开始监控
    [reachabeMgr startMonitoring];
}

/**
 *  停止网络监测
 */
-(void)stopNetworkMonitor
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}


/**
 *  封装 AFN发送post请求
 *
 *  @param param   上传参数
 *  @param urlStr  请求接口
 *  @param success 成功回调
 *  @param fail    失败回调
 */
-(void)post:(NSString*)interface parameters:(NSMutableDictionary *)param success:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",PREFIX, interface];
    self.mgr.requestSerializer.timeoutInterval = 10.0;
    self.mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    self.mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    self.mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    //拼接参数
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:param];
    NSString *token = [[HLAccountManger sharedInstance] getToken];
    dict[@"token"] = token;
    NSMutableURLRequest *requst = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:dict error:nil];
    //发送请求
    NSURLSessionDataTask *dataTask = [self.mgr dataTaskWithRequest:requst completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (fail) {
                fail(error.localizedDescription);
            }
        }else {
            if (success) {
                success(responseObject);
            }
            
        }
    }];
    
    [dataTask resume];
    
}

@end
