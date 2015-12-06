//
//  bleController.m
//  NanoSpacer_iPad
//
//  Created by Christian Joly on 5/6/15.
//  Copyright (c) 2015 Christian Joly. All rights reserved.
//

#import "BleController.h"
#import "Tracker.h"

@interface BleController () {
    
    CBService *ntService;
    CBCharacteristic *AccCharacteristic;
    CBCharacteristic *GyrCharacteristic;
    CBCharacteristic *MagCharacteristic;
    CBCharacteristic *EulCharacteristic;

}

@end


@implementation BleController

@synthesize nt_centralManager;
@synthesize delegate;


+ (id)sharedManager {
    static BleController *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

+ (CBUUID *) ntServiceUUID
{
    return [CBUUID UUIDWithString:@"46b20001-899b-4975-8a56-4c79724c8c97"];
}

+ (CBUUID *) AccCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"46b20002-899b-4975-8a56-4c79724c8c97"];
}

+ (CBUUID *) GyrCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"46b20003-899b-4975-8a56-4c79724c8c97"];
}

+ (CBUUID *) MagCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"46b20004-899b-4975-8a56-4c79724c8c97"];
}

+ (CBUUID *) EulCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"46b20005-899b-4975-8a56-4c79724c8c97"];
}

- (id)init {
    if (self = [super init]) {
        nt_centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        delegate = nil;
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

//
// Callbacks
//
- (void)startFindingTrackers {
    [nt_centralManager scanForPeripheralsWithServices:@[[BleController ntServiceUUID]] options:nil];
}

- (void)stopFindingTrackers {
    [nt_centralManager stopScan];;
}

- (void)connectTracker:(CBPeripheral *)peripheral {
    [nt_centralManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
}


//
// Central Manager Delegate
//
- (void) centralManagerDidUpdateState:(CBCentralManager *)central {
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        NSLog(@"Central Manager Powered On");
    }
    
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSString *localName      = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    NSData *manufacturerData = [advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey];
    
    if ( [localName isEqualToString:@"NanoTracker"] ) {
        NSLog(@"Found %@",localName);
        [self.delegate didFindTracker:peripheral];
    }
    
    
}


- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"Did connect peripheral %@", peripheral.name);
    peripheral.delegate = self;
    [peripheral discoverServices:@[self.class.ntServiceUUID]];
    [self.delegate didConnect:peripheral];
    
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    [self.delegate didDisconnect:peripheral];

}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"Failed to connect");
    
}

//
// Peripheral Delegate
//
- (void) peripheral:(CBPeripheral *)p didDiscoverServices:(NSError *)error {
    
    NSLog(@"Did Discover Services");
    
    if (error) {
        NSLog(@"Error discovering services: %@", error);
        return;
    }
    
    for (CBService *s in [p services]) {
        if ([s.UUID isEqual:self.class.ntServiceUUID]) {
            NSLog(@"Found correct service");
            ntService = s;
            [p discoverCharacteristics:nil forService:ntService];
        }
    }
    
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    if (error) {
        NSLog(@"Error discovering characteristics: %@", error);
        return;
    }
    
    for (CBCharacteristic *c in [service characteristics]) {
        if ([c.UUID isEqual:self.class.AccCharacteristicUUID]) {
            NSLog(@"Found ACC characteristic");
            AccCharacteristic = c;
            [peripheral setNotifyValue:YES forCharacteristic:AccCharacteristic];
        }
        if ([c.UUID isEqual:self.class.GyrCharacteristicUUID]) {
            NSLog(@"Found GYR characteristic");
            GyrCharacteristic = c;
            [peripheral setNotifyValue:YES forCharacteristic:GyrCharacteristic];
        }
        if ([c.UUID isEqual:self.class.MagCharacteristicUUID]) {
            NSLog(@"Found MAG characteristic");
            MagCharacteristic = c;
            [peripheral setNotifyValue:YES forCharacteristic:MagCharacteristic];
        }
        if ([c.UUID isEqual:self.class.EulCharacteristicUUID]) {
            NSLog(@"Found EUL characteristic");
            EulCharacteristic = c;
            [peripheral setNotifyValue:YES forCharacteristic:EulCharacteristic];
        }
    }
    
}

- (void) peripheral:(CBPeripheral *)p didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    float x;
    float y;
    float z;
    
    float pitch;
    float roll;
    float yaw;
    
    if (error) {
        NSLog(@"Error receiving notification for characteristic %@: %@", characteristic, error);
        return;
    }
    
    if (characteristic == AccCharacteristic) {
        
        NSData *data = [characteristic value];
        if (data.length != 12) {
            NSLog(@"Data badly formatted");
            return;
        }
        
        [data getBytes:&x range:NSMakeRange(0,4)];
        [data getBytes:&y range:NSMakeRange(4,4)];
        [data getBytes:&z range:NSMakeRange(8,4)];
        [self.delegate didReceiveAccData:p withX:x withY:y withZ:z];
    }
    
    if (characteristic == GyrCharacteristic) {
        
        NSData *data = [characteristic value];
        if (data.length != 12) {
            NSLog(@"Data badly formatted");
            return;
        }
        
        [data getBytes:&x range:NSMakeRange(0,4)];
        [data getBytes:&y range:NSMakeRange(4,4)];
        [data getBytes:&z range:NSMakeRange(8,4)];
        [self.delegate didReceiveGyrData:p withX:x withY:y withZ:z];
    }
    
    if (characteristic == MagCharacteristic) {
        
        NSData *data = [characteristic value];
        if (data.length != 12) {
            NSLog(@"Data badly formatted");
            return;
        }
        
        [data getBytes:&x range:NSMakeRange(0,4)];
        [data getBytes:&y range:NSMakeRange(4,4)];
        [data getBytes:&z range:NSMakeRange(8,4)];
        [self.delegate didReceiveMagData:p withX:x withY:y withZ:z];
    }
    
    if (characteristic == EulCharacteristic) {
        
        NSData *data = [characteristic value];
        if (data.length != 12) {
            NSLog(@"Data badly formatted");
            return;
        }
        
        [data getBytes:&roll  range:NSMakeRange(0,4)];
        [data getBytes:&pitch range:NSMakeRange(4,4)];
        [data getBytes:&yaw   range:NSMakeRange(8,4)];
        [self.delegate didReceiveEulData:p withRoll:roll withPitch:pitch withYaw:yaw];
    }
}


@end
