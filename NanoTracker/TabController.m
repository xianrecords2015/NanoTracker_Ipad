//
//  TabController.m
//  NanoTracker
//
//  Created by Christian Joly on 10/31/15.
//  Copyright © 2015 Christian Joly. All rights reserved.
//

#import "TabController.h"
#import "DataViewController.h"
#import "GraphViewController.h"

@interface TabController () {
    
    NSString *current_tracker;

}

@end


@implementation TabController

@synthesize bcontroller = _bcontroller;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tracker_F = nil;
    _tracker_T = nil;
    
    _bcontroller = [BleController sharedManager];
    _bcontroller.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) connect:(NSString *)key {
    current_tracker = key;
    [_bcontroller startFindingTrackers];
}

//
// BleController Delegates
//
- (void) didFindTracker:(CBPeripheral *)peripheral {
    
    if ([current_tracker isEqualToString:@"T"]) {
        _tracker_T   = [[Tracker alloc] init];
        _tracker_T.p = peripheral;
        [_bcontroller connectTracker:_tracker_T.p];
    } else if ([current_tracker isEqualToString:@"F"]) {
        _tracker_F = [[Tracker alloc] init];
        _tracker_F.p = peripheral;
        [_bcontroller connectTracker:_tracker_F.p];
    } else {
        NSLog(@"Invalid Trackers to allocate");
    }
    
    current_tracker = nil;
    [_bcontroller stopFindingTrackers];

}


- (void) didConnect:(CBPeripheral *)peripheral {
    
    // DataViewController
    if ([self.selectedViewController isKindOfClass:[DataViewController class]]) {
        if (_tracker_F.p == peripheral) {
            [((DataViewController *)self.selectedViewController).connect_F setBackgroundImage:[UIImage imageNamed:@"circle_blue.png"] forState:UIControlStateNormal];
        } else if (_tracker_T.p == peripheral) {
            [((DataViewController *)self.selectedViewController).connect_T setBackgroundImage:[UIImage imageNamed:@"circle_blue.png"] forState:UIControlStateNormal];
        }
    }
    
    
}

- (void) didDisconnect:(CBPeripheral *)peripheral {
    
    // DataViewController
    if ([self.selectedViewController isKindOfClass:[DataViewController class]]) {
        if (_tracker_F.p == peripheral) {
            [((DataViewController *)self.selectedViewController).connect_F setBackgroundImage:[UIImage imageNamed:@"redcircle.png"] forState:UIControlStateNormal];
            _tracker_F = nil;
        } else if (_tracker_T.p == peripheral) {
            [((DataViewController *)self.selectedViewController).connect_T setBackgroundImage:[UIImage imageNamed:@"redcircle.png"] forState:UIControlStateNormal];
            _tracker_T = nil;
        }
        [(DataViewController *)self.selectedViewController reset];
    }
    
}

- (void) didReceiveAccData:(CBPeripheral *)peripheral withX:(float)x withY:(float)y withZ:(float)z {
    
    Tracker *tracker;
    
    if (_tracker_F.p == peripheral) tracker = _tracker_F;
    if (_tracker_T.p == peripheral) tracker = _tracker_T;
    
    tracker.accx = x;
    tracker.accy = y;
    tracker.accz = z;
    
    // DataViewController
    if ([self.selectedViewController isKindOfClass:[DataViewController class]]) {
        [(DataViewController *)self.selectedViewController showAccData:tracker];
    }
    
    // GraphViewController
    if ([self.selectedViewController isKindOfClass:[GraphViewController class]]) {
        [(GraphViewController *)self.selectedViewController showAccData:tracker];
    }
    
}

- (void) didReceiveGyrData:(CBPeripheral *)peripheral withX:(float)x withY:(float)y withZ:(float)z {
    
    Tracker *tracker;
    
    if (_tracker_F.p == peripheral) tracker = _tracker_F;
    if (_tracker_T.p == peripheral) tracker = _tracker_T;
    
    tracker.gyrx = x;
    tracker.gyry = y;
    tracker.gyrz = z;
    
    // DataViewController
    if ([self.selectedViewController isKindOfClass:[DataViewController class]]) {
        [(DataViewController *)self.selectedViewController showGyrData:tracker];
    }
    
    // GraphViewController
    if ([self.selectedViewController isKindOfClass:[GraphViewController class]]) {
        [(GraphViewController *)self.selectedViewController showGyrData:tracker];
    }
    
}

- (void) didReceiveMagData:(CBPeripheral *)peripheral withX:(float)x withY:(float)y withZ:(float)z {
    
    Tracker *tracker;
    
    if (_tracker_F.p == peripheral) tracker = _tracker_F;
    if (_tracker_T.p == peripheral) tracker = _tracker_T;
    
    tracker.magx = x;
    tracker.magy = y;
    tracker.magz = z;
    
    // DataViewController
    if ([self.selectedViewController isKindOfClass:[DataViewController class]]) {
        [(DataViewController *)self.selectedViewController showMagData:tracker];
    }
    
    // GraphViewController
    if ([self.selectedViewController isKindOfClass:[GraphViewController class]]) {
        [(GraphViewController *)self.selectedViewController showMagData:tracker];
    }
    
}

- (void) didReceiveEulData:(CBPeripheral *)peripheral  withRoll:(float)roll withPitch:(float)pitch withYaw:(float)yaw {
    
    Tracker *tracker;
    
    if (_tracker_F.p == peripheral) tracker = _tracker_F;
    if (_tracker_T.p == peripheral) tracker = _tracker_T;

    tracker.pitch = pitch;
    tracker.roll  = roll;
    tracker.yaw   = yaw;
    
    
    // DataViewController
    if ([self.selectedViewController isKindOfClass:[DataViewController class]]) {
        [(DataViewController *)self.selectedViewController showEulData:tracker];
    }
    
    // GraphViewController
    if ([self.selectedViewController isKindOfClass:[GraphViewController class]]) {
        [(GraphViewController *)self.selectedViewController showEulData:tracker];
    }
    
}
@end