//
//  GridView.m
//  CardGameHW4
//
//  Created by Nicole on 7/29/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "GridView.h"

@implementation GridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setUp {
    // Set the background color of the grid view to clear
    self.backgroundColor = nil;
    self.opaque = NO;
}

- (void)awakeFromNib {
    [self setUp];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
