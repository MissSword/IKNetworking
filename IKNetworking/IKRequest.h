//
//  IKRequest.h
//  Leaf
//
//  Created by ikang on 16/2/24.
//  Copyright © 2016年 ikang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "IKNetworkManager.h"
#import "IKRequestTool.h"

typedef NS_ENUM(NSInteger , IKRequestMethod) {
    IKRequestMethodGet = 0,
    IKRequestMethodPost,
    IKRequestMethodHead,
    IKRequestMethodPut,
    IKRequestMethodDelete,
    IKRequestMethodPatch
};

typedef NS_ENUM(NSInteger , IKRequestSerializerType) {
    IKRequestSerializerTypeHTTP = 0,
    IKRequestSerializerTypeJSON
};

typedef NS_ENUM(NSInteger, IKNetworkDataCachePolicy) {
    IKNetworkDataCachePolicyNoNetUse = 0,  //没网的情况下使用缓存
    IKNetworkDataCachePolicyInValidUse,    //缓存有效期内使用缓存
    IKNetworkDataCachePolicyNerverUse      //从不使用缓存
};

typedef void(^AFConstructingBlock)(id<AFMultipartFormData>formData);
typedef void(^AFLoadProgressBlock)(NSProgress *progress);

@interface IKRequest : NSObject

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;

@property (nonatomic, strong) id responseJSONObject;

@property (nonatomic, strong) NSDictionary *errorInfo;

@property (nonatomic, readonly) NSInteger responseStatusCode;

@property (nonatomic, copy) void (^successCompletionBlock)(IKRequest *);

@property (nonatomic, copy) void (^failureCompletionBlock)(IKRequest *);

@property (nonatomic, strong) NSString *cacheIdentifier;

- (void)startWithCompletionBlockWithSuccess:(void(^)(IKRequest *request))success
                                    failure:(void(^)(IKRequest *request))failure;

- (void)requestWillStart;

- (void)start;

- (void)stop;

///是否拦截成功回调，可以在回调之前做相应处理
- (BOOL)isInterceptionResult;

///可以对请求返回数据进行处理
- (void)requestResultFilter;

- (void)clearCompletionBlock;

- (NSString *)requestURL;

- (NSString *)baseURL;

- (NSTimeInterval)requestTimeoutInterval;

- (IKNetworkDataCachePolicy)cachePolicy;

- (id)requestArgument;

- (IKRequestMethod)requestMethod;

- (NSDictionary *)requestHeaderFieldValueDictionry;

///默认返回IKRequestSerializerTypeHTTP，当POST JSON数据时重写此方法，并返回IKRequestSerializerTypeJSON
- (IKRequestSerializerType)requestSerializerType;

- (AFConstructingBlock)constructingBodyBlock;

- (AFLoadProgressBlock)loadProgressBlock;

@end
