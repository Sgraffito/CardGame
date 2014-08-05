//
//  SetCardView.m
//  CardGameHW4
//
//  Created by Nicole on 7/23/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "SetCardView.h"


@implementation SetCardView

#pragma mark - Gestures

- (void)tap {
    [self animateCard];
}

- (void)animateCard {
    [SetCardView transitionWithView:(UIView *)self
                           duration:1.0
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             self.selected = !self.selected;
                         }
                         completion:nil];
}

- (void)fadeCard {
    [SetCardView transitionWithView:(UIView *)self
                               duration:1.0
                                options:UIViewAnimationOptionTransitionNone
                             animations:^ {
                                 self.alpha = 0.5;
                             }
                             completion:nil];
}
- (void)flipCardOver {
    [SetCardView transitionWithView:(UIView *)self
                           duration:1.0
                            options:UIViewAnimationOptionTransitionFlipFromRight
                         animations:^ {
                             self.faceUp = !self.faceUp;
                         }
                         completion:nil];
}

#pragma mark - Properties

- (void)setSymbol:(NSString *)symbol {
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number {
    _number = number;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading {
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CORNER_RADIUS 10.0

- (CGFloat)cornerRadius {
    return self.bounds.size.height / CORNER_RADIUS;
}
- (CGFloat)lineWidth {
    return self.bounds.size.height / 30.0;
}

 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
{
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(currentContext);
    
    {
        // Gives the UIView rounded edges
        UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
        [roundedRect addClip];
        
        UIColor *selectedCard = [UIColor colorWithRed:98/255.0 green:206/255.0 blue:255/255.0 alpha:1];
        
        // If card is face down, draw the card's back
        if (!self.faceUp) {
            [[UIImage imageNamed:@"cardBack"] drawInRect:self.bounds];
        }
        
        else {
            // If the card is selected, change the background color to blue
            if (self.selected) {
                [selectedCard setFill];
                UIRectFill(self.bounds);
            }
            
            // If the card is face-up and unselected, make the background color white
            else {
                // Give the rounded rectangle a background color
                [[UIColor whiteColor] setFill];
                UIRectFill(self.bounds);
            }
            
            // Draw the shapes (oval, diamond, or squiggle) on the card
            [self drawShapes:(currentContext)];
        }
    }
    
    CGContextRestoreGState(currentContext);
}

- (void)drawShapes:(CGContextRef)context {
    
    // Colors used for shapes
    UIColor *purple = [UIColor colorWithRed:114/255.0 green:9/255.0 blue:178/255.0 alpha:1.0];
    UIColor *red = [UIColor colorWithRed:207/255.0 green:31/255.0 blue:10/255.0 alpha:1.0];
    UIColor *green = [UIColor colorWithRed:16/255.0 green:140/255.0 blue:11/255.0 alpha:1.0];

    // Set purple color
    if ([self.color isEqual:purple] && [self.shading isEqual:@"solid"]) {
        [purple set];
    }
    else if ([self.color isEqual:purple] && [self.shading isEqual:@"outline"]) {
        [[UIColor clearColor] setFill];
        [purple setStroke];
    }
    else if ([self.color isEqual:purple] && [self.shading isEqual:@"open"]) {
        UIColor *solidColor = self.color;
        UIColor *transparentColor = [solidColor colorWithAlphaComponent:0.25];
        [transparentColor setFill];
        [purple setStroke];
    }

    // Set red color
    else if ([self.color isEqual:red] && [self.shading isEqual:@"solid"]) {
        [red set];
    }
    else if ([self.color isEqual:red] && [self.shading isEqual:@"outline"]) {
        [[UIColor clearColor] setFill];
        [red setStroke];
    }
    else if ([self.color isEqual:red] && [self.shading isEqual:@"open"]) {
        UIColor *solidColor = self.color;
        UIColor *transparentColor = [solidColor colorWithAlphaComponent:0.25];
        [transparentColor setFill];
        [red setStroke];
    }

    // Set green color
    else if ([self.color isEqual:green] && [self.shading isEqual:@"solid"]) {
        [green set];
    }
    else if ([self.color isEqual:green] && [self.shading isEqual:@"outline"]) {
        [[UIColor clearColor] setFill];
        [green setStroke];
    }
    else if ([self.color isEqual:green] && [self.shading isEqual:@"open"]) {
        UIColor *solidColor = self.color;
        UIColor *transparentColor = [solidColor colorWithAlphaComponent:0.25];
        [transparentColor setFill];
        [green setStroke];
    }

    // If number of shapes is 1
    if (self.number == 1) {
        
        // Squiggles
        if ([self.symbol isEqualToString:@"squiggle"]) {
            [self draw1Squiggle:context];
        }
        // Diamonds
        else if ([self.symbol isEqualToString:@"diamond"]) {
            [self draw1Diamond:context];
        }
        // Ovals
        else if ([self.symbol isEqualToString:@"oval"]) {
            [self draw1Oval:context];
        }
    }
    
    else if (self.number == 2) {
        
        if ([self.symbol isEqualToString:@"squiggle"]) {
            [self draw2Squiggles:context];
        }
        else if ([self.symbol isEqualToString:@"diamond"]) {
            [self draw2Diamonds:context];
        }
        else if ([self.symbol isEqualToString:@"oval"]) {
            [self draw2Ovals:context];

        }
    }
    
    else if (self.number == 3) {
        
        if ([self.symbol isEqualToString:@"squiggle"]) {
            [self draw3Squiggles:context];
        }
        else if ([self.symbol isEqualToString:@"diamond"]) {
            [self draw3Diamonds:context];
        }
        else if ([self.symbol isEqualToString:@"oval"]) {
            [self draw3Ovals:context];
        }
    }
}

#define SHAPE_SCALE 5.0
#define GAP_SCALE 5.0

- (int)calculateShapeWidth {
    int width = self.bounds.size.width;
    int shapeSize = (width * SHAPE_SCALE) / 15;
    return shapeSize;
}

- (int)calculateShapeHeight {
    int height = self.bounds.size.height;
    int shapeHeight = (height * SHAPE_SCALE) / 35;
    return shapeHeight;
}

- (int)calculateSquiggleWidth {
    int width = self.bounds.size.height;
    int squiggleWidth = (width * SHAPE_SCALE) / 40;
    return squiggleWidth;
}

- (int)calculateShapeCurve {
    int width = self.bounds.size.width;
    int shapeCurve = (width * SHAPE_SCALE) / 30;
    return shapeCurve;
}

- (int)calculateGapSize {
    int width = self.bounds.size.width;
    int gapSize = (width * GAP_SCALE) / 30;
    return gapSize;
}

#pragma mark - Draw 1 Shape

- (void)draw1Squiggle:(CGContextRef)context {

    // Save the current drawing setup
    CGContextSaveGState(context);
    
    {
        
        UIBezierPath *squiggle = [[UIBezierPath alloc] init];
        // Upper left-hand corner
        [squiggle moveToPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateSquiggleWidth] / 2),
                                          self.bounds.size.height / 2 - ([self calculateShapeHeight] / 2))];
        // Upper right-hand corner
        [squiggle addLineToPoint:CGPointMake(self.bounds.size.width / 2 + ([self calculateSquiggleWidth] / 2),
                                          self.bounds.size.height / 2 - ([self calculateShapeHeight] / 2))];
        // Right curve
        [squiggle addQuadCurveToPoint:CGPointMake(self.bounds.size.width / 2 + ([self calculateSquiggleWidth] / 2),
                                                  self.bounds.size.height / 2 + ([self calculateShapeHeight] / 2))
                         controlPoint:CGPointMake(self.bounds.size.width / 2 + ([self calculateSquiggleWidth] / 2) + 2 * ([self calculateShapeCurve]),
                                                  self.bounds.size.height / 2 - ([self calculateShapeHeight] / 2) - 1.5 * ([self calculateShapeCurve]))];
        // Lower left-hand corner
        [squiggle addLineToPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateSquiggleWidth] / 2),
                                             self.bounds.size.height / 2 + ([self calculateShapeHeight] / 2))];
        // Back to upper left-hand corner
        [squiggle addQuadCurveToPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateSquiggleWidth] / 2),
                                                  self.bounds.size.height / 2 - ([self calculateShapeHeight] / 2))
                         controlPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateSquiggleWidth] / 2) - 2 * ([self calculateShapeCurve]),
                                                  self.bounds.size.height / 2 + ([self calculateShapeHeight] / 2) + 1.5 * ([self calculateShapeCurve]))];
        [squiggle closePath];
        [squiggle fill];
        [squiggle setLineWidth:[self lineWidth]];
        [squiggle stroke];
    }
    
    // Restore current drawing setup
    CGContextRestoreGState(context);

}

