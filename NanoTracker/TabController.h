//
//  TabController.h
//  NanoTracker
//
//  Created by Christian Joly on 10/31/15.
//  Copyright © 2015 Christian Joly. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BleController.h"
#import "Tracker.h"

@interface TabController: UITabBarController <UITabBarControllerDelegate, BleControllerDelegate> 

@property Tracker *tracker_F;
@property Tracker *tracker_T;
@property BleController *bcontroller;

- (void) connect:(NSString *)key;

@end
