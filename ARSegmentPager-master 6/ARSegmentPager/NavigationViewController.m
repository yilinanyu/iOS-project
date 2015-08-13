//
//  NavigationViewController.m
//  ARSegmentPager
//
//  Created by August on 15/5/9.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName,
                                               [UIFont systemFontOfSize:18],
                                               NSFontAttributeName, nil];
    
    [self.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    
    [self.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTranslucent:YES];
   [ [UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}


-(UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



@end
