//
//  AppDelegate.h
//  SampleLeap
//
//  Created by takao maeda on 2014/02/02.
//  Copyright (c) 2014年 前田 恭男. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LeapSample;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong, readwrite)LeapSample *sample;

@end
