//
//  CollectionViewController.h
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSegmentControllerDelegate.h"
#import "FXPageControl.h"

@interface CollectionViewController : UICollectionViewController<ARSegmentControllerDelegate>
@property (weak, nonatomic) UIScrollView *scrollView;

@property (nonatomic, strong) FXPageControl *pageControl;

@property (nonatomic, strong)  UIView *contentView;

- (IBAction)pageControlAction:(FXPageControl *)sender;
@end
