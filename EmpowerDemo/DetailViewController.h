//
//  DetailViewController.h
//  EmpowerDemo
//
//  Created by Lina on 8/5/15.
//  Copyright (c) 2015 empower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTGlassScrollViewController.h"
#import "BTGlassScrollView.h"

@interface DetailViewController : UIViewController{

}
@property (nonatomic, strong) BTGlassScrollView *glassScrollView;
@property (nonatomic,retain) MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *Distance;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *pace;



@property (nonatomic, assign) CLLocationDistance distance;
@end