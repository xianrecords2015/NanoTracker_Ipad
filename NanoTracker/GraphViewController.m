//
//  GraphViewController.m
//  NanoTracker
//
//  Created by Christian Joly on 10/29/15.
//  Copyright © 2015 Christian Joly. All rights reserved.
//

#import "GraphViewController.h"
#import "TabController.h"

#define MAXDATA 100

@interface GraphViewController () {
    NSMutableArray *xAccData;
    NSMutableArray *yAccData;
    NSMutableArray *zAccData;
    NSMutableArray *xGyrData;
    NSMutableArray *yGyrData;
    NSMutableArray *zGyrData;
    NSMutableArray *xMagData;
    NSMutableArray *yMagData;
    NSMutableArray *zMagData;
    NSMutableArray *xEulData;
    NSMutableArray *yEulData;
    NSMutableArray *zEulData;
    
    CPTScatterPlot *xAccplot;
    CPTScatterPlot *yAccplot;
    CPTScatterPlot *zAccplot;
    CPTScatterPlot *xGyrplot;
    CPTScatterPlot *yGyrplot;
    CPTScatterPlot *zGyrplot;
    CPTScatterPlot *xMagplot;
    CPTScatterPlot *yMagplot;
    CPTScatterPlot *zMagplot;
    CPTScatterPlot *xEulplot;
    CPTScatterPlot *yEulplot;
    CPTScatterPlot *zEulplot;
}

@end

@implementation GraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureHosts];
    
    // Init Data Arrays
    xAccData = [[NSMutableArray alloc] init];
    yAccData = [[NSMutableArray alloc] init];
    zAccData = [[NSMutableArray alloc] init];
    xGyrData = [[NSMutableArray alloc] init];
    yGyrData = [[NSMutableArray alloc] init];
    zGyrData = [[NSMutableArray alloc] init];
    xMagData = [[NSMutableArray alloc] init];
    yMagData = [[NSMutableArray alloc] init];
    zMagData = [[NSMutableArray alloc] init];
    xEulData = [[NSMutableArray alloc] init];
    yEulData = [[NSMutableArray alloc] init];
    zEulData = [[NSMutableArray alloc] init];
    
    [self configureGraphs:accHostView];
    [self configureGraphs:gyrHostView];
    [self configureGraphs:magHostView];
    [self configureGraphs:eulHostView];

    [self configurePlotspaces:accHostView.hostedGraph withScale:2.0];
    [self configurePlotspaces:gyrHostView.hostedGraph withScale:250.0];
    [self configurePlotspaces:magHostView.hostedGraph withScale:4912.0];
    [self configurePlotspaces:eulHostView.hostedGraph withScale:180.0];

    [self configureAxes:accHostView.hostedGraph withScale:2.0];
    [self configureAxes:gyrHostView.hostedGraph withScale:250.0];
    [self configureAxes:magHostView.hostedGraph withScale:4912.0];
    [self configureAxes:eulHostView.hostedGraph withScale:180.0];
    
    [self addPlots];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureHosts {

    accHostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:_accview.bounds];
    [_accview addSubview:accHostView];
    
    gyrHostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:_gyrview.bounds];
    [_gyrview addSubview:gyrHostView];
    
    magHostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:_magview.bounds];
    [_magview addSubview:magHostView];
    
    eulHostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:_eulview.bounds];
    [_eulview addSubview:eulHostView];
}

-(void)configureGraphs:(CPTGraphHostingView *)host  {
    
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:host.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    host.hostedGraph = graph;
    graph.paddingLeft    = 0.0;
    graph.paddingTop     = 0.0;
    graph.paddingRight   = 0.0;
    graph.paddingBottom  = 0.0;
    
}


-(void)configurePlotspaces:(CPTGraph *)graph withScale:(float) scale {
    

    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.identifier = @"plotspace";
    
    // Update of Xrange of the left plot
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocationDecimal:CPTDecimalFromFloat(0) lengthDecimal:CPTDecimalFromFloat(60.0)];
    CPTMutablePlotRange *xRange1 = [plotSpace.xRange mutableCopy];
    [xRange1 expandRangeByFactor:[NSNumber numberWithFloat:1.15]];
    plotSpace.xRange = xRange1;
    
    
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocationDecimal:CPTDecimalFromFloat(-scale) lengthDecimal:CPTDecimalFromFloat(2*scale)];
    CPTMutablePlotRange *yRange1 = [plotSpace.yRange mutableCopy];
    [yRange1 expandRangeByFactor:[NSNumber numberWithFloat:1.2]];
    plotSpace.yRange = yRange1;
    
}


