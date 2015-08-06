//
//  AppDelegate.h
//  EmpowerDemo
//
//  Created by Lina on 7/30/15.
//  Copyright (c) 2015 empower. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BTGlassScrollViewController.h"
#import "SWRevealViewController.h"
#import "MenuTableViewController.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate, UIScrollViewDelegate>
{
    CLLocation *locationManager;
    UIScrollView *scrollview;
    UIView* customView;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *viewController;

@property (strong, nonatomic) BTGlassScrollViewController
*scrollviewController;
@property (strong, nonatomic) MenuTableViewController
*menutableviewController;

@end
