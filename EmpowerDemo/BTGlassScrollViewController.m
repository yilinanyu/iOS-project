//
//  ViewController.m
//  EmpowerDemo
//
//  Created by Lina on 7/30/15.
//  Copyright (c) 2015 empower. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BTGlassScrollViewController.h"
@import CoreLocation;
#define Duration 0.2
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "PNChart.h"
#import "CrumbPath.h"
#import "CrumbPathRenderer.h"
#import "AppDelegate.h"



@interface BTGlassScrollViewController()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    BOOL contain;
    CGPoint startPoint;
    CGPoint originPoint;
    
}
@property (nonatomic, strong) CrumbPath *crumbs;
@property (nonatomic, strong) CrumbPathRenderer *crumbPathRenderer;
@property (nonatomic, strong) MKPolygonRenderer *drawingAreaRenderer;   // shown if kDebugShowArea is set to 1
@property (strong , nonatomic) NSMutableArray *itemArray;
@property (nonatomic, strong) NSTimer *myTimer;
@end

@implementation BTGlassScrollViewController
@synthesize label1;
@synthesize mapView;
@synthesize locationManager;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.itemArray = [NSMutableArray array];
    }
    return self;
}
- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        
   
        _glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:image blurredImage:nil viewDistanceFromBottom:120 foregroundView:[self customView]];
       

        [self.view addSubview:_glassScrollView];
        
        
    }
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];
    
    return self;
}

- (void)updateUI:(NSTimer *)timer
{
    static int count =0; count++;
    
    if (count <=10)
    {
        
        self.label1.text= [NSString stringWithFormat:@"%d %%",count*10];
        float progress = (float)count/10.0f;
        [_progressBar setProgress: progress animated:YES];
        
        
    } else
    {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    aButton.frame = CGRectMake(0,0,200,30);
    UIImage *buttonImage = [UIImage imageNamed:@"menuButton.png"];
    [aButton addTarget:self action:@selector(memuBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.customView addSubview:aButton];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.view.backgroundColor = [UIColor blackColor];
    mapView.delegate =self;
   
    
    UIImageView* logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
//    logoView.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *logoImage = [UIImage imageNamed:@"emPowerBolt.png"];
    
    UIImageView *logoImageView =[[UIImageView alloc] initWithFrame:CGRectMake(90,10,20,25 )];
    [logoImageView setImage:logoImage];
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100,20)];
    myLabel.text = @"emPower";
    [myLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:18]];
    [myLabel setTextColor:[UIColor whiteColor]];
    [logoView addSubview:myLabel];
    [logoView addSubview:logoImageView];
    
     self.navigationItem.titleView = logoView;
 
    
}

// delegate method for the MKMapView
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:
(id <MKAnnotation>)annotation
{
    return nil; // we don't want any annotations
} // end method mapView:viewForAnnotation:


