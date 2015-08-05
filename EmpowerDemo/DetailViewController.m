//
//  DetailViewController.m
//  EmpowerDemo
//
//  Created by Lina on 8/5/15.
//  Copyright (c) 2015 empower. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background3.png"]];
//    [self loadMap];
}
- (void)loadMap
{
    if (_distance > 0) {
        
        self.mapView.hidden = NO;
        
        
    } else {
        
        // no locations were found!
        self.mapView.hidden = NO;
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Sorry, this run has no locations saved."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
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
