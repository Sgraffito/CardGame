//
//  SetCard.m
//  CardGame
//
//  Created by Nicole on 6/2/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

// Because we provide setter AND getter
@synthesize symbol = _symbol;
@synthesize color = _color;
@synthesize shading = _shading;

- (BOOL)isGameOver:(NSArray *)unmatchedCards {
    
    // Test print
    /*
    for (int i = 0; i < [unmatchedCards count]; i += 1){
        Card *unmatched = [unmatchedCards objectAtIndex:i];
        NSLog(@"%d unmatchedCard: %@", i, unmatched.contents);
    }
     */
    
    for(int i = 0; i < [unmatchedCards count] - 2; i += 1) {
        for (int j = i + 1; j < [unmatchedCards count] - 1; j += 1) {
            for (int k = j + 1; k < [unmatchedCards count]; k += 1) {
                
                SetCard *firstCard = [unmatchedCards objectAtIndex:i];
                SetCard *secondCard = [unmatchedCards objectAtIndex:j];
                SetCard *thirdCard = [unmatchedCards objectAtIndex:k];
                
                // Check the three cards for a match
                NSArray *checkCardsForMatch = @[firstCard, secondCard, thirdCard];
                int score = [self match:checkCardsForMatch];
                
                // If three cards are a match, the game is not over, return false
                if (score) {
                    //NSLog(@"Matched %@, %@, %@", firstCard.contents, secondCard.contents, thirdCard.contents);
                    return false;
                }
            }
        }
    }
    
    // There are no matches, return false
    return true;
}

- (int)match:(NSArray *)otherCards {
    
    // If no cards are matched score is zero
    int score = 0;
    
    if ([otherCards count] == 3) {
        
        SetCard *firstCard = [otherCards objectAtIndex:0];
        SetCard *secondCard = [otherCards objectAtIndex:1];
        SetCard *thirdCard = [otherCards objectAtIndex:2];
        
        // Check to see if all the colors are the same or are all different
        if (([firstCard.color isEqual:secondCard.color]
             && [firstCard.color isEqual:thirdCard.color]
             && [secondCard.color isEqual:thirdCard.color])
            ||
            (![firstCard.color isEqual:secondCard.color]
             && ![firstCard.color isEqual:thirdCard.color]
             && ![secondCard.color isEqual:thirdCard.color])) {
                score += 3;
            }
        // If the colors are not all the same or all different, there is no match, exit
        else {
            return 0;
        }
        
        // Check to see if all the shadings are the same or are all different
        if (([firstCard.shading isEqualToString:secondCard.shading]
             && [firstCard.shading isEqualToString:thirdCard.shading]
             && [secondCard.shading isEqualToString:thirdCard.shading])
            ||
            (![firstCard.shading isEqualToString:secondCard.shading]
             && ![firstCard.shading isEqualToString:thirdCard.shading]
             && ![secondCard.shading isEqualToString:thirdCard.shading])) {
                score += 3;
            }
        
        // If the shadings are not all the same or all different, there is no match, exit
        else {
            return 0;
        }
        
        // Check to see if all the symbols are the same or all different
        if (([firstCard.symbol isEqualToString:secondCard.symbol]
             && [firstCard.symbol isEqualToString:thirdCard.symbol]
             && [secondCard.symbol isEqualToString:thirdCard.symbol])
            ||
            (![firstCard.symbol isEqualToString:secondCard.symbol]
             && ![firstCard.symbol isEqualToString:thirdCard.symbol]
             && ![secondCard.symbol isEqualToString:thirdCard.symbol])) {
                score += 3;
            }
        
        // If the symbols are not all the same or all different, there is no match, exit
        else {
            return 0;
        }
        
        // Check to see if all the numbers are the same or all different
        if ((firstCard.number == secondCard.number
             && firstCard.number == thirdCard.number
             && secondCard.number == thirdCard.number)
            ||
            (firstCard.number != secondCard.number
             && firstCard.number != thirdCard.number
             && secondCard.number != thirdCard.number)) {
                score += 3;
            }
        
        // If the numbers are not all the same or all different, there is no match, exit
        else {
            return 0;
        }
    }
    
    // The three cards match, return the score
    return score;
}

