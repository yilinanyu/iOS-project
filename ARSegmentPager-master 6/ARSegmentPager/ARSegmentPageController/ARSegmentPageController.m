//
//  ARSegmentPageController.m
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "ARSegmentPageController.h"
#import "ARSegmentView.h"

const void* _ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWOFFSET = &_ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWOFFSET;

@interface ARSegmentPageController ()

@property (nonatomic, strong) UIView<ARSegmentPageControllerHeaderProtocol> *headerView;
@property (nonatomic, strong) ARSegmentView *segmentView;
@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, assign) CGFloat segmentToInset;
@property (nonatomic, weak) UIViewController<ARSegmentControllerDelegate> *currentDisplayController;
//@property (nonatomic, strong) NSLayoutConstraint *headerHeightConstraint;

@end

@implementation ARSegmentPageController

#pragma mark - life cycle methods

-(instancetype)initWithControllers:(UIViewController<ARSegmentControllerDelegate> *)controller, ...
{
    self = [super init];
    if (self) {
        NSAssert(controller != nil, @"the first controller must not be nil!");
        [self _setUp];
        UIViewController<ARSegmentControllerDelegate> *eachController;
        va_list argumentList;
        if (controller)
        {
            [self.controllers addObject: controller];
            va_start(argumentList, controller);
            while ((eachController = va_arg(argumentList, id)))
            {
                [self.controllers addObject:eachController];
            }
            va_end(argumentList);
        }
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setUp];
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self _setUp];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self _baseConfigs];
    [self _baseLayout];
}

#pragma mark - public methods

-(void)setViewControllers:(NSArray *)viewControllers
{
    [self.controllers removeAllObjects];
    [self.controllers addObjectsFromArray:viewControllers];
}

#pragma mark - override methods

-(UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView
{
    return [[ARSegmentPageHeader alloc] init];
}

#pragma mark - private methdos

-(void)_setUp
{
    self.headerHeight = 200;
    self.segmentHeight = 44;
    self.segmentToInset = 200;
    self.segmentMiniTopInset = 0;
    self.controllers = [NSMutableArray array];
}

-(void)_baseConfigs
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self.view respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        self.view.preservesSuperviewLayoutMargins = YES;   
    }
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.headerView = [self customHeaderView];
    self.headerView.clipsToBounds = YES;
    [self.view addSubview:self.headerView];
    
    
    self.segmentView = [[ARSegmentView alloc] init];
    [self.segmentView.segmentControl addTarget:self
                                        action:@selector(segmentControlDidChangedValue:)
                              forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentView];
    
    
    NSMutableArray *titlesArray = [[NSMutableArray alloc] init];
    
    //all segment Title
    [self.controllers enumerateObjectsUsingBlock:^(UIViewController<ARSegmentControllerDelegate> *controller, NSUInteger idx, BOOL *stop) {
        NSString *title = [controller segmentTitle];
        [titlesArray addObject:title];
    }];
    
    
    self.segmentView.segmentControl = [self.segmentView.segmentControl initWithSectionTitles:titlesArray];
  
     self.segmentView.segmentControl.selectionIndicatorColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
     self.segmentView.segmentControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
     self.segmentView.segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
     self.segmentView.segmentControl.shouldAnimateUserSelection = YES;
    
    
    
    //defaut at index 0
    self.segmentView.segmentControl.selectedSegmentIndex = 0;
    UIViewController<ARSegmentControllerDelegate> *controller = self.controllers[0];
    [controller willMoveToParentViewController:self];
    [self.view insertSubview:controller.view atIndex:0];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    
    [self _layoutControllerWithController:controller];
    [self addObserverForPageController:controller];
    
    self.currentDisplayController = self.controllers[0];
    
}

-(void)_baseLayout
{
    //header
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.headerHeightConstraint = [NSLayoutConstraint constraintWithItem:self.headerView
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:0
                                                              multiplier:1
                                                                constant:self.headerHeight];
    
    [self.headerView addConstraint:self.headerHeightConstraint];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]];
    
   
    //segment
    self.segmentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.headerView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1 constant:0]];
    
    [self.segmentView addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:0
                                                                multiplier:1
                                                                  constant:self.segmentHeight]];
}

-(void)_layoutControllerWithController:(UIViewController<ARSegmentControllerDelegate> *)pageController
{
    UIView *pageView = pageController.view;
    
    if ([pageView respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        pageView.preservesSuperviewLayoutMargins = YES;
    }
    
    pageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:0]];
    
    UIScrollView *scrollView = [self scrollViewInPageController:pageController];
    
    if (scrollView)
    {
        scrollView.alwaysBounceVertical = YES;
        CGFloat topInset = self.headerHeight+self.segmentHeight;
        //fixed bootom tabbar inset
        CGFloat bottomInset = 0;
        
        if (self.tabBarController.tabBar.hidden == NO)
        {
            bottomInset = CGRectGetHeight(self.tabBarController.tabBar.bounds);
        }
        
        [scrollView setContentInset:UIEdgeInsetsMake(topInset, 0, bottomInset, 0)];
        [scrollView setScrollIndicatorInsets :UIEdgeInsetsMake(topInset, 0, bottomInset, 0)];
        
        
        // Fixed first time don't show header view
        // [scrollView setContentOffset:CGPointMake(0, -self.headerHeight-self.segmentHeight)];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
    }
    else
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.segmentView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1
                                                               constant:-self.segmentHeight]];
    }
    
}