- (void)draw1Oval:(CGContextRef)context {
    
    // Save the current drawing setup
    CGContextSaveGState(context);

    {
        // Draw the oval
        UIBezierPath *oval = [[UIBezierPath alloc] init];
        
        // Upper-left corner
        [oval moveToPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateShapeWidth] / 2),
                                      self.bounds.size.height / 2 - ([self calculateShapeHeight] / 2))];
        // Upper-right corner
        [oval addLineToPoint:CGPointMake(self.bounds.size.width / 2 + ([self calculateShapeWidth] / 2),
                                         self.bounds.size.height / 2 - ([self calculateShapeHeight] / 2))];
        // Right-end-curve & lower-right corner
        [oval addQuadCurveToPoint:CGPointMake((self.bounds.size.width / 2) + ([self calculateShapeWidth] / 2),
                                              (self.bounds.size.height / 2) + ([self calculateShapeHeight] / 2))
                                              controlPoint:CGPointMake(self.bounds.size.width / 2 + ([self calculateShapeWidth] / 2) + [self calculateShapeCurve],
                                                                       self.bounds.size.height / 2)];
        // Lower-left corner
        [oval addLineToPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateShapeWidth] / 2),
                                         self.bounds.size.height / 2 + ([self calculateShapeHeight] / 2))];
        // Left-end-curve & back to upper-left corner
        [oval addQuadCurveToPoint:CGPointMake((self.bounds.size.width / 2) - ([self calculateShapeWidth] / 2),
                                              (self.bounds.size.height / 2) - ([self calculateShapeHeight] / 2))
                                              controlPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateShapeWidth] / 2) - [self calculateShapeCurve],
                                              self.bounds.size.height / 2)];
        [oval closePath];
        [oval fill];
        [oval setLineWidth:[self lineWidth]];
        [oval stroke];
    }
    
    // Restore current drawing setup
    CGContextRestoreGState(context);

}

