//
//  ViewController.m
//  IKRequestDemo
//
//  Created by jianzhu on 16/3/7.
//  Copyright © 2016年 ZXJ. All rights reserved.
//

#import "ViewController.h"
#import "IKTestRequest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    IKTestRequest *req = [[IKTestRequest alloc] init];
    [req startWithCompletionBlockWithSuccess:^(IKRequest *request) {
        NSLog(@"请求成功的回调");
    } failure:^(IKRequest *request) {
        NSLog(@"请求失败的回调");
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