-(UIScrollView *)scrollViewInPageController:(UIViewController <ARSegmentControllerDelegate> *)controller
{
    if ([controller respondsToSelector:@selector(streachScrollView)]) {
        return [controller streachScrollView];
    }else if ([controller.view isKindOfClass:[UIScrollView class]]){
        return (UIScrollView *)controller.view;
    }else{
        return nil;
    }
}

#pragma mark - add / remove obsever for page scrollView

-(void)addObserverForPageController:(UIViewController <ARSegmentControllerDelegate> *)controller
{
    UIScrollView *scrollView = [self scrollViewInPageController:controller];
    if (scrollView != nil) {
        [scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&_ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWOFFSET];
    }
}

-(void)removeObseverForPageController:(UIViewController <ARSegmentControllerDelegate> *)controller
{
    UIScrollView *scrollView = [self scrollViewInPageController:controller];
    if (scrollView != nil) {
        @try {
        [scrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
        }
        @catch (NSException *exception) {
            NSLog(@"exception is %@",exception);
        }
        @finally {
                
        }
    }
}

#pragma mark - obsever delegate methods

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == _ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWOFFSET)
    {
       // NSLog(@"offset: %@\nheader: %f\nmini inset = %f", change, self.headerHeightConstraint.constant, self.segmentToInset);
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGFloat offsetY = offset.y;
        CGPoint oldOffset = [change[NSKeyValueChangeOldKey] CGPointValue];
        CGFloat oldOffsetY = oldOffset.y;
        CGFloat deltaOfOffsetY = offset.y - oldOffsetY;
        CGFloat offsetYWithSegment = offset.y + self.segmentHeight;
        
        if (deltaOfOffsetY > 0)  // Slide up
        {
            NSLog(@" Slide up");
            // Follow the movement of the Offset change
            // NOTE: constant direct subtraction may become negative, resulting in confusion header position or crash
            if (self.headerHeightConstraint.constant - deltaOfOffsetY <= 0)
            {
                self.headerHeightConstraint.constant = self.segmentMiniTopInset;
                NSLog(@"== self.segmentMiniTopInset: %f", self.headerHeightConstraint.constant);
            }
            else
            {
                self.headerHeightConstraint.constant -= deltaOfOffsetY;
                NSLog(@"-= deltaOfOffsetY : %f",self.headerHeightConstraint.constant);
            }
            // If you reach the top of the fixed area , so do not continue to slide
            if (self.headerHeightConstraint.constant <= self.segmentMiniTopInset)
            {
                self.headerHeightConstraint.constant = self.segmentMiniTopInset;
                NSLog(@"<= self.segmentMiniTopInset: %f", self.headerHeightConstraint.constant);
            }
            
        }
        else
        {
            //When the slide down
            //If you have to scroll to the top of the screen listing
            //So keep the top bar at the top
            if (offsetY > 0)
            {
                if (self.headerHeightConstraint.constant <= self.segmentMiniTopInset)
                {
                    self.headerHeightConstraint.constant = self.segmentMiniTopInset;
                }
            }
            else
            {
                // If you have entered the top of the list screen
                // If you 've reached the bottom of the top bar
                if (self.headerHeightConstraint.constant >= self.headerHeight)
                {
                    // If the current list of the top bar of the bottom roll
                    // Then the top of the bar to continue to follow the larger , whether it remains unchanged
                    if (-offsetYWithSegment > self.headerHeight)
                    {
                        self.headerHeightConstraint.constant = -offsetYWithSegment;
                    }
                    else
                    {
                        self.headerHeightConstraint.constant = self.headerHeight;
                    }
                }
                else
                {
                    // Bar at the top of the case did not reach the bottom of the
                    // If not scroll to the bottom of the list of the top bar , then do nothing
                    // If you have reached the bottom of the top bar, then the top of the scroll bar to follow
                    if (self.headerHeightConstraint.constant < -offsetYWithSegment)
                    {
                        self.headerHeightConstraint.constant -= deltaOfOffsetY;
                    }
                }
            }
        }
        // Update `segmentToInset` variable , so that the external kvo know the top bar changes position
         self.segmentToInset = self.headerHeightConstraint.constant;
    }
}

#pragma mark - event methods

-(void)segmentControlDidChangedValue:(UISegmentedControl *)sender
{
    //remove obsever
    [self removeObseverForPageController:self.currentDisplayController];
    
    //add new controller
    NSUInteger index = [sender selectedSegmentIndex];
    UIViewController<ARSegmentControllerDelegate> *controller = self.controllers[index];
    
    [self.currentDisplayController willMoveToParentViewController:nil];
    [self.currentDisplayController.view removeFromSuperview];
    [self.currentDisplayController removeFromParentViewController];
    [self.currentDisplayController didMoveToParentViewController:nil];
    
    [controller willMoveToParentViewController:self];
    [self.view insertSubview:controller.view atIndex:0];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    
    // reset current controller
    self.currentDisplayController = controller;
    //layout new controller
    [self _layoutControllerWithController:controller];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    
    //trigger to fixed header constraint
    UIScrollView *scrollView = [self scrollViewInPageController:controller];
    if (self.headerHeightConstraint.constant != self.headerHeight) {
        if (scrollView.contentOffset.y >= -(self.segmentHeight + self.headerHeight) && scrollView.contentOffset.y <= -self.segmentHeight) {
            [scrollView setContentOffset:CGPointMake(0, -self.segmentHeight - self.headerHeightConstraint.constant)];
        }
    }
    //add obsever
    [self addObserverForPageController:self.currentDisplayController];
}

#pragma mark - manage memory methods

-(void)dealloc
{
    [self removeObseverForPageController:self.currentDisplayController];
}


@end
