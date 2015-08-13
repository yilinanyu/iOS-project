//
//  CustomPageControlExampleViewController.h
//  CustomPageControlExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXPageControl.h"
#import "ARSegmentPageController.h"


@interface ViewController : UIViewController <ARSegmentControllerDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *mainscrollview;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView1;

@property (nonatomic, strong) IBOutlet FXPageControl *pageControl1;

@property (nonatomic, strong) IBOutlet UIView *contentView1;

- (IBAction)pageControlAction:(FXPageControl *)sender;

@end