// called whenever the location manager updates the current location
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations != nil && locations.count > 0)
    {
        
        // we are not using deferred location updates, so always use the latest location
        CLLocation *newLocation = locations[0];
        
        if (self.crumbs == nil)
        {
            // This is the first time we're getting a location update, so create
            // the CrumbPath and add it to the map.
            //
            _crumbs = [[CrumbPath alloc] initWithCenterCoordinate:newLocation.coordinate];
            [self.mapView addOverlay:self.crumbs level:MKOverlayLevelAboveRoads];
            
            
            // default -boundingMapRect size is 1km^2 centered on coord
            
            
            // create a region centered around the new point
            MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
            // create a new MKCoordinateRegion centered around the new location
            MKCoordinateRegion region =
            MKCoordinateRegionMake(newLocation.coordinate, span);
            
            [self.mapView setRegion:region animated:YES];
        }
        else
        {
            // This is a subsequent location update.
            //
            // If the crumbs MKOverlay model object determines that the current location has moved
            // far enough from the previous location, use the returned updateRect to redraw just
            // the changed area.
            //
            // note: cell-based devices will locate you using the triangulation of the cell towers.
            // so you may experience spikes in location data (in small time intervals)
            // due to cell tower triangulation.
            //
            BOOL boundingMapRectChanged = NO;
            MKMapRect updateRect = [self.crumbs addCoordinate:newLocation.coordinate boundingMapRectChanged:&boundingMapRectChanged];
            if (boundingMapRectChanged)
            {
                // MKMapView expects an overlay's boundingMapRect to never change (it's a readonly @property).
                // So for the MapView to recognize the overlay's size has changed, we remove it, then add it again.
                [self.mapView removeOverlays:self.mapView.overlays];
                _crumbPathRenderer = nil;
                [self.mapView addOverlay:self.crumbs level:MKOverlayLevelAboveRoads];
                
                MKMapRect r = self.crumbs.boundingMapRect;
                MKMapPoint pts[] = {
                    MKMapPointMake(MKMapRectGetMinX(r), MKMapRectGetMinY(r)),
                    MKMapPointMake(MKMapRectGetMinX(r), MKMapRectGetMaxY(r)),
                    MKMapPointMake(MKMapRectGetMaxX(r), MKMapRectGetMaxY(r)),
                    MKMapPointMake(MKMapRectGetMaxX(r), MKMapRectGetMinY(r)),
                };
                NSUInteger count = sizeof(pts) / sizeof(pts[0]);
                MKPolygon *boundingMapRectOverlay = [MKPolygon polygonWithPoints:pts count:count];
                [self.mapView addOverlay:boundingMapRectOverlay level:MKOverlayLevelAboveRoads];
            }
            else if (!MKMapRectIsNull(updateRect))
            {
                // There is a non null update rect.
                // Compute the currently visible map zoom scale
                MKZoomScale currentZoomScale = (CGFloat)(self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width);
                // Find out the line width at this zoom scale and outset the updateRect by that amount
                CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
                updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
                // Ask the overlay view to update just the changed area.
                MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
                region.center.latitude = self.locationManager.location.coordinate.latitude;
                region.center.longitude = self.locationManager.location.coordinate.longitude;
                region.span.longitudeDelta = 0.005f;
                region.span.longitudeDelta = 0.005f;
                [mapView setRegion:region animated:YES];

                [self.crumbPathRenderer setNeedsDisplayInMapRect:updateRect];
            }
        }
    }

} // end method locationManager:didUpdateToLocation:fromLocation


// Write an error to console if the CLLocationManager fails
- (void)locationManager:(CLLocationManager *)manager didFailWithError:
(NSError *)error
{
    // stop using the location service if user disallowed access to it
    if ([error code] == kCLErrorDenied)
        [locationManager stopUpdatingLocation];
    
    NSLog(@"location manager failed"); // log location manager error
} // end method locationManager:didFailWithError:

// free Controller's memory
- (UIView *)customView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120, -250, 310, 120)];
    [label setText:[NSString stringWithFormat:@"%i",arc4random_uniform(20) + 60]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont fontWithName:@"OpenSans-Bold" size:70]];
    [label setShadowColor:[UIColor blackColor]];
    [label setShadowOffset:CGSizeMake(1, 1)];
    [view addSubview:label];
    