- (void)draw1Diamond:(CGContextRef)context {
    // Save the current drawing setup
    CGContextSaveGState(context);
    
    {
        // Draw the diamond
        UIBezierPath *diamond = [[UIBezierPath alloc] init];
        [diamond moveToPoint:CGPointMake((self.bounds.size.width / 2), (self.bounds.size.height / 2) - ([self calculateShapeHeight] / 2))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width / 2) + ([self calculateShapeWidth] / 2), (self.bounds.size.height / 2))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width / 2), (self.bounds.size.height / 2) + ([self calculateShapeHeight] / 2))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width / 2) - ([self calculateShapeWidth] / 2), self.bounds.size.height / 2)];
        [diamond closePath];
        [diamond fill];
        [diamond setLineWidth:[self lineWidth]];
        [diamond stroke];
    }
    
    // Restore current drawing setup
    CGContextRestoreGState(context);
}

#pragma mark - Draw 2 Shapes

- (void)draw2Squiggles:(CGContextRef)context {
    
    // Save the current drawing setup
    CGContextSaveGState(context);
    
    {
        // Draw the 1st squiggle
        UIBezierPath *squiggle = [[UIBezierPath alloc] init];
        // Upper left-hand corner
        [squiggle moveToPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateSquiggleWidth] / 2),
                                          self.bounds.size.height / 2 - ([self calculateShapeHeight]) - ([self calculateGapSize] / 2))];
        // Upper right-hand corner
        [squiggle addLineToPoint:CGPointMake(self.bounds.size.width / 2 + ([self calculateSquiggleWidth] / 2),
                                             self.bounds.size.height / 2 - ([self calculateShapeHeight]) - ([self calculateGapSize] / 2))];
        // Right curve
        [squiggle addQuadCurveToPoint:CGPointMake(self.bounds.size.width / 2 + ([self calculateSquiggleWidth] / 2),
                                                  self.bounds.size.height / 2 - ([self calculateGapSize] / 2))
                         controlPoint:CGPointMake(self.bounds.size.width / 2 + ([self calculateSquiggleWidth] / 2) + 2 * ([self calculateShapeCurve]),
                                                  self.bounds.size.height / 2 - ([self calculateShapeHeight]) - 1.5 * ([self calculateShapeCurve]))];
        // Lower left-hand corner
        [squiggle addLineToPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateSquiggleWidth] / 2),
                                             self.bounds.size.height / 2 - ([self calculateGapSize] / 2))];
        // Left curve && Back to upper left-hand corner
        [squiggle addQuadCurveToPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateSquiggleWidth] / 2),
                                                   self.bounds.size.height / 2 - ([self calculateShapeHeight]) - ([self calculateGapSize] / 2))
                         controlPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateSquiggleWidth] / 2) - 2 * ([self calculateShapeCurve]),
                                                  self.bounds.size.height / 2 - ([self calculateGapSize] / 2) + 1.5 * ([self calculateShapeCurve]))];
        [squiggle closePath];
        [squiggle fill];
        [squiggle setLineWidth:[self lineWidth]];
        [squiggle stroke];
        
        // Draw the second squiggle
        CGContextRef squiggleContext1 = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(squiggleContext1, 0, [self calculateShapeHeight] + [self calculateGapSize]);
        [squiggle fill];
        [squiggle stroke];
    }
    
    // Restore current drawing setup
    CGContextRestoreGState(context);
    
}