-(void)configureAxes:(CPTGraph *)graph withScale:(float) scale {
    
    float increment = 1;
    float maxvalue  = 10;
    
    // Configure Axis Text STyle
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color                = [CPTColor whiteColor];
    axisTitleStyle.fontName             = @"Helvetica-Bold";
    axisTitleStyle.fontSize             = 12.0f;
    axisTitleStyle.textAlignment        = CPTTextAlignmentRight;
    CPTMutableLineStyle *axisLineStyle  = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth             = 2.0f;
    axisLineStyle.lineColor             = [CPTColor whiteColor];
    CPTMutableTextStyle *axisTextStyle  = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color                 = [CPTColor whiteColor];
    axisTextStyle.fontName              = @"Helvetica-Bold";
    axisTextStyle.fontSize              = 11.0f;
    CPTMutableLineStyle *tickLineStyle  = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor             = [CPTColor whiteColor];
    tickLineStyle.lineWidth             = 2.0f;
    CPTMutableLineStyle *gridLineStyle  = [CPTMutableLineStyle lineStyle];

    
    // Configure x-axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet;
    CPTAxis *x1           = axisSet.xAxis;
    x1.titleTextStyle     = axisTitleStyle;
    x1.titleOffset        = -30.0f;
    x1.axisLineStyle      = axisLineStyle;
    x1.labelingPolicy     = CPTAxisLabelingPolicyNone;
    x1.labelTextStyle     = axisTextStyle;
    x1.majorTickLineStyle = axisLineStyle;
    x1.majorTickLength    = 4.0f;
    x1.tickDirection      = CPTSignNegative;
    
    // Configure the x-axis labels
    NSMutableSet *xLabels;
    NSMutableSet *xLocations;
    xLabels    = [NSMutableSet setWithCapacity:10.0];
    xLocations = [NSMutableSet setWithCapacity:10.0];
    for (int i=0; i <= 60; i+=10) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%d",i]  textStyle:x1.labelTextStyle];
        CGFloat location = i;
        label.tickLocation = [NSNumber numberWithFloat:location];
        label.offset = x1.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    x1.axisLabels = xLabels;
    x1.majorTickLocations = xLocations;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    //
    // Configure Y1 Axis
    //
    CPTXYAxis *y1                  = axisSet.yAxis;
    //y1.title                       = title1;
    //y1.titleTextStyle              = axisTitleStyle;
    //y1.titleOffset                 = -45.0f;
    //y1.titleLocation               = [NSNumber numberWithFloat:(YNUMBER/2)];
    y1.axisLineStyle               = axisLineStyle;
    y1.majorGridLineStyle          = gridLineStyle;
    y1.plotSpace                   = plotSpace;
    y1.labelingPolicy              = CPTAxisLabelingPolicyNone;
    y1.labelTextStyle              = axisTextStyle;
    y1.majorTickLineStyle          = axisLineStyle;
    y1.majorTickLength             = 4.0f;
    y1.minorTickLength             = 2.0f;
    y1.tickDirection               = CPTSignPositive;
    y1.tickLabelDirection          = CPTSignPositive;
    y1.labelOffset                 = 0;

    UIFont *font1 = [UIFont fontWithName:y1.labelTextStyle.fontName size:y1.labelTextStyle.fontSize];
    NSMutableSet *yLabels1         = [NSMutableSet set];
    NSMutableSet *yMajorLocations1 = [NSMutableSet set];
    if (scale == 2) {
        maxvalue  = 2;
        increment = 1;
    } else if (scale == 250) {
        maxvalue  = 250;
        increment = 50;
    } else if (scale == 4912) {
        maxvalue  = 5000;
        increment = 1000;
    } else if (scale == 180) {
        maxvalue  = 180;
        increment = 45;
    }
    for (int j = -maxvalue; j <= maxvalue; j += increment) {
        if (j==0) continue;
        NSString *tlabel = [NSString stringWithFormat:@"%d",j];
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:tlabel textStyle:y1.labelTextStyle];
        CGSize textsize = [tlabel sizeWithAttributes:@{NSFontAttributeName: font1}];
        label.tickLocation = [NSNumber numberWithInt:j];
        label.offset = -y1.majorTickLength - y1.labelOffset - textsize.width;
        [yLabels1 addObject:label];
        [yMajorLocations1 addObject:[NSNumber numberWithInteger:j]];
    }
    y1.axisLabels          = yLabels1;
    y1.majorTickLocations  = yMajorLocations1;
    
}

