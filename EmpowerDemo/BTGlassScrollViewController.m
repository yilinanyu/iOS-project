//
//  BTGlassScrollViewController.m
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
#import "ARSegmentPageController.h"
#import "MenuTableViewController.h"
#import "ScrollDetailViewController.h"
#import "UIImage+ImageEffects.h"
#import "RFSegmentView.h"
#import "PNCircleChart.h"



@interface BTGlassScrollViewController()<ARSegmentControllerDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{
    BOOL contain;
    CGPoint startPoint;
    CGPoint originPoint;
    PNCircleChart* circleChart;
    
}

@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) UIImage *blurImage;
@property (nonatomic, strong) ARSegmentPageController *pager;
@property (nonatomic, strong) CrumbPath *crumbs;
@property (nonatomic, strong) CrumbPathRenderer *crumbPathRenderer;
@property (nonatomic, strong) MKPolygonRenderer *drawingAreaRenderer;   // shown if kDebugShowArea is set to 1
@property (strong , nonatomic) NSMutableArray *itemArray;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic,strong) PNLineChart*lineChart;
@property (nonatomic,strong) PNCircleChart * circleChart;
@property (nonatomic,strong) RFSegmentView* segmentView;
@end


@implementation BTGlassScrollViewController
@synthesize label1;
@synthesize mapView;
@synthesize locationManager;
@synthesize lineChart;
@synthesize circleChart;
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
    
    
    
    
    
    
    self.defaultImage = [UIImage imageNamed:@"background3.jpg"];
    self.blurImage = [[UIImage imageNamed:@"background3.jpg"] applyDarkEffect];
    
   
    ScrollDetailViewController*sc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ScrollDetailViewControllerID"];
    
    ARSegmentPageController *pager = [[ARSegmentPageController alloc] init];
    [pager setViewControllers:@[sc]];

    pager.freezenHeaderWhenReachMaxHeaderHeight = YES;
    pager.segmentMiniTopInset = 64;
    self.pager = pager;
    [self.pager addObserver:self forKeyPath:@"segmentToInset" options:NSKeyValueObservingOptionNew context:NULL];
    
   
    UIImage *image = [[UIImage imageNamed:@"menuButton.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *aButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(btnClicked:)];
    self.navigationItem.leftBarButtonItem = aButton;
    
    UIImage *image2 = [[UIImage imageNamed:@"menuButton.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:image2 style:UIBarButtonItemStylePlain target:self action:@selector(bbbtnClicked:)];
   
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    //drawer controller
//    SWRevealViewController *revealViewController = self.revealViewController;
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MenuTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MenuTableViewControllerID"];
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
//    [revealViewController setFrontViewController:navigationController animated:YES];
//    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.view.backgroundColor = [UIColor clearColor];
    mapView.delegate =self;
    
    
    
//    // for memu bar controller
//    self.title = NSLocalizedString(@"Front View", nil);
//    
//    SWRevealViewController *revealController = [self revealViewController];
//    
//    [revealController panGestureRecognizer];
//    [revealController tapGestureRecognizer];

    
//    //Add an image to your project & set that image here.
//    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuButton.png"]style:UIBarButtonItemStyleBordered target:revealController action:@selector(rightRevealToggle:)];
//    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
    
    

   
    
    UIImageView* logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
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



-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (UIColor *)getRandomColor
{
    UIColor *color = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    return color;
}

-(NSString *)segmentTitle
{
    return @"common";
}



// right menu button function
- (IBAction)bbbtnClicked:(id)sender {

    
    
//    ScrollDetailViewController*sc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ScrollDetailViewControllerID"];
    [self.navigationController pushViewController:self.pager animated:YES];
//    [self.navigationController pushViewController:sc animated:YES];
}



- (IBAction)btnClicked:(id)sender {
    
  
    MenuTableViewController *wc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuTableViewControllerID"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromLeft;
    [transition setType:kCATransitionPush];
//    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:wc animated:NO];
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
//    UIImageView* scoreView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIImage *scoreImage = [UIImage imageNamed:@"emPowerBolt@2x.png"];
    
    UIImageView *scoreImageView =[[UIImageView alloc] initWithFrame:CGRectMake(90,-220,29,60)];
    [scoreImageView setImage:scoreImage];
   
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(140, -250, 310, 120)];
    [label setText:[NSString stringWithFormat:@"%i",arc4random_uniform(20) + 60]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont fontWithName:@"OpenSans-Light" size:70]];
    [label setShadowColor:[UIColor blackColor]];
    [label setShadowOffset:CGSizeMake(1, 1)];
    [view addSubview:label];
    [view addSubview:scoreImageView];
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
    [mapView setScrollEnabled:NO];
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter= 10.0;
    
    //For Line Chart
    lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(8,5,290,85)];//(0, 0,310, 96)]; !!!!!
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
    
//    // In some View controller
//    UITapGestureRecognizer *tapGR;
//    tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    tapGR.numberOfTapsRequired = 1;
//    [mapView addGestureRecognizer:tapGR];
    
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
//// Add a delegate method to handle the tap and do something with it.
//-(void)handleTap:(UITapGestureRecognizer *)sender
//{
//    if (sender.state == UIGestureRecognizerStateEnded) {
//        // handling code
//        ScrollDetailViewController *controler = [[ScrollDetailViewController alloc] init];
//        [self.navigationController pushViewController:controler animated:YES];
//    }
//}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat topInset = [change[NSKeyValueChangeNewKey] floatValue];
 
     RFSegmentView* segmentView = [[RFSegmentView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 60) items:@[@"spring",@"summer",@"autumn"]];
    [self.pager.headerView.imageView addSubview:segmentView];
    
    
    
    
    //For BarC hart
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 100.0)];
    [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    [barChart setYValues:@[@1,  @10, @2, @6, @3]];
    [barChart strokeChart];
    [barChart setStrokeColor:PNWhite];
     barChart.backgroundColor = [UIColor clearColor];
    
    [self.pager.headerView.imageView addSubview:barChart];

    
    if (topInset <= self.pager.segmentMiniTopInset) {
        self.pager.title = @"Step Goal";
        self.pager.headerView.imageView.image = self.blurImage;
        [_segmentView removeFromSuperview];
        
    }else{
        self.pager.title = nil;
        self.pager.headerView.imageView.image = self.defaultImage;
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



@end
