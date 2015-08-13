//
//  MyViewController.h
//  ARSegmentPager
//
//  Created by Aladin on 7/3/15.
//  Copyright (c) 2015 August. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"
#import "ARSegmentPageController.h"




@interface MyViewController : UIViewController  <ARSegmentControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@end
