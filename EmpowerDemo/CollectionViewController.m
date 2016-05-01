//
//  CollectionViewController.m
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    
    [super viewDidLoad];

//    self.scrollView1.pagingEnabled = YES;
//    self.contentView1.frame = CGRectMake(0, 0, self.contentView1.bounds.size.width, self.scrollView1.bounds.size.height);
//    //    self.scrollView1.contentSize = self.contentView1.bounds.size;
//    self.scrollView1.showsHorizontalScrollIndicator = NO;
//    [self.scrollView1 addSubview:self.contentView1];
//    self.pageControl1.numberOfPages = (NSInteger)(self.contentView1.bounds.size.width / self.scrollView1.bounds.size.width);
////    self.pageControl1.defersCurrentPageDisplay = YES;
//    [self.view addSubview:_scrollView1];
//    [self.view addSubview:_pageControl1];
//    _mainscrollview.contentSize = CGSizeMake(290,1080);
//    //自定义点的方式
//    self.customPageControl2               = [[TAPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView2.frame) - 40, CGRectGetWidth(self.scrollView2.frame), 40)];
//    self.customPageControl2.numberOfPages = self.imagesData.count;
//    // Custom dot view
//    self.customPageControl2.dotViewClass  = [TAExampleDotView class];
//    self.customPageControl2.dotSize       = CGSizeMake(12, 12);
//    
//    [self.wrapper2 addSubview:self.customPageControl2];
//    
//    //自定义点的图像的方式
//    self.customPageControl3                 = [[TAPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView3.frame) - 40, CGRectGetWidth(self.scrollView3.frame), 40)];
//    self.customPageControl3.numberOfPages   = self.imagesData.count;
//    // Custom dot view with image
//    self.customPageControl3.dotImage        = [UIImage imageNamed:@"dotInactive"];
//    self.customPageControl3.currentDotImage = [UIImage imageNamed:@"dotActive"];
//    
//    [self.wrapper3 addSubview:self.customPageControl3];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
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
    return 10;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    if (indexPath.section == 0) {
        
        
        
//        self.scrollView1.pagingEnabled = YES;
//        self.scrollView1.backgroundColor = [UIColor greenColor];
//        self.contentView1.frame = CGRectMake(0, 0, self.contentView1.bounds.size.width, self.scrollView1.bounds.size.height);
//        //    self.scrollView1.contentSize = self.contentView1.bounds.size;
//        self.scrollView1.showsHorizontalScrollIndicator = NO;
//        [self.scrollView1 addSubview:self.contentView1];
//       
//       
//        self.pageControl1.numberOfPages = (NSInteger)(self.contentView1.bounds.size.width / self.scrollView1.bounds.size.width);
//        self.pageControl1.defersCurrentPageDisplay = YES;
//        [cell addSubview:_scrollView1];
//        [cell addSubview:_pageControl1];
//        _mainscrollview.contentSize = CGSizeMake(290,1080);
        

        _scrollView1 = [[UIScrollView alloc] init];
        _scrollView1.frame = CGRectMake(0, 0,cell.frame.size.width, cell.frame.size.height);
        _scrollView1.contentSize = CGSizeMake(1280,100);
        _scrollView1.backgroundColor = [UIColor greenColor];
        _scrollView1.maximumZoomScale = 1.0;
        _scrollView1.minimumZoomScale = 1.0;
        _scrollView1.clipsToBounds = YES;
        _scrollView1.showsHorizontalScrollIndicator = NO;
        _scrollView1.showsVerticalScrollIndicator = NO;
        
        _scrollView1.pagingEnabled = YES;
        [cell addSubview:_scrollView1];
        // Init Page Control
        _pageControl1 = [[UIPageControl alloc] init];
        _pageControl1.frame = CGRectMake(50, 20, 20, 20);
        _pageControl1.numberOfPages = 4;
        _pageControl1.currentPage = 2;
        [cell addSubview:_pageControl1];
        
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}
//- (IBAction)pageControlAction:(UIPageControl *)sender
//{
//    //update scrollview when pagecontrol is tapped
//    //    if (sender == self.pageControl1)
//    //    {
//    CGPoint offset = CGPointMake(sender.currentPage * self.scrollView1.bounds.size.width, 0);
//    [self.scrollView1 setContentOffset:offset animated:YES];
//    //    }
//    //    else
//    //    {
//    //        CGPoint offset = CGPointMake(sender.currentPage * self.scrollView2.bounds.size.width, 0);
//    //        [self.scrollView2 setContentOffset:offset animated:YES];
//    //    }
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    //update page control when scrollview scrolls
//    //prevent flicker by only updating when page index has changed
//    NSInteger pageIndex = (NSInteger)(round(scrollView.contentOffset.x / scrollView.bounds.size.width));
//    if (scrollView == self.scrollView1)
//    {
//        self.pageControl1.currentPage = pageIndex;
//        self.pageControl1.selectedDotColor = (pageIndex == 2)? [UIColor whiteColor]: [UIColor blackColor];
//        self.pageControl1.dotColor = (pageIndex == 2)?
//        [UIColor colorWithWhite:1.0 alpha:0.25]: [UIColor colorWithWhite:0.0 alpha:0.25];
//    }
//    //    else
//    //    {
//    //        self.pageControl2.currentPage = pageIndex;
//    //    }
//}


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
