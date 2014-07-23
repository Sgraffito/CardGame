//
//  PlayingCardView.m
//  TestingUIView2
//
//  Created by Nicole on 7/20/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation PlayingCardView

#pragma mark - Gestures

- (void)tap:(UITapGestureRecognizer *)tap {
    if ((tap.state == UIGestureRecognizerStateChanged) ||
        (tap.state == UIGestureRecognizerStateEnded)) {
        self.faceUp = !self.faceUp;
    }
}

#pragma mark - Properties

// Change both getter and setter for faceCardScaleFactor
@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

- (CGFloat)faceCardScaleFactor {
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor {
    _faceCardScaleFactor = faceCardScaleFactor;
    // If someone resets scaling, redraw the card
    [self setNeedsDisplay];
}

- (void)setSuit:(NSString *)suit {
    _suit = suit;
    // If someone changes the suit, redraw the card
    [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank {
    _rank = rank;
    // If someone changes the rank, redraw the card
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    // If someone changes the faceUpness, redraw the card
    [self setNeedsDisplay];
}

- (NSString *)rankAsString {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1.0;
    }
}
#pragma mark - Drawing

#define  CORNER_FONT_STANDARD_HEIGHT 100.0
#define  CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOfSet { return [self cornerRadius] / 3.0; }

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    // Modifies the UIView to looke like a rounded rectangle
    [roundedRect addClip];
    
    // Clipped view background color. Will only fill the rounded rectangle
    // Since UIView b/ground color is white by default, the sharp corners will still be white
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    // If the card is face up, draw the card's number and image
    if (self.faceUp) {
        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit]];
        
        // For face cards (KQJ), draw face image
        if (faceImage) {
             CGRect imageRect = CGRectInset(self.bounds,
                                            self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
                                            self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
            [faceImage drawInRect:imageRect];
        }
        // For numbers, draw pips
        else {
            [self drawPips];
        }
        
        // Draw corners for both face cards and numbers
        [self drawCorners];
    }
    
    // If the card is face down, draw the card back
    else {
        [[UIImage imageNamed:@"cardBack"] drawInRect:self.bounds];
    }
    
    // Draw black line around edge of card
//    [[UIColor blackColor] setStroke];
//    [roundedRect setLineWidth:2.0];
//    [roundedRect stroke];

}

#pragma mark - Draw Pips

#define PIP_HOOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void)drawPips {
    
    if ((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3)) {
        [self drawPipsWithHorizonalOffset:0
                           verticalOffset:0
                        mirroredVerticall:NO];
    }
    if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
        [self drawPipsWithHorizonalOffset:PIP_HOOFFSET_PERCENTAGE
                           verticalOffset:0
                        mirroredVerticall:NO];
    }
    if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10)) {
        [self drawPipsWithHorizonalOffset:0
                           verticalOffset:PIP_VOFFSET2_PERCENTAGE
                        mirroredVerticall:(self.rank != 7)];
    }
    if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8)
        || (self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizonalOffset:PIP_HOOFFSET_PERCENTAGE verticalOffset:PIP_VOFFSET3_PERCENTAGE mirroredVerticall:YES];
    }
    if ((self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizonalOffset:PIP_HOOFFSET_PERCENTAGE
                           verticalOffset:PIP_VOFFSET1_PERCENTAGE
                        mirroredVerticall:YES];
    }
}

#define  PIP_FONT_SCALE_FACTOR 0.012

- (void)drawPipsWithHorizonalOffset:(CGFloat)hoffset
                     verticalOffset:(CGFloat)voffset
                         upsideDown:(BOOL)upsideDown {
    if (upsideDown) {
        [self pushContextAndRotateUpsideDown];
    }
    CGPoint middle = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@ {NSFontAttributeName : pipFont }];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrgin = CGPointMake(
                                   middle.x - pipSize.width / 2.0 - hoffset * self.bounds.size.width,
                                   middle.y - pipSize.height / 2.0 - voffset * self.bounds.size.height);
    [attributedSuit drawAtPoint:pipOrgin];
    if (hoffset) {
        pipOrgin.x += hoffset * 2.0 * self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrgin];
    }
    if (upsideDown) {
        [self popContext];
    }
    
}

- (void)drawPipsWithHorizonalOffset:(CGFloat)hoffset
                     verticalOffset:(CGFloat)voffset
                  mirroredVerticall:(BOOL)mirroredVertically {
    
    [self drawPipsWithHorizonalOffset:hoffset
                       verticalOffset:voffset
                           upsideDown:NO];
    
    if (mirroredVertically) {
        [self drawPipsWithHorizonalOffset:hoffset
                           verticalOffset:voffset
                               upsideDown:YES];
    }
    
}

- (void)pushContextAndRotateUpsideDown {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext {
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}


- (void)drawCorners {
    
    // Paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    // Font style for corner text
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * ([self cornerScaleFactor] / 3) * 2];
    
    // Attributed string for corner text
    NSAttributedString *cornerText = [[NSAttributedString alloc]
                                      initWithString:[NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit]
                                      attributes:@{ NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle } ];
    
    // Draw upper-left corner text, does text alignment within rectangle
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOfSet], [self cornerOfSet]);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    // Draw lower-right corner text, rotates upper-left corner text
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
    [cornerText drawInRect:textBounds];
}

#pragma mark - Initialization

- (void)setUp {
    
    // No background color for UIView (will look black) IMPORTANT!
    self.backgroundColor = nil;
    
    // Makes the UIView background transparent
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

@end
