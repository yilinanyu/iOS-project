//
//  CollectionViewController.h
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXPageControl.h"
#import "ARSegmentControllerDelegate.h"

@interface CollectionViewController : UICollectionViewController<ARSegmentControllerDelegate>
@property (strong, nonatomic)  UIScrollView *mainscrollview;

@property (nonatomic, strong)  UIScrollView *scrollView1;

@property (nonatomic, strong)  UIPageControl *pageControl1;

@property (nonatomic, strong)  UIView *contentView1;

- (IBAction)pageControlAction:(UIPageControl *)sender;
@end
