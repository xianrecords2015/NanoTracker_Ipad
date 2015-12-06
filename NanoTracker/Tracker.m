//
//  Tracker.m
//
//  Created by Christian Joly on 6/2/15.
//  Copyright (c) 2015 Christian Joly. All rights reserved.
//

#import "Tracker.h"

@interface Tracker () {
    
}
@end

@implementation Tracker

@synthesize name;
@synthesize p;
@synthesize accx;
@synthesize accy;
@synthesize accz;
@synthesize gyrx;
@synthesize gyry;
@synthesize gyrz;
@synthesize magx;
@synthesize magy;
@synthesize magz;
@synthesize roll;
@synthesize pitch;
@synthesize yaw;

- (id)init {
    self = [super init];
    if (self)
    {
        // Initialization code here.
        name = nil;
        p    = nil;
        accx = 0.0;
        accy = 0.0;
        accz = 0.0;
        gyrx = 0.0;
        gyry = 0.0;
        gyrz = 0.0;
        magx = 0.0;
        magy = 0.0;
        magz = 0.0;
        pitch = 0.0;
        roll = 0.0;
        yaw = 0.0;
    }
    return self;
}

- (void) reset {
    
    accx = 0.0;
    accy = 0.0;
    accz = 0.0;
    gyrx = 0.0;
    gyry = 0.0;
    gyrz = 0.0;
    magx = 0.0;
    magy = 0.0;
    magz = 0.0;
    pitch = 0.0;
    roll = 0.0;
    yaw = 0.0;
}

@end