//
//  LeapSample.m
//  SampleLeap
//
//  Created by ; maeda on 2014/02/02.
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
    LeapController *aController= (LeapController *)[notification object];
    [aController enableGesture:LEAP_GESTURE_TYPE_CIRCLE enable:YES];
    [aController enableGesture:LEAP_GESTURE_TYPE_KEY_TAP enable:YES];
    [aController enableGesture:LEAP_GESTURE_TYPE_SCREEN_TAP enable:YES];
    [aController enableGesture:LEAP_GESTURE_TYPE_SWIPE enable:YES];
    
    NSLog(@"LeapMotion接続が完了したよ");
}

-(void)onDisconnect:(NSNotification *)notification{
    NSLog(@"LeapMotionとの接続を解除したよ");
}

-(void)onExit:(NSNotification *)notification{
    NSLog(@"LeapMotionから離脱");
}


-(void)onFrame:(NSNotification *)notification{
    LeapController *aController = (LeapController *)[notification object];
    LeapFrame *frame            = [aController frame:0];
    if([frame hands] !=0){
        //最初に認識した手を取得する
        LeapHand *hand=[[frame hands] objectAtIndex:0];
        NSLog(@"Frame id: %lld, timestamp: %lld, hands: %ld, fingers: %ld, tools: %ld",
              [frame id], [frame timestamp], [[frame hands] count],
              [[frame fingers] count], [[frame tools] count]);
        NSArray *fingers=[hand fingers];
        if([fingers count] != 0){
            //指先の平均的な位置を計算する
            LeapVector *avgPos =[[LeapVector alloc] init];
            for(int i= 0 ; i<[fingers count]; i++){
                LeapFinger *finger =[fingers objectAtIndex:i];
                avgPos =[avgPos plus:[finger tipPosition]];
            }
            avgPos=[avgPos divide:[fingers count]];
            NSLog(@"Hand has %ld fingers, average finger tip position %@",
                  [fingers count], avgPos);
        }
        NSLog(@"Hand sphere radius : %f ,palm position : %@", [hand sphereRadius],[hand palmPosition]);
        const LeapVector *normal=[hand palmNormal];
        const LeapVector *direction=[hand direction];
        //手の傾斜、起伏、偏揺れ角を計算する
        NSLog(@"Hand Pitch %f degrees, roll: %f degrees, yaw :%f degrees \n",
              [direction pitch]* LEAP_RAD_TO_DEG,
              [normal roll] * LEAP_RAD_TO_DEG,
              [direction yaw] * LEAP_RAD_TO_DEG);
    }
    NSArray *gestures= [frame gestures:nil];
    for(int g = 0; g<[gestures count];g++){
        LeapGesture *gesture = [gestures objectAtIndex:g];
        switch (gesture.type) {
            case LEAP_GESTURE_TYPE_CIRCLE:{
                LeapCircleGesture *circleGesture = (LeapCircleGesture *)gesture;
                float sweptAngle = 0;
                if(circleGesture.state != LEAP_GESTURE_STATE_START){
                    LeapCircleGesture *previousUpdate= (LeapCircleGesture *)[[aController frame:1]gesture:gesture.id];
                    sweptAngle = (circleGesture.progress - previousUpdate.progress) * 2 * LEAP_PI;
                break;
                    NSLog(@"Circle Id : %d,%@,progress %f ,radius %f , angle : %f degrees ", circleGesture.id,[self stringForState:gesture.state],circleGesture.progress,circleGesture.radius,sweptAngle * LEAP_RAD_TO_DEG);
                    break;
                }
            }
            case LEAP_GESTURE_TYPE_SWIPE:{
                LeapSwipeGesture *swipeGesture = (LeapSwipeGesture *)gesture;
                NSLog(@"Swipe id : %d , posotion : %@ ,direction L %@ ,speed : %f",swipeGesture.id,swipeGesture.position,swipeGesture.direction,swipeGesture.speed);
                break;
            }
            case LEAP_GESTURE_TYPE_KEY_TAP:{
                LeapKeyTapGesture *keyTapGesrure = (LeapKeyTapGesture *)gesture;
                NSLog(@"Key Tap id : %d. %@ , position : %@ ,direction : %@",keyTapGesrure.id,[self stringForState:keyTapGesrure.state],keyTapGesrure.position,keyTapGesrure.direction);
                break;
            }
            case LEAP_GESTURE_TYPE_SCREEN_TAP:{
                LeapScreenTapGesture *screenTapGesture = (LeapScreenTapGesture *)gesture;
                NSLog(@"Screen Tap id : %d , %@ ,posotion : %@,direction : %@",screenTapGesture.id,[self stringForState:screenTapGesture.state],screenTapGesture.position,screenTapGesture.direction);
                break;
            }
            default:
                NSLog(@"Unknown gesture Type");
                break;
            }
        }
}
-(NSString *)stringForState:(LeapGestureState)state
{
    switch (state) {
        case LEAP_GESTURE_STATE_INVALID:
            return @"STATE_INVALID";
        case LEAP_GESTURE_STATE_START:
            return @"STATE_START";
        case LEAP_GESTURE_STATE_UPDATE:
            return @"STATE_UPDATED";
        case LEAP_GESTURE_STATE_STOP:
            return @"STATE_STOP";
        default:
            return @"STATE_INVALID";
    }
}

@end