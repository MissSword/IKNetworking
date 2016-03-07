//
//  IKRequestTool.m
//  Leaf
//
//  Created by jianzhu on 16/2/25.
//  Copyright © 2016年 ikang. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <commoncrypto/commonhmac.h>
#import <systemconfiguration/systemconfiguration.h>
#import <netdb.h>
#import "IKRequestTool.h"


@implementation IKRequestTool

+ (NSString *)URLString:(NSString *)URLString appendParameterString:(NSString *)parameterString
{
    NSAssert(URLString, @"URLString不能为空");
    NSAssert(parameterString, @"parameterString不能为空");
    NSString *fileredURL = URLString;
    if ([URLString rangeOfString:@"?"].location != NSNotFound) {
        fileredURL = [URLString stringByAppendingString:parameterString];
    }else {
        fileredURL = [URLString stringByAppendingFormat:@"?%@",[parameterString substringFromIndex:1]];
    }
    return fileredURL;
}

+ (NSString *)URLParametersStringFromParameters:(NSDictionary *)parameters
{
    NSMutableString *URLParameterString = [[NSMutableString alloc] initWithString:@""];
    if (parameters && parameters.count > 0) {
        for (NSString *key in parameters) {
            NSString *value = parameters[key];
            value = [NSString stringWithFormat:@"%@",value];
            value = [self URLEncode:value];
            [URLParameterString appendFormat:@"&%@=%@",key,value] ;
        }
    }
    return URLParameterString;
}

+ (void)cacheResponseObjectWithRequest:(IKRequest *)request
{
    NSString *dbName = [[IKNetworkConfig sharedInstance] cacheDBName];
    if (dbName.length == 0) {
        dbName = DEFAULT_CACHE_DB_NAME;
    }
    NSString *key = [self md5StringFromString:request.cacheIdentifier];
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:dbName];
    [store createTableWithName:DEFAULT_CACHE_TABLE_NAME];
    [store putObject:request.responseJSONObject withId:key intoTable:DEFAULT_CACHE_TABLE_NAME];
}

+ (id)getCacheWithRequest:(IKRequest *)request
{
    NSString *dbName = [[IKNetworkConfig sharedInstance] cacheDBName];
    if (dbName.length == 0) {
        dbName = DEFAULT_CACHE_DB_NAME;
    }
    NSString *cacheKey = [self md5StringFromString:request.cacheIdentifier];
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:dbName];
    YTKKeyValueItem *item = [store getYTKKeyValueItemById:cacheKey fromTable:DEFAULT_CACHE_TABLE_NAME];
    NSDate *cacheDate = item.createdTime;
    NSTimeInterval timeInterVal = [cacheDate timeIntervalSinceNow];
    if (-timeInterVal < [[IKNetworkConfig sharedInstance] cacheTime]) {
        return nil;
    }
    return item.itemObject;
}

+ (NSString *)URLEncode:(NSString *)string
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, CFSTR("."), CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
}

+ (NSString *)md5StringFromString:(NSString *)string {
    if(string == nil || [string length] == 0)
        return nil;
    const char *value = [string UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

+ (BOOL)isConnectedToNetwork
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

@end