-(void)addPlots {
    
    // 1 - Get graph and plot space
    CPTXYPlotSpace *accPlotSpace = (CPTXYPlotSpace *) accHostView.hostedGraph.defaultPlotSpace;
    CPTXYPlotSpace *gyrPlotSpace = (CPTXYPlotSpace *) gyrHostView.hostedGraph.defaultPlotSpace;
    CPTXYPlotSpace *magPlotSpace = (CPTXYPlotSpace *) magHostView.hostedGraph.defaultPlotSpace;
    CPTXYPlotSpace *eulPlotSpace = (CPTXYPlotSpace *) eulHostView.hostedGraph.defaultPlotSpace;

    // 2 - Create the plots
    xAccplot  = [[CPTScatterPlot alloc] init];
    yAccplot  = [[CPTScatterPlot alloc] init];
    zAccplot  = [[CPTScatterPlot alloc] init];
    xGyrplot  = [[CPTScatterPlot alloc] init];
    yGyrplot  = [[CPTScatterPlot alloc] init];
    zGyrplot  = [[CPTScatterPlot alloc] init];
    xMagplot  = [[CPTScatterPlot alloc] init];
    yMagplot  = [[CPTScatterPlot alloc] init];
    zMagplot  = [[CPTScatterPlot alloc] init];
    xEulplot  = [[CPTScatterPlot alloc] init];
    yEulplot  = [[CPTScatterPlot alloc] init];
    zEulplot  = [[CPTScatterPlot alloc] init];

    xAccplot.dataSource  = self;
    yAccplot.dataSource  = self;
    zAccplot.dataSource  = self;
    xGyrplot.dataSource  = self;
    yGyrplot.dataSource  = self;
    zGyrplot.dataSource  = self;
    xMagplot.dataSource  = self;
    yMagplot.dataSource  = self;
    zMagplot.dataSource  = self;
    xEulplot.dataSource  = self;
    yEulplot.dataSource  = self;
    zEulplot.dataSource  = self;
    
    CPTMutableLineStyle *xAccLineStyle = [xAccplot.dataLineStyle mutableCopy];
    xAccLineStyle.lineWidth = 2.5;
    xAccLineStyle.lineColor = [CPTColor colorWithCGColor:[[UIColor blueColor] CGColor]];
    xAccplot.dataLineStyle = xAccLineStyle;
    CPTMutableLineStyle *xGyrLineStyle = [xGyrplot.dataLineStyle mutableCopy];
    xGyrLineStyle.lineWidth = 2.5;
    xGyrLineStyle.lineColor = [CPTColor colorWithCGColor:[[UIColor blueColor] CGColor]];
    xGyrplot.dataLineStyle = xGyrLineStyle;
    CPTMutableLineStyle *xMagLineStyle = [xMagplot.dataLineStyle mutableCopy];
    xMagLineStyle.lineWidth = 2.5;
    xMagLineStyle.lineColor = [CPTColor colorWithCGColor:[[UIColor blueColor] CGColor]];
    xMagplot.dataLineStyle = xMagLineStyle;
    CPTMutableLineStyle *xEulLineStyle = [xEulplot.dataLineStyle mutableCopy];
    xEulLineStyle.lineWidth = 2.5;
    xEulLineStyle.lineColor = [CPTColor colorWithCGColor:[[UIColor blueColor] CGColor]];
    xEulplot.dataLineStyle = xEulLineStyle;
    
    CPTMutableLineStyle *yAccLineStyle = [yAccplot.dataLineStyle mutableCopy];
    yAccLineStyle.lineWidth = 2.5;
    yAccLineStyle.lineColor = [CPTColor colorWithCGColor:[[UIColor redColor] CGColor]];
    yAccplot.dataLineStyle = yAccLineStyle;
    CPTMutableLineStyle *yGyrLineStyle = [yGyrplot.dataLineStyle mutableCopy];
    yGyrLineStyle.lineWidth = 2.5;
    yGyrLineStyle.lineColor = [CPTColor colorWithCGColor:[[UIColor redColor] CGColor]];
    yGyrplot.dataLineStyle = yGyrLineStyle;
    CPTMutableLineStyle *yMagLineStyle = [yMagplot.dataLineStyle mutableCopy];
    yMagLineStyle.lineWidth = 2.5;
    yMagLineStyle.lineColor = [CPTColor colorWithCGColor:[[UIColor redColor] CGColor]];
    yMagplot.dataLineStyle = yMagLineStyle;
    CPTMutableLineStyle *yEulLineStyle = [yEulplot.dataLineStyle mutableCopy];
    yEulLineStyle.lineWidth = 2.5;
    yEulLineStyle.lineColor = [CPTColor colorWithCGColor:[[UIColor redColor] CGColor]];
    yEulplot.dataLineStyle = yEulLineStyle;
    
    CPTMutableLineStyle *zAccLineStyle = [zAccplot.dataLineStyle mutableCopy];
    zAccLineStyle.lineWidth = 2.5;
    zAccLineStyle.lineColor = [CPTColor colorWithCGColor:[[UIColor greenColor] CGColor]];
    zAccplot.dataLineStyle = zAccLineStyle;
    CPTMutableLineStyle *zGyrLineStyle = [zGyrplot.dataLineStyle mutableCopy];
    zGyrLineStyle.lineWidth = 2.5;
    zGyrLineStyle.lineColor = [CPTColor colorWithCGColor:[[UIColor greenColor] CGColor]];
    zGyrplot.dataLineStyle = zGyrLineStyle;
    CPTMutableLineStyle *zMagLineStyle = [zMagplot.dataLineStyle mutableCopy];
    zMagLineStyle.lineWidth = 2.5;
    zMagLineStyle.lineColor = [CPTColor colorWithCGColor:[[UIColor greenColor] CGColor]];
    zMagplot.dataLineStyle = zMagLineStyle;
    CPTMutableLineStyle *zEulLineStyle = [zEulplot.dataLineStyle mutableCopy];
    zEulLineStyle.lineWidth = 2.5;
    zEulLineStyle.lineColor = [CPTColor colorWithCGColor:[[UIColor greenColor] CGColor]];
    zEulplot.dataLineStyle = zEulLineStyle;
    
    // Add the plots to the Graph
    [accHostView.hostedGraph insertPlot:xAccplot  atIndex:0 intoPlotSpace:accPlotSpace];
    [accHostView.hostedGraph insertPlot:yAccplot  atIndex:0 intoPlotSpace:accPlotSpace];
    [accHostView.hostedGraph insertPlot:zAccplot  atIndex:0 intoPlotSpace:accPlotSpace];
    [gyrHostView.hostedGraph insertPlot:xGyrplot  atIndex:0 intoPlotSpace:gyrPlotSpace];
    [gyrHostView.hostedGraph insertPlot:yGyrplot  atIndex:0 intoPlotSpace:gyrPlotSpace];
    [gyrHostView.hostedGraph insertPlot:zGyrplot  atIndex:0 intoPlotSpace:gyrPlotSpace];
    [magHostView.hostedGraph insertPlot:xMagplot  atIndex:0 intoPlotSpace:magPlotSpace];
    [magHostView.hostedGraph insertPlot:yMagplot  atIndex:0 intoPlotSpace:magPlotSpace];
    [magHostView.hostedGraph insertPlot:zMagplot  atIndex:0 intoPlotSpace:magPlotSpace];
    [eulHostView.hostedGraph insertPlot:xEulplot  atIndex:0 intoPlotSpace:eulPlotSpace];
    [eulHostView.hostedGraph insertPlot:yEulplot  atIndex:0 intoPlotSpace:eulPlotSpace];
    [eulHostView.hostedGraph insertPlot:zEulplot  atIndex:0 intoPlotSpace:eulPlotSpace];
    
    [accHostView.hostedGraph reloadData];
    [gyrHostView.hostedGraph reloadData];
    [magHostView.hostedGraph reloadData];
    [eulHostView.hostedGraph reloadData];
   
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    
    if (plot == xAccplot) return xAccData.count;
    if (plot == yAccplot) return yAccData.count;
    if (plot == zAccplot) return zAccData.count;
    if (plot == xGyrplot) return xGyrData.count;
    if (plot == yGyrplot) return yGyrData.count;
    if (plot == zGyrplot) return zGyrData.count;
    if (plot == xMagplot) return xMagData.count;
    if (plot == yMagplot) return yMagData.count;
    if (plot == zMagplot) return zMagData.count;
    if (plot == xEulplot) return xEulData.count;
    if (plot == yEulplot) return yEulData.count;
    if (plot == zEulplot) return zEulData.count;
    
    return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            return [NSDecimalNumber numberWithInteger:index];
            break;
            
        case CPTScatterPlotFieldY:
            if (plot == xAccplot) return [xAccData objectAtIndex:index];
            if (plot == yAccplot) return [yAccData objectAtIndex:index];
            if (plot == zAccplot) return [zAccData objectAtIndex:index];
            if (plot == xGyrplot) return [xGyrData objectAtIndex:index];
            if (plot == yGyrplot) return [yGyrData objectAtIndex:index];
            if (plot == zGyrplot) return [zGyrData objectAtIndex:index];
            if (plot == xMagplot) return [xMagData objectAtIndex:index];
            if (plot == yMagplot) return [yMagData objectAtIndex:index];
            if (plot == zMagplot) return [zMagData objectAtIndex:index];
            if (plot == xEulplot) return [xEulData objectAtIndex:index];
            if (plot == yEulplot) return [yEulData objectAtIndex:index];
            if (plot == zEulplot) return [zEulData objectAtIndex:index];
            break;
    }
    
    return [NSDecimalNumber zero];
    
}

