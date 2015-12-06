//
//  BleController.h
//  NanoSpacer_iPad
//
//  Created by Christian Joly on 5/6/15.
//  Copyright (c) 2015 Christian Joly. All rights reserved.
//
// "NT_SERVICE => 46b20001-899b-4975-8a56-4c79724c8c97
// "NT_ACC     => 46b20002-899b-4975-8a56-4c79724c8c97
// "NT_GYR     => 46b20003-899b-4975-8a56-4c79724c8c97
// "NT_MAG     => 46b20004-899b-4975-8a56-4c79724c8c97
@import QuartzCore;
@import CoreBluetooth;
#import "Tracker.h"

@protocol BleControllerDelegate
- (void) didReceiveAccData:(CBPeripheral *)peripheral withX:(float)x withY:(float)y withZ:(float)z;
- (void) didReceiveGyrData:(CBPeripheral *)peripheral withX:(float)x withY:(float)y withZ:(float)z;
- (void) didReceiveMagData:(CBPeripheral *)peripheral withX:(float)x withY:(float)y withZ:(float)z;
- (void) didReceiveEulData:(CBPeripheral *)peripheral withRoll:(float)roll withPitch:(float)pitch withYaw:(float)yaw;

- (void) didFindTracker:(CBPeripheral *)peripheral;
- (void) didConnect:(CBPeripheral *)peripheral;
- (void) didDisconnect:(CBPeripheral *)peripheral;
@end


@interface BleController : NSObject  <CBCentralManagerDelegate, CBPeripheralDelegate> {

    id<BleControllerDelegate> delegate;
    CBCentralManager *nt_centralManager;

}

@property id<BleControllerDelegate> delegate;
@property CBCentralManager *nt_centralManager;

+ (id)sharedManager;
+ (CBUUID *) ntServiceUUID;
+ (CBUUID *) AccCharacteristicUUID;
+ (CBUUID *) GyrCharacteristicUUID;

- (void)startFindingTrackers;
- (void)stopFindingTrackers;
- (void)connectTracker:(CBPeripheral *)peripheral;

@end