- (NSAttributedString *)createTitle:(NSArray *)otherCards {
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@""];
    
    // Check to make sure thee cards are being matched
    if ([otherCards count] == 3) {
        
        for (Card *card in otherCards) {
            
            NSMutableAttributedString *substring = [[NSMutableAttributedString alloc] initWithString:card.contents];
            NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" "];
            
            // Create title if the shape is outlined (shape is outline with no fill)
            if ([card.shading isEqualToString:@"outline"]) {
                [substring setAttributes:@ { NSStrokeWidthAttributeName : @8,
                    NSStrokeColorAttributeName : card.color }
                               range:NSMakeRange(0, [substring length])];
            }
            
            // Create title if the shape is solid (ouline and fill are same color and transparency)
            else if([card.shading isEqualToString:@"solid"]) {
                [substring setAttributes:@ { NSStrokeWidthAttributeName : @-8,
                    NSStrokeColorAttributeName : card.color,
                    NSForegroundColorAttributeName : card.color }
                               range:NSMakeRange(0, [substring length])];
            }
            
            // Create title if shape is open (outlined shape with transparent fill)
            else if([card.shading isEqualToString:@"open"]) {
                UIColor *solidColor = card.color;
                UIColor *transparentColor = [solidColor colorWithAlphaComponent:0.2];
                [substring setAttributes:@ { NSStrokeWidthAttributeName : @-8,
                    NSStrokeColorAttributeName : solidColor,
                    NSForegroundColorAttributeName : transparentColor}
                               range:NSMakeRange(0, [substring length])];
                
            }
            
            [title appendAttributedString:substring];
            [title appendAttributedString:space];
        }
    }
    return title;
}

- (NSString *)contents {
    
    NSString *cardContents = [[NSString alloc] init];
    NSUInteger count = self.number;
    while (count) {
        cardContents = [cardContents stringByAppendingString:self.symbol];
        count -= 1;
    }
    return cardContents;
}

- (UIColor *)color {
    return _color;
}

- (NSString *)shading {
    return _shading;
}

// Class method
+ (NSArray *)validSymbols {
    return @[@"▲", @"●", @"◼︎"];
}

+ (NSArray *)numberStrings {
    return @[@"?", @"1", @"2", @"3"];
}

+ (NSArray *)colorValues {
    UIColor *purple = [UIColor colorWithRed:114/255.0 green:9/255.0 blue:178/255.0 alpha:1.0];
    UIColor *red = [UIColor colorWithRed:207/255.0 green:31/255.0 blue:10/255.0 alpha:1.0];
    UIColor *green = [UIColor colorWithRed:16/255.0 green:140/255.0 blue:11/255.0 alpha:1.0];
    return @[purple, red, green];
}

+ (NSArray *)shadingStrings {
    return @[@"solid", @"outline", @"open"];
}

//Check to make sure no one tries to set a suit to something invalid
- (void)setSymbol:(NSString *)symbol {
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

// A symbol of nil returns "?"
- (NSString *)symbol {
    return _symbol ? _symbol : @"?";
}

+ (NSUInteger)maxNumber {
    return [[self numberStrings] count] - 1;
}

// Make sure rank is never set to an improper value
- (void)setNumber:(NSUInteger)number {
    if (number <= [SetCard maxNumber]) {
        _number = number;
    }
}

// Make sure color is never set to an improper value
- (void)setColor:(UIColor *)color {
    if ([[SetCard colorValues] containsObject:color]) {
        _color = color;
    }
}

// Make sure shading is never set to an improper value
- (void)setShading:(NSString *)shading {
    if ([[SetCard shadingStrings] containsObject:shading]) {
        _shading = shading;
    }
}


@end
