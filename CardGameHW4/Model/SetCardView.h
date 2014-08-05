//
//  SetCardView.h
//  CardGameHW4
//
//  Created by Nicole on 7/23/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic) NSString *symbol;
@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL faceUp;

- (void)tap;
- (void)fadeCard;
- (void)flipCardOver;

@end
