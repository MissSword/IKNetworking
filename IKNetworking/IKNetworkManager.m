//
//  IKNetworkManager.m
//  Leaf
//
//  Created by ikang on 16/2/24.
//  Copyright © 2016年 ikang. All rights reserved.
//

#import "IKNetworkManager.h"

#import "IKRequest.h"
#import "IKNetworkConfig.h"
#import "IKRequestTool.h"

@interface IKNetworkManager ()

@property (nonatomic, strong) NSMutableDictionary *requestRecord;
@property (nonatomic, strong) IKNetworkConfig *config;
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation IKNetworkManager

+ (instancetype)sharedManager
{
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        _requestRecord = [NSMutableDictionary dictionary];
        _config = [IKNetworkConfig sharedInstance];
        _manager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (void)addRequest:(IKRequest *)request
{
    BOOL isConnectedToNetwork = [IKRequestTool isConnectedToNetwork];
    if (isConnectedToNetwork == YES && [request cachePolicy] == IKNetworkDataCachePolicyNoNetUse) {
        id cacheData = [IKRequestTool getCacheWithRequest:request];
        if (cacheData) {
            request.responseJSONObject = cacheData;
            [request requestResultFilter];
            return;
        }
    }else if ([request cachePolicy] == IKNetworkDataCachePolicyInValidUse) {
        id cacheData = [IKRequestTool getCacheWithRequest:request];
        if (cacheData) {
            request.responseJSONObject = cacheData;
            [request requestResultFilter];
            if (request.successCompletionBlock) {
                request.successCompletionBlock(request);
            }
            return;
        }
    }
    
    NSString *URLString = nil;
    if ([request baseURL].length > 0) {
        URLString = [request baseURL];
    }else if([_config baseURL].length > 0){
        URLString = [_config baseURL];
    }else {
        NSLog(@"请配置baseURL");
    }
    
    if ([request requestURL].length > 0) {
        URLString = [URLString stringByAppendingString:[request requestURL]];
    }
    
    if ([request requestSerializerType] == IKRequestSerializerTypeJSON) {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }else if ([request requestSerializerType] == IKRequestSerializerTypeHTTP){
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    _manager.requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    NSDictionary *headerDictionary = [request requestHeaderFieldValueDictionry];
    if (headerDictionary != nil) {
        for (id httpHeaderField in headerDictionary.allKeys) {
            id value = headerDictionary[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [_manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            }else {
                NSLog(@"请求头 Key/Vale 必须为NSString类型");
            }
        }
    }
    
    switch ([request requestMethod]) {
        case IKRequestMethodGet:
        {
//            if ([request requestArgument]) {
//                NSString *parameterString = [IKRequestTool URLParametersStringFromParameters:[request requestArgument]];
//                URLString = [IKRequestTool URLString:URLString appendParameterString:parameterString];
//            }
            NSURLSessionDataTask *task = [_manager GET:URLString
                                            parameters:[request requestArgument]
                                              progress:[request loadProgressBlock]
                                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                   [self resultHandle:task responseObject:responseObject];
                                               }
                                               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                   [self failureHandle:task error:error];
                                                   
                                               }];
            request.dataTask = task;
        }
            break;
        case IKRequestMethodPost:
        {
            NSURLSessionDataTask *task = nil;
            if ([request requestSerializerType] == IKRequestSerializerTypeJSON) {
                task = [_manager POST:URLString
                           parameters:[request requestArgument]
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                  CACurrentMediaTime();
                                  NSLog(@"%f",CACurrentMediaTime());
                                  [self resultHandle:task responseObject:responseObject];
                              }
                              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  [self failureHandle:task error:error];
                              }];
            }else {
                task = [_manager POST:URLString
                           parameters:[request requestArgument]
            constructingBodyWithBlock:[request constructingBodyBlock]
                             progress:[request loadProgressBlock]
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                  [self resultHandle:task responseObject:responseObject];
                              }
                              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  [self failureHandle:task error:error];
                              }];
            }
            request.dataTask = task;
        }
            break;
        case IKRequestMethodHead:
        {
            NSURLSessionDataTask *task = [_manager HEAD:URLString
                                             parameters:[request requestArgument]
                                                success:^(NSURLSessionDataTask * _Nonnull task) {
                                                    [self resultHandle:task responseObject:nil];
                                                }
                                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                    [self failureHandle:task error:error];
                                                }];
            request.dataTask = task;
        }
            break;
        case IKRequestMethodPut:
        {
            NSURLSessionDataTask *task = [_manager PUT:URLString
                                            parameters:[request requestArgument]
                                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                   [self resultHandle:task responseObject:responseObject];
                                               }
                                               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                   [self failureHandle:task error:error];
                                               }];
            request.dataTask = task;
        }
            break;
        case IKRequestMethodDelete:
        {
            NSURLSessionDataTask *task = [_manager DELETE:URLString
                                               parameters:[request requestArgument]
                                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                      [self resultHandle:task responseObject:responseObject];
                                                  }
                                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                      [self failureHandle:task error:error];
                                                  }];
            request.dataTask = task;
        }
            break;
        case IKRequestMethodPatch:
        {
            NSURLSessionDataTask *task = [_manager PATCH:URLString
                                              parameters:[request requestArgument]
                                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                     [self resultHandle:task responseObject:responseObject];
                                                 }
                                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                     [self failureHandle:task error:error];
                                                 }];
            request.dataTask = task;
        }
            break;
            
        default:
            break;
    }
    [self addTask:request];
}

