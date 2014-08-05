//
//  GameOverView.m
//  CardGameHW4
//
//  Created by Nicole on 8/1/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "GameOverView.h"

@implementation GameOverView

#pragma mark - Initialization

- (void)setUp {
    
    // No background color for UIView (makes corners transparent)
    self.backgroundColor = nil;
    
    // Makes teh UIView background transparent
    self.opaque = NO;
}

- (void)awakeFromNib {
    [self setUp];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Drawing

#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_RADIUS; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * .15 * [self cornerScaleFactor]; }

- (void)drawRect:(CGRect)rect {
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    UIColor *seaGreen = [UIColor colorWithRed:102 / 255.0 green:200 / 255.0 blue:150 / 255.0 alpha:1.0];
    [seaGreen setFill];
    UIRectFill(self.bounds);
    
    [self drawText];
}

- (void)drawText {
    
    // Paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    // Font style for game over
    UIFont *gameOverFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    gameOverFont = [gameOverFont fontWithSize:gameOverFont.pointSize * ([self cornerScaleFactor] / 7)];
    
    // Font style for click to redeal
    UIFont *clickFont = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    clickFont = [clickFont fontWithSize:clickFont.pointSize * ([self cornerScaleFactor] / 7)];
    
    // Font color
    UIColor *dkBlue = [UIColor colorWithRed:2 / 255.0 green:19 / 255.0 blue:61 / 255.0 alpha:1.0];
    
    // Game over text
    NSAttributedString *gameOverText = [[NSAttributedString alloc]
                                      initWithString:[NSString stringWithFormat:@"GAME OVER"]
                                      attributes:@{
                                                   NSFontAttributeName: gameOverFont,
                                                   NSParagraphStyleAttributeName : paragraphStyle,
                                                   NSForegroundColorAttributeName : dkBlue
                                                   }];
    
    // Click to restart text
    NSAttributedString * clickText = [[NSAttributedString alloc]
                                      initWithString:[NSString stringWithFormat:@"click to redeal"]
                                      attributes: @{NSFontAttributeName : clickFont,
                                                    NSParagraphStyleAttributeName : paragraphStyle,
                                                    NSForegroundColorAttributeName : dkBlue
                                                    }];
    
    // Bounds for text
    CGRect textBounds = CGRectMake(0,
                                   (self.bounds.size.height / 2) - gameOverFont.pointSize,
                                   self.bounds.size.width,
                                   self.bounds.size.height);
    
    CGRect textBounds2 = CGRectMake(0,
                                    (self.bounds.size.height / 2) + clickFont.pointSize / 4,
                                    self.bounds.size.width,
                                    self.bounds.size.height);
    
    // Add text to view
    [gameOverText drawInRect:textBounds];
    [clickText drawInRect:textBounds2];
}

@end