// BLE Delegate
- (void) showAccData:(Tracker *) t {
    
    [xAccData insertObject:[NSDecimalNumber numberWithFloat:t.accx] atIndex:0];
    [yAccData insertObject:[NSDecimalNumber numberWithFloat:t.accy] atIndex:0];
    [zAccData insertObject:[NSDecimalNumber numberWithFloat:t.accz] atIndex:0];
    
    if (xAccData.count > MAXDATA) [xAccData removeObjectAtIndex:MAXDATA];
    if (yAccData.count > MAXDATA) [yAccData removeObjectAtIndex:MAXDATA];
    if (zAccData.count > MAXDATA) [zAccData removeObjectAtIndex:MAXDATA];

    [accHostView.hostedGraph reloadData];

}

- (void) showGyrData:(Tracker *) t {
    
    [xGyrData insertObject:[NSDecimalNumber numberWithFloat:t.gyrx] atIndex:0];
    [yGyrData insertObject:[NSDecimalNumber numberWithFloat:t.gyry] atIndex:0];
    [zGyrData insertObject:[NSDecimalNumber numberWithFloat:t.gyrz] atIndex:0];
    
    if (xGyrData.count > MAXDATA) [xGyrData removeObjectAtIndex:MAXDATA];
    if (yGyrData.count > MAXDATA) [yGyrData removeObjectAtIndex:MAXDATA];
    if (zGyrData.count > MAXDATA) [zGyrData removeObjectAtIndex:MAXDATA];
    
    [gyrHostView.hostedGraph reloadData];

}

