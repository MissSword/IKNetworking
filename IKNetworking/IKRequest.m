//
//  IKRequest.m
//  Leaf
//
//  Created by ikang on 16/2/24.
//  Copyright © 2016年 ikang. All rights reserved.
//

#import "IKRequest.h"

@implementation IKRequest

- (NSString *)requestURL
{
    return @"";
}

- (NSString *)baseURL
{
    return @"";
}

- (NSTimeInterval)requestTimeoutInterval
{
    return 60;
}

- (IKNetworkDataCachePolicy)cachePolicy
{
    return IKNetworkDataCachePolicyInValidUse;
}

- (id)requestArgument
{
    return nil;
}

- (IKRequestMethod)requestMethod;
{
    return IKRequestMethodGet;
}

- (IKRequestSerializerType)requestSerializerType
{
    return IKRequestSerializerTypeHTTP;
}

- (NSDictionary *)requestHeaderFieldValueDictionry
{
    return nil;
}

- (void)clearCompletionBlock
{
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (void)requestWillStart
{
    
}

- (void)start
{
    [self requestWillStart];
    [[IKNetworkManager sharedManager] addRequest:self];
}

- (void)stop
{
    [[IKNetworkManager sharedManager] cancelRequest:self];
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(IKRequest *))success failure:(void (^)(IKRequest *))failure
{
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
    [self start];
}

- (BOOL)isInterceptionResult
{
    return NO;
}

- (void)requestResultFilter
{
    
}

- (NSString *)cacheIdentifier
{
    return [NSString stringWithFormat:@"%@%@%@",self.baseURL,self.requestURL,[IKRequestTool URLParametersStringFromParameters:[self requestArgument]]];
}

- (AFConstructingBlock)constructingBodyBlock
{
    return NULL;
}

- (AFLoadProgressBlock)loadProgressBlock
{
    return NULL;
}


@end
