//
//  MapViewController.h
//  EmpowerDemo
//
//  Created by Lina on 8/5/15.
//  Copyright (c) 2015 empower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTGlassScrollViewController.h"
#import "BTGlassScrollView.h"

@interface MapViewController : UIViewController{

}
@property (nonatomic, strong) BTGlassScrollView *glassScrollView;
@property (nonatomic,retain) MKMapView *mapView;
@property (nonatomic, assign) CLLocationDistance distance;
@property (strong, nonatomic) BTGlassScrollViewController *viewController;
@end
