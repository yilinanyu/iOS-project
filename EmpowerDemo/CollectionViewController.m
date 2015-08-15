//
//  CollectionViewController.m
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "CollectionViewController.h"
#import "FXPageControl.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView addGestureRecognizer:_scrollView.panGestureRecognizer];
    self.collectionView.panGestureRecognizer.enabled = NO;
    
    // Do any additional setup after loading the view.
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

-(NSString *)segmentTitle
{
    return @"collectionView";
}

-(UIScrollView *)streachScrollView
{
    return self.collectionView;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIScrollView*scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
  
    
    self.scrollView.pagingEnabled = YES;
    UIView* contentView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width*3, self.scrollView.bounds.size.height)];
    contentView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = contentView.frame.size;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:contentView];
    
    
    UIPageControl* pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 50, cell.frame.size.width, 50)];
    [pageControl setNumberOfPages:4];
    pageControl.defersCurrentPageDisplay = YES;

    
  if (indexPath.row == 0) {
      [[cell contentView] addSubview:scrollView];
      [[cell contentView] addSubview:pageControl];
        
        
    }else{
      cell.backgroundColor = [UIColor whiteColor];
     }
    
    return cell;
}


- (IBAction)pageControlAction:(FXPageControl *)sender
{
    //update scrollview when pagecontrol is tapped
    //    if (sender == self.pageControl1)
    //    {
//    CGPoint offset = CGPointMake(sender.currentPage * self.scrollView.bounds.size.width, 0);
//    [self.scrollView setContentOffset:offset animated:YES];
    //    }
    //    else
    //    {
    //        CGPoint offset = CGPointMake(sender.currentPage * self.scrollView2.bounds.size.width, 0);
    //        [self.scrollView2 setContentOffset:offset animated:YES];
    //    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //update page control when scrollview scrolls
//    //prevent flicker by only updating when page index has changed
//    NSInteger pageIndex = (NSInteger)(round(scrollView.contentOffset.x / scrollView.bounds.size.width));
    if (scrollView == self.scrollView)
    {
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.x = contentOffset.x - self.collectionView.contentInset.left;
        self.collectionView.contentOffset = contentOffset;
//      self.pageControl.currentPage = pageIndex;
//      self.pageControl.selectedDotColor = (pageIndex == 2)? [UIColor whiteColor]: [UIColor blackColor];
//     self.pageControl.dotColor = (pageIndex == 2)?
//        [UIColor colorWithWhite:1.0 alpha:0.25]: [UIColor colorWithWhite:0.0 alpha:0.25];
    }
    //    else
    //    {
    //        self.pageControl2.currentPage = pageIndex;
    //    }
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