- (void)draw2Ovals:(CGContextRef)context {
    
    // Save the current drawing setup
    CGContextSaveGState(context);
    
    {
        // Draw the 1st oval
        UIBezierPath *oval = [[UIBezierPath alloc] init];
        
        // Upper-left corner
        [oval moveToPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateShapeWidth] / 2),
                                      self.bounds.size.height / 2 - ([self calculateShapeHeight]) - ([self calculateGapSize] / 2))];
        // Upper-right corner
        [oval addLineToPoint:CGPointMake(self.bounds.size.width / 2 + ([self calculateShapeWidth] / 2),
                                         self.bounds.size.height / 2 - ([self calculateShapeHeight]) - ([self calculateGapSize] / 2))];
        // Right-end-curve & lower-right corner
        [oval addQuadCurveToPoint:CGPointMake((self.bounds.size.width / 2) + ([self calculateShapeWidth] / 2),
                                              (self.bounds.size.height / 2) - ([self calculateGapSize] / 2))
                     controlPoint:CGPointMake(self.bounds.size.width / 2 + ([self calculateShapeWidth] / 2) + [self calculateShapeCurve],
                                              (self.bounds.size.height / 2) - ([self calculateShapeHeight] / 2) - ([self calculateGapSize] / 2))];
        // Lower-left corner
        [oval addLineToPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateShapeWidth] / 2),
                                         self.bounds.size.height / 2 - ([self calculateGapSize] / 2))];
        // Left-end-curve & back to upper-left corner
        [oval addQuadCurveToPoint:CGPointMake((self.bounds.size.width / 2) - ([self calculateShapeWidth] / 2),
                                              self.bounds.size.height / 2 - ([self calculateShapeHeight]) - ([self calculateGapSize] / 2))
                     controlPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateShapeWidth] / 2) - [self calculateShapeCurve],
                                              (self.bounds.size.height / 2) - ([self calculateShapeHeight] / 2) - ([self calculateGapSize] / 2))];
        [oval closePath];
        [oval fill];
        [oval setLineWidth:[self lineWidth]];
        [oval stroke];
        
        // Draw the 2nd oval
        CGContextRef ovalContext1 = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(ovalContext1, 0, [self calculateShapeHeight] + [self calculateGapSize]);
        [oval fill];
        [oval stroke];
    }
    
    // Restore current drawing setup
    CGContextRestoreGState(context);

}

