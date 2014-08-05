//
//  PlayingCardView.h
//  TestingUIView2
//
//  Created by Nicole on 7/20/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;

- (void)tap;
- (void)fadeCard;

@end
