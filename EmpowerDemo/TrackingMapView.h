//  TrackingMapView.h
//  TrackingMapView interface declaration.
//  Implementation in TrackingMapView.m
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

// begin TrackingMapView interface declaration
@interface TrackingMapView : UIView <MKMapViewDelegate>
{
    NSMutableArray *points; // stores all points visited by the user
} // end instance variable declaration

- (void)addPoint:(CLLocation *)point; // add a new point to points
- (void)reset; // reset the MKMapView
@end // end interface TrackingMapView

