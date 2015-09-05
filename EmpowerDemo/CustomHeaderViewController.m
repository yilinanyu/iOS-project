//
//  CustomHeaderViewController.m
//  ARSegmentPager
//
//  Created by August on 15/5/20.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "CustomHeaderViewController.h"
#import "UIImage+ImageEffects.h"
#import "CustomHeader.h"
#import "ScrollDetailViewController.h"
//#import "CollectionViewController.h"
#import "ViewController.h"
#import "PNChart.h"
#import "RootViewController.h"

void *CusomHeaderInsetObserver = &CusomHeaderInsetObserver;

@interface CustomHeaderViewController ()

@end


@implementation CustomHeaderViewController

-(instancetype)init
{
//
//    TableViewController*collectionView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ScrollDetailViewControllerID"];
     UITableViewController *root = [[RootViewController alloc]init];
//    CollectionViewController *collectionView = [[CollectionViewController alloc] initWithNibName:@"CollectionViewController" bundle:nil];
//    ViewController *collectionView = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    

    self = [super initWithControllers:root, nil];
    if (self) {
        // your code
        self.segmentMiniTopInset = 64;
    }
    
    return self;
}

#pragma mark - override 

-(UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView
{
    CustomHeader *view = [[UIView alloc] initWithFrame: CGRectMake(0, 0,280,280)];
   self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background3.png"]];
    
    RFSegmentView* segmentView = [[RFSegmentView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 60) items:@[@"spring",@"summer",@"autumn"]];
    [view addSubview:segmentView];
    
    //circle chart
    PNCircleChart*circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 100.0) andTotal:[NSNumber numberWithInt:100] andCurrent:[NSNumber numberWithInt:60] andClockwise:NO];
    circleChart.backgroundColor = [UIColor clearColor];
    [circleChart setStrokeColor:PNGreen];
    [circleChart strokeChart];
    [view addSubview:circleChart];

    
    
    //For Bar Chart
    PNBarChart* barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 220, SCREEN_WIDTH, 100.0)];
    [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    [barChart setYValues:@[@1,  @10, @2, @6, @3]];
    [barChart strokeChart];
    barChart.backgroundColor = [UIColor clearColor];

    [view addSubview:barChart];

    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addObserver:self forKeyPath:@"segmentToInset" options:NSKeyValueObservingOptionNew context:CusomHeaderInsetObserver];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    
    [yourLabel setTextColor:[UIColor blackColor]];
    [yourLabel setBackgroundColor:[UIColor clearColor]];
    [yourLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];

    
    
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    if (context == CusomHeaderInsetObserver) {
        CGFloat inset = [change[NSKeyValueChangeNewKey] floatValue];
        
//        CustomHeaderViewController.title = "sdasdasdasdad";
        NSLog(@"inset is %f",inset);
        [self.view addSubview:yourLabel];
        
    }
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"segmentToInset"];
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

@end
