//
//  Tracker.h
//
//  Created by Christian Joly on 6/2/15.
//  Copyright (c) 2015 Christian Joly. All rights reserved.
//
#import <UIKit/UIKit.h>
@import CoreBluetooth;

@interface Tracker : NSObject {
    NSString *name;
    CBPeripheral *p;
    float accx;
    float accy;
    float accz;
    float gyrx;
    float gyry;
    float gyrz;
    float magx;
    float magy;
    float magz;
    float roll;
    float pitch;
    float yaw;
}

@property NSString *name;
@property CBPeripheral *p;
@property float accx;
@property float accy;
@property float accz;
@property float gyrx;
@property float gyry;
@property float gyrz;
@property float magx;
@property float magy;
@property float magz;
@property float roll;
@property float pitch;
@property float yaw;

@end