- (void) showMagData:(Tracker *) t {
    
    [xMagData insertObject:[NSDecimalNumber numberWithFloat:t.magx] atIndex:0];
    [yMagData insertObject:[NSDecimalNumber numberWithFloat:t.magy] atIndex:0];
    [zMagData insertObject:[NSDecimalNumber numberWithFloat:t.magz] atIndex:0];
    
    if (xMagData.count > MAXDATA) [xMagData removeObjectAtIndex:MAXDATA];
    if (yMagData.count > MAXDATA) [yMagData removeObjectAtIndex:MAXDATA];
    if (zMagData.count > MAXDATA) [zMagData removeObjectAtIndex:MAXDATA];
    
    [magHostView.hostedGraph reloadData];

}

- (void) showEulData:(Tracker *) t {
    
    [xEulData insertObject:[NSDecimalNumber numberWithFloat:t.roll]  atIndex:0];
    [yEulData insertObject:[NSDecimalNumber numberWithFloat:t.pitch] atIndex:0];
    [zEulData insertObject:[NSDecimalNumber numberWithFloat:t.yaw]   atIndex:0];
    
    if (xEulData.count > MAXDATA) [xEulData removeObjectAtIndex:MAXDATA];
    if (yEulData.count > MAXDATA) [yEulData removeObjectAtIndex:MAXDATA];
    if (zEulData.count > MAXDATA) [zEulData removeObjectAtIndex:MAXDATA];
    
    [eulHostView.hostedGraph reloadData];

}

@end
