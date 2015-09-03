//
//  RootViewController.h
//  ARSegmentPager
//
//  Created by Lina on 8/14/15.
//  Copyright (c) 2015 August. All rights reserved.
//

#import <UIKit/UIKit.h>

@class myCell;
@class myScrollView;

@interface RootViewController : UITableViewController {
    
    myCell *cell;
    myScrollView *scrollView;
    UIPageControl *pageControl;
    UIView *contentView;
}

@end