- (void)draw2Diamonds:(CGContextRef)context {
    
    // Save the current drawing setup
    CGContextSaveGState(context);
    
    {
        // Draw the 1st diamond
        UIBezierPath *diamond = [[UIBezierPath alloc] init];
        [diamond moveToPoint:CGPointMake((self.bounds.size.width / 2),
                                         (self.bounds.size.height / 2) - [self calculateShapeHeight] - ([self calculateGapSize] / 2))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width / 2) + ([self calculateShapeWidth] / 2),
                                            (self.bounds.size.height / 2) - ([self calculateShapeHeight] / 2) - ([self calculateGapSize] / 2))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width / 2),
                                            (self.bounds.size.height / 2) - ([self calculateGapSize] / 2))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width / 2) - ([self calculateShapeWidth] / 2),
                                            (self.bounds.size.height / 2) - ([self calculateShapeHeight] / 2) - ([self calculateGapSize] / 2))];
        [diamond closePath];
        [diamond fill];
        [diamond setLineWidth:[self lineWidth]];
        [diamond stroke];
        
        
        // Draw the 2nd diamond
        CGContextRef diamondContext1 = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(diamondContext1, 0, [self calculateShapeHeight] + [self calculateGapSize]);
        [diamond fill];
        [diamond stroke];
    }
    
    // Restore current drawing setup
    CGContextRestoreGState(context);
}


#pragma mark - Draw 3 Shapes

- (void)draw3Squiggles:(CGContextRef)context {
    
    // Save the current drawing setup
    CGContextSaveGState(context);
    
    {
        
        // Draw the 1st squiggle
        UIBezierPath *squiggle = [[UIBezierPath alloc] init];
        // Upper left-hand corner
        [squiggle moveToPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateSquiggleWidth] / 2),
                                          self.bounds.size.height / 2 - ([self calculateShapeHeight] / 2))];
        // Upper right-hand corner
        [squiggle addLineToPoint:CGPointMake(self.bounds.size.width / 2 + ([self calculateSquiggleWidth] / 2),
                                             self.bounds.size.height / 2 - ([self calculateShapeHeight] / 2))];
        // Right curve
        [squiggle addQuadCurveToPoint:CGPointMake(self.bounds.size.width / 2 + ([self calculateSquiggleWidth] / 2),
                                                  self.bounds.size.height / 2 + ([self calculateShapeHeight] / 2))
                         controlPoint:CGPointMake(self.bounds.size.width / 2 + ([self calculateSquiggleWidth] / 2) + 2 * ([self calculateShapeCurve]),
                                                  self.bounds.size.height / 2 - ([self calculateShapeHeight] / 2) - 1.5 * ([self calculateShapeCurve]))];
        // Lower left-hand corner
        [squiggle addLineToPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateSquiggleWidth] / 2),
                                             self.bounds.size.height / 2 + ([self calculateShapeHeight] / 2))];
        // Back to upper left-hand corner
        [squiggle addQuadCurveToPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateSquiggleWidth] / 2),
                                                  self.bounds.size.height / 2 - ([self calculateShapeHeight] / 2))
                         controlPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateSquiggleWidth] / 2) - 2 * ([self calculateShapeCurve]),
                                                  self.bounds.size.height / 2 + ([self calculateShapeHeight] / 2) + 1.5 * ([self calculateShapeCurve]))];
        [squiggle fill];
        [squiggle setLineWidth:[self lineWidth]];
        [squiggle stroke];

        // Draw the 2nd squiggle
        CGContextRef squiggleContext1 = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(squiggleContext1, 0, -1 * ([self calculateShapeHeight] + [self calculateGapSize]));
        [squiggle fill];
        [squiggle stroke];
        
        // Draw the 3rd squiggle
        CGContextRef squiggleContext2 = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(squiggleContext2, 0, 2 * [self calculateShapeHeight] + 2 * [self calculateGapSize]);
        [squiggle fill];
        [squiggle stroke];
    }
    
    // Restore current drawing setup
    CGContextRestoreGState(context);
}

