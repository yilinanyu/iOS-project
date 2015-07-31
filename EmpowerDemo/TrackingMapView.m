// TrackingMapView.m
// A view that displays lines connecting coordinates on a MKMapView.
#import "TrackingMapView.h"
#import <MapKit/MKMapView.h>
static const int ARROW_THRESHOLD = 100;

@implementation TrackingMapView

// initialize the view
- (id)initWithFrame:(CGRect)frame
{
    // if the superclass initialized properly
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor]; // set the background
        points = [[NSMutableArray alloc] init]; // initialize points
    } // end if
    
    return self; // return this TrackingMapView
} // end method initWithFrame:

// called automatically when the view needs to be displayed
// this is where we do all of our drawing
- (void)drawRect:(CGRect)rect
{
    // no drawing needed if there is only one point or the view is hidden
    if (points.count == 1 || self.hidden)
        return; // exit the method
    
    // get the current graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 4.0); // set the line width
    CGPoint point; // declare the point CGPoint
    float distance = 0.0; // initialize distance to 0.0
    
    // loop through all of the points
    for (int i = 0; i < points.count; i++)
    {
        float f = (float)i; // cast i as a float and store in f
        
        // set the lines's color so that the whole line has a gradient
        CGContextSetRGBStrokeColor(context, 0, 1 - f / (points.count - 1),
                                   f / (points.count - 1), 0.8);
        
        // get the next location
        CLLocation *nextLocation = [points objectAtIndex:i];
        CGPoint lastPoint = point; // store point in lastPoint
        
        // get the view point for the given map coordinate
        point = [(MKMapView *)self.superview convertCoordinate:
                 nextLocation.coordinate toPointToView:self];
        
        // if this isn't the first point
        if (i != 0)
        {
            // move to the last point
            CGContextMoveToPoint(context, lastPoint.x, lastPoint.y);
            
            // add a line
            CGContextAddLineToPoint(context, point.x, point.y);
            
            // add the length of the line drawn to distance
            distance += sqrt(pow(point.x - lastPoint.x, 2) +
                             pow(point.y - lastPoint.y, 2));
            
            // if distance is large enough
            if (distance >= ARROW_THRESHOLD)
            {
                // load the arrow image
                UIImage *image = [UIImage imageNamed:@"arrow.png"];
                CGRect frame; // declare frame CGRect
            
                
                // calculate the point in the middle of the line
                CGPoint middle = CGPointMake((point.x + lastPoint.x) / 2,
                                             (point.y + lastPoint.y) / 2);
                
                // set frame's width to image's width
                frame.size.width = image.size.width;
                
                // set frame's height to image's height
                frame.size.height = image.size.height;
                
                // move frame’s origin’s x-coordinate halfway across the frame
                frame.origin.x = middle.x - frame.size.width / 2;
                
                // move frame’s origin’s y-coordinate halfway down the frame
                frame.origin.y = middle.y - frame.size.height / 2;
                
                // save the graphics state so we can restore it later
                CGContextSaveGState(context);
                
                // center the context where we want to draw the arrow
                CGContextTranslateCTM(context, frame.origin.x +
                                      frame.size.width / 2, frame.origin.y + \
                                      frame.size.height / 2);
                
                // calculate the angle at which to draw the arrow image
                float angle = atan((point.y - lastPoint.y) / (point.x -
                                                              lastPoint.x));
                
                // if this point is to the left of the last point
                if (point.x < lastPoint.x)
                    angle +=  3.14159; // increase angle by pi
                
                // rotate the context by the required angle
                CGContextRotateCTM(context, angle);
                
                // draw the image into the rotated context
                CGContextDrawImage(context, CGRectMake(-frame.size.width / 2,
                                                       -frame.size.height / 2, frame.size.width,
                                                       frame.size.height), image.CGImage);
                
                // restore context's original coordinate system
                CGContextRestoreGState(context);
                distance = 0.0; // reset distance
            } // end if
        } // end if
        
        CGContextStrokePath(context); // draw the path
    } // end for
} // end method drawRect:

// add a new point to the list
- (void)addPoint:(CLLocation *)point
{
    // store last element of point
    CLLocation *lastPoint = [points lastObject];
    
    // if new point is at a different location than lastPoint
    if (point.coordinate.latitude != lastPoint.coordinate.latitude ||
        point.coordinate.longitude != lastPoint.coordinate.longitude)
    {
        [points addObject:point]; // add the point
//        [self setNeedsDisplay]; // redraw the view
    } // end if
} // end method addPoint:

// remove all the points and update the display
- (void)reset
{
    [points removeAllObjects]; // remove all the points
    [self setNeedsDisplay]; // update the display
} // end method reset

// called by the MKMapView when the region is going to change
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:
(BOOL)animated
{
    self.hidden = YES; // hide the view during the transition
} // end method mapView:regionWillChangeAnimated:


// called by the MKMapView when the region has finished changing
- (void)mapView:(MKMapView *)mapView
regionDidChangeAnimated:(BOOL)animated
{
    self.hidden = NO; // unhide the view
    [self setNeedsDisplay]; // redraw the view
} // end method mapview:regionDidChangeAnimated:


@end // end TrackingMapView class implementation


