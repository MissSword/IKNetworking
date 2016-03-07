//
//  IKNetworkConfig.m
//  Leaf
//
//  Created by ikang on 16/2/24.
//  Copyright © 2016年 ikang. All rights reserved.
//

#import "IKNetworkConfig.h"

@implementation IKNetworkConfig

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
