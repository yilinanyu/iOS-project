//
//  ViewController.m
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "ViewController.h"
#import "CustomARSViewController.h"

@interface ViewController ()

- (IBAction)customHeader:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}



- (IBAction)customHeader:(id)sender
{
    [self.navigationController pushViewController:[[CustomARSViewController alloc] init] animated:YES];
}

@end