- (void)resultHandle:(NSURLSessionDataTask *)task responseObject:(id _Nullable)responseObject
{
    NSString *key = [NSString stringWithFormat:@"%lu",task.taskIdentifier];
    IKRequest *request = _requestRecord[key];
    NSLog(@"%@result:%@",[request class],responseObject);
    if ([request isInterceptionResult]) {
        [self cancelRequest:request];
        return ;
    }
    if (request) {
        request.responseJSONObject = responseObject;
        [request requestResultFilter];
        if (request.successCompletionBlock) {
            request.successCompletionBlock(request);
        }
        if ([request cachePolicy] == IKNetworkDataCachePolicyNoNetUse || [request cachePolicy] == IKNetworkDataCachePolicyInValidUse) {
            [IKRequestTool cacheResponseObjectWithRequest:request];
        }
    }
    [self cancelRequest:request];
}

- (void)failureHandle:(NSURLSessionDataTask *)task error:(NSError *)error
{
    NSString *key = [NSString stringWithFormat:@"%lu",task.taskIdentifier];
    IKRequest *request = _requestRecord[key];
    if (request) {
        request.errorInfo = [error userInfo];
        if (request.failureCompletionBlock) {
            request.failureCompletionBlock(request);
        }
    }
    [self cancelRequest:request];
}

- (void)cancelRequest:(IKRequest *)request
{
    [request clearCompletionBlock];
    NSURLSessionDataTask *task = request.dataTask;
    if (task.state == NSURLSessionTaskStateRunning) {
        [task cancel];
    }
    [self removeTask:request];
    NSLog(@"cancel request: %@",[request class]);
}

- (void)cancelAllRequest
{
    NSDictionary *record = [_requestRecord copy];
    for (NSString *key in record) {
        IKRequest *req = record[key];
        [req stop];
    }
}

- (void)addTask:(IKRequest *)request
{
    if (request.dataTask != nil) {
        NSString *key = [NSString stringWithFormat:@"%lu",request.dataTask.taskIdentifier];
        @synchronized(self) {
            _requestRecord[key] = request;
        }
        NSLog(@"add Request: %@",[request class]);
    }
}

- (void)removeTask:(IKRequest *)request
{
    NSString *key = [NSString stringWithFormat:@"%lu",request.dataTask.taskIdentifier];
    @synchronized(self) {
        [_requestRecord removeObjectForKey:key];
    }
}

@end
