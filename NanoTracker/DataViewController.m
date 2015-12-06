//
//  DataViewController.m
//  NanoTracker
//
//  Created by Christian Joly on 10/29/15.
//  Copyright © 2015 Christian Joly. All rights reserved.
//

#import "DataViewController.h"
#import "TabController.h"

@interface DataViewController ()

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self reset];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction) connect_F:(id)sender {
    
    [(TabController *)self.tabBarController connect:@"F"];
    
}

- (IBAction) connect_T:(id)sender {
    
    [(TabController *)self.tabBarController connect:@"T"];

}

- (void) showAccData:(Tracker *) t {
    XAcc.text = [NSString stringWithFormat:@"%4.4f",t.accx];
    YAcc.text = [NSString stringWithFormat:@"%4.4f",t.accy];
    ZAcc.text = [NSString stringWithFormat:@"%4.4f",t.accz];
}

- (void) showGyrData:(Tracker *) t {
    XGyr.text = [NSString stringWithFormat:@"%4.4f",t.gyrx];
    YGyr.text = [NSString stringWithFormat:@"%4.4f",t.gyry];
    ZGyr.text = [NSString stringWithFormat:@"%4.4f",t.gyrz];
}

- (void) showMagData:(Tracker *) t {
    XMag.text = [NSString stringWithFormat:@"%4.4f",t.magx];
    YMag.text = [NSString stringWithFormat:@"%4.4f",t.magy];
    ZMag.text = [NSString stringWithFormat:@"%4.4f",t.magz];
}

- (void) showEulData:(Tracker *) t {
    Pitch1.text = [NSString stringWithFormat:@"%4.1f",t.pitch];
    Roll1.text  = [NSString stringWithFormat:@"%4.1f",t.roll];
    Yawn1.text  = [NSString stringWithFormat:@"%4.1f",t.yaw];
}

- (void) reset {
    
    XAcc.text = @"";
    YAcc.text = @"";
    ZAcc.text = @"";
    XGyr.text = @"";
    YGyr.text = @"";
    ZGyr.text = @"";
    XMag.text = @"";
    YMag.text = @"";
    ZMag.text = @"";
    
    Pitch1.text = @"";
    Roll1.text  = @"";
    Yawn1.text  = @"";
    
    Q11.text  = @"";
    Q12.text  = @"";
    Q13.text  = @"";
    Q14.text  = @"";
    
    Pitch2.text = @"";
    Roll2.text  = @"";
    Yawn2.text  = @"";
    
    Q21.text  = @"";
    Q22.text  = @"";
    Q23.text  = @"";
    Q24.text  = @"";
    
    Pitch3.text = @"";
    Roll3.text  = @"";
    Yawn3.text  = @"";
    
    Q31.text  = @"";
    Q32.text  = @"";
    Q33.text  = @"";
    Q34.text  = @"";
}

@end
