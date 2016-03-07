//
//  IKRequestTool.h
//  Leaf
//
//  Created by jianzhu on 16/2/25.
//  Copyright © 2016年 ikang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IKRequest.h"
#import "YTKKeyValueStore.h"
#import "IKNetworkConfig.h"

#define DEFAULT_CACHE_DB_NAME                   @"DEFAULT_CACHE_DB_NAME"
#define DEFAULT_CACHE_TABLE_NAME                @"DEFAULT_CACHE_TABLE_NAME"
#define DEFAULT_CACHE_TIME                      60 * 60

@interface IKRequestTool : NSObject

+ (NSString *)URLParametersStringFromParameters:(NSDictionary *)parameters;

+ (NSString *)URLString:(NSString *)URLString appendParameterString:(NSString *)parameterString;

+ (void)cacheResponseObjectWithRequest:(IKRequest *)request;

+ (id)getCacheWithRequest:(IKRequest *)request;

+ (BOOL)isConnectedToNetwork;

@end
