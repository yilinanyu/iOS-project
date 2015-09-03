//
//  myCellTableViewCell.m
//  ARSegmentPager
//
//  Created by Lina on 8/14/15.
//  Copyright (c) 2015 August. All rights reserved.
//

#import "myCell.h"

@implementation myCell

- (id)initWithFrame:(CGRect)frame {
    
    return [super initWithFrame:frame];

}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    NSLog(@"touch cell");
    // If not dragging, send event to next responder
    [super touchesEnded: touches withEvent: event];
}
//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
