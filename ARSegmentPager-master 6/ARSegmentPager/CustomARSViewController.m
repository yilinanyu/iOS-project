//
//  CustomHeaderViewController.m
//  ARSegmentPager
//
//  Created by August on 15/5/20.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "CustomARSViewController.h"
#import "TableViewController.h"
#import "UIImage+ImageEffects.h"
#import "CustomHeader.h"
#import "MyViewController.h"

void *CusomHeaderInsetObserver = &CusomHeaderInsetObserver;

@interface CustomARSViewController ()
    @property (nonatomic) BOOL isExpanded; // status if the header
    @property (nonatomic, strong) UIImage *originalImage;
@end

@implementation CustomARSViewController

-(instancetype)init
{
//    TableViewController *table          = [[TableViewController alloc] init];
     MyViewController   *myview = [[MyViewController alloc]init];

    self = [super initWithControllers:myview,nil];
    
    if (self)
    {
        self.segmentMiniTopInset = 64;
        self.segmentHeight = 0;
        self.headerHeight = 300;
        self.isExpanded = NO;
    }
    
    return self;
}

#pragma mark - override 

-(UIView*)customHeaderView
{
    CustomHeader *view = [[[NSBundle mainBundle] loadNibNamed:@"CustomHeader" owner:nil options:nil] lastObject];
    
    self.originalImage = [self takeSnapshotOfView:view.imageView];
    
    return view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self addObserver:self forKeyPath:@"segmentToInset" options:NSKeyValueObservingOptionNew context:CusomHeaderInsetObserver];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    if (context == CusomHeaderInsetObserver) {
       CGFloat inset = [change[NSKeyValueChangeNewKey] floatValue];
       //NSLog(@"inset is %f",inset);
        //NSLog(@"inset is %f",inset);
        UILabel *lbl1 = [[UILabel alloc] init];
        [lbl1 setFrame:CGRectMake(155,30,100,20)];
        lbl1.backgroundColor=[UIColor clearColor];
        lbl1.textColor=[UIColor whiteColor];
        lbl1.userInteractionEnabled=YES;
        
        lbl1.text= @"TEST";
        
        if (inset<=self.segmentMiniTopInset)
        {
            [self.headerView.imageView addSubview:lbl1];
        }
        
      
        
    }
}

- (UIImage *)takeSnapshotOfView:(UIView *)view
{
  /*  UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    */
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return screenShot;
}

- (UIImage *)blurWithImageEffects:(UIImage *)image withRadius: (NSInteger)blurRadius
{
    return [image applyBlurWithRadius:blurRadius tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
}



-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"segmentToInset"];
}

 // known bug, the expand behaviour is broken maybe because the ARSegmentedPager change the constraint of height also
-(void) headerTapped
{
    
    if (self.isExpanded)
    {
   
         self.headerHeightConstraint.constant = self.headerHeight ;
        [UIView animateWithDuration:0.5
                         animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.isExpanded = NO;
        }];
    
    }
    else
    {
        self.headerHeightConstraint.constant = [UIScreen mainScreen].bounds.size.height - ([UIScreen mainScreen].bounds.size.height * 0.3) ;
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             self.isExpanded = YES;
                         }];
    }

}


- (void)backgroundGradientColor:(UIColor*) bottomColor
{
    //build gradient with top clear
    UIColor *topColor = [UIColor clearColor];
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithInt:0.0],[NSNumber numberWithInt:1.0], nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = gradientLocations;
  //  gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(_labelBackground.frame), CGRectGetHeight(_labelBackground.frame));
    
   // [_labelBackground.layer insertSublayer:gradientLayer atIndex:0];
}

@end
