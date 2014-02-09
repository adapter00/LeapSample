//
//  LeapSample.m
//  SampleLeap
//
//  Created by takao maeda on 2014/02/02.
//  Copyright (c) 2014年 前田 恭男. All rights reserved.
//

#import "LeapSample.h"

@interface LeapSample ()

@property LeapController *controller;

@end

@implementation LeapSample

//ここでLeapMotionとの接続を完了させておく(基本はNSNotificationから通知されてくる)
-(void)run{
    _controller=[[LeapController alloc] init];
    [_controller addListener:self];
    NSLog(@"LeapMotionSetting完了♪(・ω<)");
}

-(void)onInit:(NSNotification *)notification{
    NSLog(@"LeapMotionDelegateの登録が完了したよ");
}
-(void)onConnect:(NSNotification *)notification{
    NSLog(@"LeapMotion接続が完了したよ");
}
-(void)onDisconnect:(NSNotification *)notification{
    NSLog(@"LeapMotionとの接続を解除したよ");
}
-(void)onExit:(NSNotification *)notification{
    NSLog(@"LeapMotionから離脱");
}
-(void)onFrame:(NSNotification *)notification{
    NSLog(@"LeapMotionからの情報を更新");
}



@end
