//
//  ScrollViewController.m
//  ARSegmentPager
//
//  Created by Lina on 8/9/15.
//  Copyright (c) 2015 August. All rights reserved.
//

#import "ScrollDetailViewController.h"
#import "RFSegmentView.h"
@interface ScrollDetailViewController ()

@end

@implementation ScrollDetailViewController

@synthesize pageControl;
@synthesize scrollView;
@synthesize segmentView;

-(void)changePages:(id)sender{
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width*self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    pageControlBingUsed =YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

//    RFSegmentView* segmentView = [[RFSegmentView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 60) items:@[@"spring",@"summer",@"autumn",@"winnter"]];
//    segmentView.tintColor = [self getRandomColor];
    
    
    pageControlBingUsed = NO;
    
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    self.pageControl.backgroundColor = [UIColor grayColor];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 1;
    [self.pageControl addTarget:self action:@selector(changePages:) forControlEvents:UIControlEventValueChanged];
    
    
    
    
    //    // defien chart view
    //    self.chartView =[[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height/2)];
    
    
    
    // for back ground image of the chart view
    //    UIGraphicsBeginImageContext(self.chartView.frame.size);
    //    [[UIImage imageNamed:@"background3.png"] drawInRect:self.chartView.bounds];
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    self.chartView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // define scroll view
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.scrollView.contentSize=CGSizeMake(320,758);
    
    // define page controll
    
    
    [self.scrollView addSubview:self.pageControl];
    
    [self.view addSubview:self.scrollView];
//    [self.view addSubview:segmentView];
    
    
    
    
    self.navigationItem.title = @"Step Goal";
    
}


-(UIScrollView *)streachScrollView
{
    return scrollView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
    
}
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageControlBingUsed = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    
    //    [scrollView setContentOffset:CGPointMake(0,0)];
    
    self.contentOffset = self.scrollView.contentOffset;
    self.scrollView.contentOffset = CGPointZero;
    [self.scrollView setContentOffset:CGPointMake(0,0)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//
//-(NSString *)segmentTitle
//{
//    return @"ScrollView";
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
