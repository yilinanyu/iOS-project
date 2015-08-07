//
//  DetailViewController.m
//  EmpowerDemo
//
//  Created by Lina on 8/6/15.
//  Copyright (c) 2015 empower. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImage *done = [[UIImage imageNamed:@"menuButton.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *donebutton = [[UIBarButtonItem alloc] initWithImage:done style:UIBarButtonItemStylePlain target:self action:@selector(Back:)];
    self.navigationItem.title = @"Settings";
    self.navigationItem.rightBarButtonItem = donebutton;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Back:(id)sender {
      [self dismissViewControllerAnimated:YES completion:nil];
    
//    MenuTableViewController *wc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuTableViewControllerID"];
//    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.45;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//    transition.type = kCATransitionFromLeft;
//    [transition setType:kCATransitionPush];
//    //    transition.subtype = kCATransitionFromLeft;
//    transition.delegate = self;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    
//    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController pushViewController:wc animated:NO];
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
