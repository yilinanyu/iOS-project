//
//  myScrollView.m
//  ARSegmentPager
//
//  Created by Lina on 8/14/15.
//  Copyright (c) 2015 August. All rights reserved.


#import "myScrollView.h"
@implementation myScrollView


- (id)initWithFrame:(CGRect)frame {
    
    return [super initWithFrame:frame];
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    NSLog(@"touch scroll");
    // If not dragging, send event to next responder
    if (!self.dragging)
        [self.nextResponder touchesEnded: touches withEvent:event];
    else
        [super touchesEnded: touches withEvent: event];
}
@end

