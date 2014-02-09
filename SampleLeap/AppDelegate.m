//
//  AppDelegate.m
//  SampleLeap
//
//  Created by takao maeda on 2014/02/02.
//  Copyright (c) 2014年 前田 恭男. All rights reserved.
//

#import "AppDelegate.h"
#import "LeapSample.h"

@implementation AppDelegate

//LeapからのNotificationの為に変数として持っておくこと
@synthesize sample = _sample;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _sample=[[LeapSample alloc]init];
    [_sample run];
}

@end
