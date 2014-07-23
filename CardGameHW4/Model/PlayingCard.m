//
//  PlayingCard.m
//  CardGame
//
//  Created by Nicole on 5/13/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "PlayingCard.h"

@interface PlayingCard()
@property (nonatomic) NSUInteger count;
@end

@implementation PlayingCard

// Because we provide setter AND getter
@synthesize suit = _suit;

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    if ([otherCards count] == 2) {
        
        PlayingCard *firstCard = [otherCards firstObject];
        PlayingCard *secondCard = [otherCards lastObject];
        
        if (firstCard.rank == secondCard.rank) {
            score = 4;
        }
        else if ([firstCard.suit isEqualToString:secondCard.suit]) {
            score = 1;
        }
    }
    
    else if ([otherCards count] == 3) {
        
        PlayingCard *firstCard = [otherCards objectAtIndex:0];
        PlayingCard *secondCard = [otherCards objectAtIndex:1];
        PlayingCard *thirdCard = [otherCards objectAtIndex:2];
        
        // If all three cards have the same rank
        if (firstCard.rank == thirdCard.rank && secondCard.rank == thirdCard.rank && firstCard.rank == secondCard.rank) {
            score = 15;
        }
        
        // If all three cards have the same suit
        if (firstCard.suit == thirdCard.suit && secondCard.suit == thirdCard.suit && firstCard.suit == secondCard.suit) {
            score = 10;
        }
    }
    
    return score;
}

- (NSAttributedString *)createTitle:(NSArray *)otherCards {
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@""];
    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" "];
    // Check to make sure there are two cards in the array
    if ([otherCards count] == 2) {
        
        for (Card *card in otherCards) {
            NSMutableAttributedString *substring = [[NSMutableAttributedString alloc] initWithString:card.contents];
            [substring setAttributes:@ { NSForegroundColorAttributeName : card.color }
                               range:NSMakeRange(0, [substring length])];
            [title appendAttributedString:substring];
            [title appendAttributedString:space];
        }
    }
    
    return title;
}

- (BOOL)isGameOver:(NSArray *)unmatchedCards {
    
    NSMutableDictionary *unmatchedSuit = [[NSMutableDictionary alloc] init]; // Of Card
    NSMutableDictionary *unmatchedRank = [[NSMutableDictionary alloc] init]; // Of Card
    
    // Find all the cards that have not been matched
    for (PlayingCard *card in unmatchedCards) {
        
        // If the suit is already in the Dictionary, increase the total count of the suit by 1
        if ([unmatchedSuit objectForKey:card.suit]) {
            NSString *stringCount = [unmatchedSuit objectForKey:card.suit];
            NSInteger count = [stringCount integerValue];
            count += 1;
            [unmatchedSuit setObject:[NSNumber numberWithInt:(int)count] forKey:card.suit];
        }
        
        // If the suit is not in the Dictionary, add it to the Dictionary
        else {
            unmatchedSuit[card.suit] = [NSNumber numberWithInt:1];
        }
        
        // If the rank is already in the Dictionary, increase the total count of the rank by one
        if ([unmatchedRank objectForKey:[NSNumber numberWithInt:(int)card.rank]]) {
            NSString *stringCount = [unmatchedRank objectForKey:[NSNumber numberWithInt:(int)card.rank]];
            NSInteger count = [stringCount integerValue];
            count +=1;
            [unmatchedRank setObject:[NSNumber numberWithInt:(int)count] forKey:[NSNumber numberWithInt:(int)card.rank]];
        }
        
        // If the rank is not in the Dictionary, add it to the Dictionary
        else {
            unmatchedRank[[NSNumber numberWithInt:card.rank]] = [NSNumber numberWithInt:1];
        }
    }
    
    // Check to see if there are matching suits left
    for (id key in unmatchedSuit) {
        NSString *stringCount = unmatchedSuit[key];
        NSInteger count = [stringCount integerValue];
        
        // If game is not over, return false
        if (count >= 2) {
            return false;
        }
    }
    
    // Check to see if there are matching ranks left
    for (id key in unmatchedRank) {
        NSString *stringCount = unmatchedRank[key];
        NSInteger count = [stringCount integerValue];
        
        // If game is not over, return false
        if (count >= 2) {
            return false;
        }
        
        /*
         else if (self.cardMatchingCount == 3) {
         if (count >= 3)  {
         return true;
         }
         } */
    }
    
    // If there are not more than two cards of the same rank or suit, end the game
    return true;
}

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

// Class method
+ (NSArray *)validSuits {
    return @[@"♥︎", @"♣︎", @"♦︎", @"♠︎"];
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

- (NSArray *)validColors {
    return @[[UIColor redColor], [UIColor blackColor]];
}

- (UIColor *)color {
    if ([self.suit isEqualToString:@"♥︎"] || [self.suit isEqualToString:@"♦︎"]) {
        return [UIColor redColor];
    }
    return [UIColor blackColor];
}

- (NSString *)shading {
    return @"solid";
}

// Check to make sure no one tries to set a suit to something invalid
- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

// A suit of nil returns "?"
- (NSString *)suit {
    return _suit ? _suit : @"?";
}

+ (NSUInteger)maxRank {
    return [[self rankStrings] count] - 1;
}

// Make sure rank is never set to an improper value
- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
