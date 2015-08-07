//
//  MapViewController.m
//  EmpowerDemo
//
//  Created by Lina on 8/5/15.
//  Copyright (c) 2015 empower. All rights reserved.
//

#import "MapViewController.h"
#import "BTGlassScrollViewController.h"


@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  
}


- (void)loadMap
{
    if (_distance > 0) {
        
        self.mapView.hidden = NO;
        
        
    } else {
        
        // no locations were found!
        self.mapView.hidden = NO;
        
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Error"
//                                  message:@"Sorry, this run has no locations saved."
//                                  delegate:self
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//        [alertView show];
    }
}
-(UIView *)configureView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];
    view.backgroundColor = UIColor.grayColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 20, 20)];
    [label setText:@"asdasdasd"];
    [label setTextColor:[UIColor whiteColor]];
    [view addSubview:label];
    [view addSubview: _mapView];
    return view;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