//    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    aButton.frame = CGRectMake(-60,-300,200,30);
//    UIImage *buttonImage = [UIImage imageNamed:@"menuButton.png"];
//    [aButton addTarget:self action:@selector(memuBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [view addSubview:aButton];
    
    CGRect rect = CGRectMake(0, 0, 310, 280);
    mapView = [[MKMapView alloc] initWithFrame:rect];
    mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.pausesLocationUpdatesAutomatically = NO;
    locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    mapView.showsUserLocation = YES;
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter= 10.0;
    
    //For Line Chart
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(8,5,290,85)];//(0, 0,310, 96)]; !!!!!
    [lineChart setXLabels:@[@"12am",@"6pm",@"12pm",@"6pm",@"12am"]];//@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]]; !!!!!
    NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = [UIColor whiteColor];//PNFreshGreen;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    lineChart.chartData = @[data01];//, data02]; !!!!!
    [lineChart strokeChart];
    
    
    self.progressBar= [[UIProgressView alloc] initWithFrame:CGRectMake(8, 40, 290, 120)];
    [_progressBar setProgressTintColor:[UIColor whiteColor]];
    self.progressBar.trackTintColor =[UIColor grayColor];
    _progressBar.layer.cornerRadius = 1;
    _progressBar.clipsToBounds = TRUE;
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
    label1.textColor = [UIColor whiteColor];
    
    
    for (NSInteger i = 0;i<3;i++)
    {
        CGRect  viewRect = CGRectMake(5, 140+(i)*100, 310, 96);
        UIView* btn = [[UIView alloc] initWithFrame:viewRect];
        
        btn.tag = i;
        
        
        if( btn.tag == 0){
            
            
            [btn addSubview: _progressBar];
            [btn addSubview: label1];
        }
        if (btn.tag ==1 ){
            [btn addSubview:lineChart];
            
            
        }
        if (btn.tag ==2) {
            
            [btn addSubview: mapView];
            
        }
        
        btn.layer.cornerRadius = 3;
        btn.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
        
        [view addSubview:btn];
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
        [btn addGestureRecognizer:longGesture];
        [self.itemArray addObject:btn];
        
    }
    return view;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // do some error handling
        }
            break;
        default:{
            [self.locationManager startUpdatingLocation];
        }
            break;
    }
}

#pragma mark - MapKit

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayRenderer *renderer = nil;
    
    if ([overlay isKindOfClass:[CrumbPath class]])
    {
        if (self.crumbPathRenderer == nil)
        {
            _crumbPathRenderer = [[CrumbPathRenderer alloc] initWithOverlay:overlay];
        }
        renderer = self.crumbPathRenderer;
    }
    else if ([overlay isKindOfClass:[MKPolygon class]])
    {
#if kDebugShowArea
        if (![self.drawingAreaRenderer.polygon isEqual:overlay])
        {
            _drawingAreaRenderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
            self.drawingAreaRenderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.25];
        }
        renderer = self.drawingAreaRenderer;
#endif
    }
    
    return renderer;
}
-(void)memuBarButtonItemPressed:(UIButton *) sender {
    
    NSLog(@"you clicked on button %@", sender.tag);
  
//    [[self drawControllerFromAppDelegate] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    
}



- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender
{
    
    UIButton *btn = (UIButton *)sender.view;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        startPoint = [sender locationInView:sender.view];
        originPoint = btn.center;
        [UIView animateWithDuration:Duration animations:^{
            
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            btn.alpha = 0.7;
        }];
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
        NSInteger index = [self indexOfPoint:btn.center withButton:btn];
        if (index<0)
        {
            contain = NO;
        }
        else
        {
            [UIView animateWithDuration:Duration animations:^{
                
                CGPoint temp = CGPointZero;
                UIButton *button = _itemArray[index];
                temp = button.center;
                button.center = originPoint;
                btn.center = temp;
                originPoint = btn.center;
                contain = YES;
                
            }];
        }
        
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:Duration animations:^{
            
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
            if (!contain)
            {
                btn.center = originPoint;
            }
        }];
    }
}


- (NSInteger)indexOfPoint:(CGPoint)point withButton:(UIButton *)btn
{
    for (NSInteger i = 0;i<_itemArray.count;i++)
    {
        UIButton *button = _itemArray[i];
        if (button != btn)
        {
            if (CGRectContainsPoint(button.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //View Area
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //reset offset when rotate
    [_glassScrollView scrollVerticallyToOffset:-_glassScrollView.foregroundScrollView.contentInset.top];
    
}


- (void)viewWillLayoutSubviews
{
    [_glassScrollView setTopLayoutGuideLength:[self.topLayoutGuide length]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - DrawerController

- (MMDrawerController *) drawControllerFromAppDelegate {
    AppDelegate *appDelegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    return appDelegate.drawerController;
}



@end
