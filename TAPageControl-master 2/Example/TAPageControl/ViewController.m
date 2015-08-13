//
//  ViewController.m
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-21.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

// Controllers
#import "ViewController.h"
// Views
#import "TAExampleDotView.h"
#import "TAPageControl.h"



@interface ViewController () <UIScrollViewDelegate, TAPageControlDelegate>

@property (weak, nonatomic) IBOutlet TAPageControl *customStoryboardPageControl;

//@property (strong, nonatomic) IBOutletCollection(UIScrollView) NSArray *scrollViews;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;


@property (strong, nonatomic) NSArray *imagesData;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@end


@implementation ViewController


#pragma mark - Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imagesData = @[@"image1.jpg", @"image2.jpg", @"image3.jpg", @"image4.jpg", @"image5.jpg", @"image6.jpg"];

    [self setupScrollViewImages];
    

    _scrollView1.delegate = self;

    // TAPageControl from storyboard
    self.customStoryboardPageControl.numberOfPages = self.imagesData.count;
    
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];


    
    _scrollView1.contentSize = CGSizeMake(CGRectGetWidth(_scrollView1.frame) * self.imagesData.count, CGRectGetHeight(_scrollView1.frame));
 
}


#pragma mark - ScrollView delegate



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    

        self.customStoryboardPageControl.currentPage = pageIndex;

}


#pragma mark - Utils


- (void)setupScrollViewImages
{
 
        [self.imagesData enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_scrollView1.frame) * idx, 0, CGRectGetWidth(_scrollView1.frame), CGRectGetHeight(_scrollView1.frame))];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.image = [UIImage imageNamed:imageName];
            [_scrollView1 addSubview:imageView];
        }];
    }

@end
