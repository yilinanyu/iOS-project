//
//  ScrollDetailViewController.h
//  EmpowerDemo
//
//  Created by Lina on 8/7/15.
//  Copyright (c) 2015 empower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollDetailViewController : UIViewController <UIScrollViewDelegate>
{
    UIPageControl *pageControl;
    BOOL pageControlBingUsed;
}
@property(nonatomic) CGPoint contentOffset;
@property (nonatomic,retain) UIPageControl *pageControl;
@property (nonatomic,retain) UIView *chartView;
@property (nonatomic,retain) UIScrollView *scrollView;
@end
