//
//  ViewController.m
//  EmpowerDemo
//
//  Created by Lina on 7/30/15.
//  Copyright (c) 2015 empower. All rights reserved.
//


#import "BTGlassScrollViewController.h"
@import CoreLocation;
#define Duration 0.2
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "PNChart.h"



@interface BTGlassScrollViewController()<CLLocationManagerDelegate>
{
    BOOL contain;
    CGPoint startPoint;
    CGPoint originPoint;
    
}
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
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.view.backgroundColor = [UIColor blackColor];
    tracking = YES;
    
}

//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
//    NSLog(@"Callback");
//    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
//        NSLog(@"Authorized");
//        tracking = YES;
//
//    } else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
//        NSLog(@"Denied");
//        [locationManager stopUpdatingLocation];
//          NSLog(tracking ? @"Yes" : @"No");
//
//    }
//}
// called when the user in different view.
- (void)toggleTracking
{
    //    // if the app is currently tracking
    //    if (tracking)
    //    {
    //        tracking = NO; // stop tracking
    //
    //        // allow the iPhone to go to sleep
    //        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    //        [locationManager stopUpdatingLocation]; // stop tracking location
    //        [locationManager stopUpdatingHeading]; // stop tracking heading
    //        mapView.scrollEnabled = YES; // allow the user to scroll the map
    //        mapView.zoomEnabled = YES; // allow the user to zoom the map
    //
    //        // get the time elapsed since the tracking started
    //        float time = -[startDate timeIntervalSinceNow];
    //
    //        // format the ending message with various calculations
    //        NSString *message = [NSString stringWithFormat:
    //                             @"Distance: %.02f km, %.02f mi\nSpeed: %.02f km/h, %.02f mph",
    //                             distance / 1000, distance * 0.00062, distance * 3.6 / time,
    //                             distance * 2.2369 / time];
    //
    //        // create an alert that shows the message
    //        UIAlertView *alert = [[UIAlertView alloc]
    //                              initWithTitle:@"Statistics" message:message delegate:self
    //                              cancelButtonTitle:@"Return" otherButtonTitles:nil];
    //        [alert show]; // show the alert
    //         } // end if
    //    else // start tracking
    //    {
    tracking = YES; // start tracking
    mapView.scrollEnabled = NO; // prevent map scrolling by user
    mapView.zoomEnabled = NO; // prevent map zooming by user
    
    
    // keep the iPhone from going to sleep
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    distance = 0.0; // reset the distance
    //        [locationManager startUpdatingLocation]; // start tracking location
    [locationManager startUpdatingHeading]; // start tracking heading
    //        NSLog(@"%f",distance);
    // end else
} // end method toggleTracking


// delegate method for the MKMapView
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:
(id <MKAnnotation>)annotation
{
    return nil; // we don't want any annotations
} // end method mapView:viewForAnnotation:

// called whenever the location manager updates the current location
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    CLLocation *oldLocation = [locations objectAtIndex:locations.count-1];
    // add the new location to the map
    [trackingMapView addPoint:newLocation];
    // if there was a previous location
    if (oldLocation != nil)
    {
        // add distance from the old location to the total distance
        distance += [newLocation getDistanceFrom:oldLocation];
    }
    // create a region centered around the new point
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
    // create a new MKCoordinateRegion centered around the new location
    MKCoordinateRegion region =
    MKCoordinateRegionMake(newLocation.coordinate, span);
    
    // reposition the map to show the new point
    [mapView setRegion:region animated:YES];
} // end method locationManager:didUpdateToLocation:fromLocation

// called when the location manager updates the heading
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:
(CLHeading *)newHeading
{
    // calculate the rotation in radians
    float rotation = newHeading.trueHeading * M_PI / 180;
    
    // reset the transform
    mapView.transform = CGAffineTransformIdentity;
    
    // create a new transform with the angle
    CGAffineTransform transform = CGAffineTransformMakeRotation(-rotation);
    mapView.transform = transform; // apply the new transform
} // end method locationManager:didUpdateHeading:

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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, -250, 310, 120)];
    [label setText:[NSString stringWithFormat:@"%i",arc4random_uniform(20) + 60]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120]];
    [label setShadowColor:[UIColor blackColor]];
    [label setShadowOffset:CGSizeMake(1, 1)];
    [view addSubview:label];
    CGRect rect = CGRectMake(0, 0, 310, 280);
    mapView = [[MKMapView alloc] initWithFrame:rect];
    //    mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.pausesLocationUpdatesAutomatically = NO;
    // set locationManager's delegate to self
    locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //    else{
    //        [self.locationManager startUpdatingLocation];
    //    }
    
    
    mapView.showsUserLocation = YES;
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    
    trackingMapView =
    [[TrackingMapView alloc] initWithFrame:mapView.frame];
    
    // add the trackingMapView subview to mapView
    [mapView addSubview:trackingMapView];
    
    // set trackingMapView as mapView's delegate
    mapView.delegate = trackingMapView;
    
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
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [mapView setRegion:region animated:YES];
    
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


@end
