//
//  IKNetworkConfig.h
//  Leaf
//
//  Created by ikang on 16/2/24.
//  Copyright © 2016年 ikang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IKNetworkConfig : NSObject

+ (instancetype)sharedInstance;

/**
 *  服务器地址
 */
@property (nonatomic, strong) NSString *baseURL;

/**
 *  缓存数据库名
 */
@property (nonatomic, strong) NSString *cacheDBName;

/**
 *  缓存有效期
 */
@property (nonatomic) NSTimeInterval cacheTime;



@end