- (void)draw3Ovals:(CGContextRef)context {
    
    // Save the current drawing setup
    CGContextSaveGState(context);
    
    {

        // Draw the 1st oval
        UIBezierPath *oval = [[UIBezierPath alloc] init];
        
        // Upper-left corner
        [oval moveToPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateShapeWidth] / 2),
                                      self.bounds.size.height / 2 - ([self calculateShapeHeight] / 2))];
        // Upper-right corner
        [oval addLineToPoint:CGPointMake(self.bounds.size.width / 2 + ([self calculateShapeWidth] / 2),
                                         self.bounds.size.height / 2 - ([self calculateShapeHeight] / 2))];
        // Right-end-curve & lower-right corner
        [oval addQuadCurveToPoint:CGPointMake((self.bounds.size.width / 2) + ([self calculateShapeWidth] / 2),
                                              (self.bounds.size.height / 2) + ([self calculateShapeHeight] / 2))
                     controlPoint:CGPointMake(self.bounds.size.width / 2 + ([self calculateShapeWidth] / 2) + [self calculateShapeCurve],
                                              self.bounds.size.height / 2)];
        // Lower-left corner
        [oval addLineToPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateShapeWidth] / 2),
                                         self.bounds.size.height / 2 + ([self calculateShapeHeight] / 2))];
        // Left-end-curve & back to upper-left corner
        [oval addQuadCurveToPoint:CGPointMake((self.bounds.size.width / 2) - ([self calculateShapeWidth] / 2),
                                              (self.bounds.size.height / 2) - ([self calculateShapeHeight] / 2))
                     controlPoint:CGPointMake(self.bounds.size.width / 2 - ([self calculateShapeWidth] / 2) - [self calculateShapeCurve],
                                              self.bounds.size.height / 2)];
        [oval closePath];
        [oval fill];
        [oval setLineWidth:[self lineWidth]];
        [oval stroke];
        
        // Draw the 2nd oval
        CGContextRef ovalContext1 = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(ovalContext1, 0, -1 * ([self calculateShapeHeight] + [self calculateGapSize]));
        [oval fill];
        [oval stroke];
        
        // Draw the 3rd oval
        CGContextRef ovalContext2 = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(ovalContext2, 0, (2 * [self calculateShapeHeight]) + (2 * [self calculateGapSize]));
        [oval fill];
        [oval stroke];
        
    }
    
    // Restore current drawing setup
    CGContextRestoreGState(context);
}

- (void)draw3Diamonds:(CGContextRef)context {
    
    // Save the current drawing setup
    CGContextSaveGState(context);
    
    {
        // Draw the 1st diamond
        UIBezierPath *diamond = [[UIBezierPath alloc] init];
        [diamond moveToPoint:CGPointMake((self.bounds.size.width / 2), (self.bounds.size.height / 2) - ([self calculateShapeHeight] / 2))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width / 2) + ([self calculateShapeWidth] / 2), (self.bounds.size.height / 2))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width / 2), (self.bounds.size.height / 2) + ([self calculateShapeHeight] / 2))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width / 2) - ([self calculateShapeWidth] / 2), self.bounds.size.height / 2)];
        [diamond closePath];
        [diamond fill];
        [diamond setLineWidth:[self lineWidth]];
        [diamond stroke];
        
        // Draw the 2nd diamond
        CGContextRef diamondContext1 = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(diamondContext1, 0, -1 * ([self calculateShapeHeight] + [self calculateGapSize]));
        [diamond fill];
        [diamond stroke];
        
        // Draw the 3rd diamond
        CGContextRef diamondContext2 = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(diamondContext2, 0, 2 * [self calculateShapeHeight] + 2 * [self calculateGapSize]);
        [diamond fill];
        [diamond stroke];
    }
    
    // Restore current drawing setup
    CGContextRestoreGState(context);
}

#pragma mark - Initialization

- (void)setUp {
    
    // No background color for UIView (will look black)
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
