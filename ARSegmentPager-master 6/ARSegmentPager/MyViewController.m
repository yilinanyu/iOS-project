//
//  MyViewController.m
//  ARSegmentPager
//
//  Created by Aladin on 7/3/15.
//  Copyright (c) 2015 August. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController (){
    UIPageControl*pageControl;
    UIView *blueView;
    BOOL*pageControlIsChangingPage;
}

@end

@implementation MyViewController

- (void)viewDidLoad {
    pageControlIsChangingPage = NO;
    
    
    [super viewDidLoad];
    UIView *blueView = [[UIView alloc] init];
    blueView.frame = CGRectMake(0, 0, 600, 100);
    blueView.backgroundColor = [UIColor redColor];
    self.myScrollView.showsHorizontalScrollIndicator = NO;
//    self.myScrollView.contentSize=CGSizeMake(100,230);
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 600, 100)];
    [pageControl addTarget:self action:@selector(changepage:) forControlEvents:UIControlEventTouchUpInside];
    [blueView addSubview:pageControl];
    
    
   
    [self.myScrollView addSubview:blueView];
    pageControl.numberOfPages = 2;
   [self.myScrollView setContentSize:CGSizeMake(480, 0)];
    
 
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)changePage:(id)sender {
    pageControlIsChangingPage = YES;
    UIPageControl *pager=sender;
    int page = pager.currentPage;
    CGRect frame = _myScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_myScrollView scrollRectToVisible:frame animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (pageControlIsChangingPage)
        return;
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)segmentTitle
{
    return @"";
}

-(UIScrollView *)streachScrollView
{
    return self.myScrollView;
}




@end
