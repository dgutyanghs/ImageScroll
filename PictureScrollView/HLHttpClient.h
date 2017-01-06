//
//  HLHttpClient.h
//  SmartCoach
//
//  Created by AlexYang on 15/8/6.
//  Copyright (c) 2015年 SmartCoach. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface HLHttpClient : NSObject


/**
 *  单例
 */
+(instancetype)sharedInstance;

-(void)startNetworkMonitor;
-(void)stopNetworkMonitor;
-(BOOL)isNetworkReachable;
-(BOOL)isNetworkReachableViaWifi;
-(BOOL)isNetworkReachableViaWWAN;


-(void)post:(NSString*)interface parameters:(NSMutableDictionary *)param success:(void (^)(id responseObject))success fail:(void (^)(NSString * error))fail;


@end
