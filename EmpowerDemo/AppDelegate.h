//
//  AppDelegate.h
//  EmpowerDemo
//
//  Created by Lina on 7/30/15.
//  Copyright (c) 2015 empower. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BTGlassScrollViewController.h"
#import "MMDrawerController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>
{
    CLLocation *locationManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MMDrawerController *drawerController;

@end
