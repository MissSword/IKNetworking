//
//  IKTestRequest.m
//  Leaf
//
//  Created by jianzhu on 16/2/25.
//  Copyright © 2016年 ikang. All rights reserved.
//

#import "IKTestRequest.h"

@implementation IKTestRequest

//返回请求方法
- (IKRequestMethod)requestMethod
{
    return IKRequestMethodGet;
}

//返回序列化类型
- (IKRequestSerializerType)requestSerializerType
{
    return IKRequestSerializerTypeJSON;
}

//返回请求的URL
- (NSString *)requestURL
{
    return @"";
}

//返回请求所需参数
- (id)requestArgument
{
    return @{};
}

//返回服务器地址
- (NSString *)baseURL
{
    return @"http://api.example.com";
}

//重写此方法 可以进行请求返回数据的处理
- (void)requestResultFilter
{
    
}


@end
