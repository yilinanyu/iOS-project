//
//  CustomHeaderViewController.h
//  ARSegmentPager
//
//  Created by August on 15/5/20.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "ARSegmentPageController.h"

@interface CustomHeaderViewController : ARSegmentPageController
@property (weak, nonatomic) UIImageView *imageView;
@property (nonatomic, assign) CGFloat segmentMiniTopInset;

@end
