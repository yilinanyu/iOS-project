//
//  TableViewController.m
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
     //使用代理方法实现翻页效果
    
   
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==scrollview)
    {
        int page= scrollview.contentOffset.x/320;
        pagecontrol.currentPage=page;
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(NSString *)segmentTitle
//{
//    return @"TableView";
//}

-(UIScrollView *)streachScrollView
{
   return self.tableView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
    //分页设置
    scrollview.backgroundColor = [UIColor blueColor];
    scrollview.pagingEnabled=YES;
    //滚动条显示设置
    scrollview.showsHorizontalScrollIndicator=NO;
    scrollview.showsVerticalScrollIndicator=NO;
    //视图内容的尺寸
    //    scrollview.contentSize=CGSizeMake(320*4, 150);
    //    self.tableView.tableHeaderView=scrollview;
    scrollview.delegate=self;
    //添加内容
    //    float x=0;
    //    for (int i=1; i<=4; i++)
    //    {
    //        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(x, 0, 320, 150)];
    //        NSString *imagename=[NSString stringWithFormat:@"%d.jpg",i];
    //        imageview.image=[UIImage imageNamed:imagename];
    //        [scrollview addSubview:imageview];
    //        x+=320;
    //    }
    //    self.tableView.tableHeaderView=scrollview;
    
    
    //创建分页控制器，添加到tableview中
    pagecontrol=[[UIPageControl alloc]initWithFrame:CGRectMake(200, 130, 20, 20)];
    //总得页数
    pagecontrol.numberOfPages=4;
    //当前显示的页数
    pagecontrol.currentPage=0;
    [scrollview addSubview:pagecontrol];

    
    [cell addSubview:scrollview];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
