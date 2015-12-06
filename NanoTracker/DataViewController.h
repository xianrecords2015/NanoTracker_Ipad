//
//  DataViewController.h
//  NanoTracker
//
//  Created by Christian Joly on 10/29/15.
//  Copyright © 2015 Christian Joly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tracker.h"

@interface DataViewController : UIViewController {


    IBOutlet UILabel *XAcc;
    IBOutlet UILabel *YAcc;
    IBOutlet UILabel *ZAcc;
    
    IBOutlet UILabel *XGyr;
    IBOutlet UILabel *YGyr;
    IBOutlet UILabel *ZGyr;
    
    IBOutlet UILabel *XMag;
    IBOutlet UILabel *YMag;
    IBOutlet UILabel *ZMag;
    
    IBOutlet UILabel *Pitch1;
    IBOutlet UILabel *Roll1;
    IBOutlet UILabel *Yawn1;
    
    IBOutlet UILabel *Q11;
    IBOutlet UILabel *Q12;
    IBOutlet UILabel *Q13;
    IBOutlet UILabel *Q14;

    IBOutlet UILabel *Pitch2;
    IBOutlet UILabel *Roll2;
    IBOutlet UILabel *Yawn2;
    
    IBOutlet UILabel *Q21;
    IBOutlet UILabel *Q22;
    IBOutlet UILabel *Q23;
    IBOutlet UILabel *Q24;
    
    IBOutlet UILabel *Pitch3;
    IBOutlet UILabel *Roll3;
    IBOutlet UILabel *Yawn3;
    
    IBOutlet UILabel *Q31;
    IBOutlet UILabel *Q32;
    IBOutlet UILabel *Q33;
    IBOutlet UILabel *Q34;
}

@property IBOutlet UIButton *connect_F;
@property IBOutlet UIButton *connect_T;

- (IBAction) connect_F:(id)sender;
- (IBAction) connect_T:(id)sender;

- (void) showAccData:(Tracker *) t;
- (void) showGyrData:(Tracker *) t;
- (void) showMagData:(Tracker *) t;
- (void) showEulData:(Tracker *) t;
- (void) reset;

@end

