//
//  ViewController.h
//  EmpowerDemo
//
//  Created by Lina on 7/30/15.
//  Copyright (c) 2015 empower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTGlassScrollView.h"
#import <MapKit/MapKit.h>
#import "CoreLocation/CoreLocation.h"
#import "SWRevealViewController.h"



@interface BTGlassScrollViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{
    
    MKMapView *mapView; // represents the map
    CLLocationManager *locationManager; // provides location information
    float distance; // the distance traveled by the user
    NSDate *startDate; // stores the time when tracking began
    CLHeading *heading; // the compass heading of the iPhone
}
// declare our outlets as properties
@property (nonatomic,retain) MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) int index;
@property(nonatomic,strong) UIProgressView *progressBar;
@property(retain,nonatomic) UIView *CustomViewt;
@property(retain,nonatomic) UIView *view1;
@property(nonatomic, retain) UILabel *label1;
@property (nonatomic, strong) BTGlassScrollView *glassScrollView;
- (id)initWithImage:(UIImage *)image;
@end
