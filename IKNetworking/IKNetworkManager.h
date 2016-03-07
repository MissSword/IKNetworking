//
//  IKNetworkManager.h
//  Leaf
//
//  Created by ikang on 16/2/24.
//  Copyright © 2016年 ikang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IKRequest;
@interface IKNetworkManager : NSObject

+ (instancetype)sharedManager;

- (void)addRequest:(IKRequest *)request;
- (void)cancelRequest:(IKRequest *)request;
- (void)cancelAllRequest;

@end
