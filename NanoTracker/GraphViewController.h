//
//  DataViewController.h
//  NanoTracker
//
//  Created by Christian Joly on 10/29/15.
//  Copyright © 2015 Christian Joly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tracker.h"
#import "CorePlot-CocoaTouch.h"

@interface GraphViewController : UIViewController <CPTPlotDataSource> {

    CPTGraphHostingView *accHostView;
    CPTGraphHostingView *gyrHostView;
    CPTGraphHostingView *magHostView;
    CPTGraphHostingView *eulHostView;

}

@property (weak, nonatomic) IBOutlet UIView  *accview;
@property (weak, nonatomic) IBOutlet UIView  *gyrview;
@property (weak, nonatomic) IBOutlet UIView  *magview;
@property (weak, nonatomic) IBOutlet UIView  *eulview;

- (void) showAccData:(Tracker *) t;
- (void) showGyrData:(Tracker *) t;
- (void) showMagData:(Tracker *) t;
- (void) showEulData:(Tracker *) t;

@end

