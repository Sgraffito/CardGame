//
//  Card.m
//  CardGame
//
//  Created by Nicole on 5/13/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "Card.h"

@interface Card()

@end

@implementation Card

- (int)match:(NSArray *)otherCards { // Abstract
    int score = 0;
    return score;
}

- (NSString *)createTitle:(NSArray *)otherCards { // Abstract
    return @"";
}

- (BOOL)isGameOver:(NSArray *)unmatchedCards { // Abstract
    return false;
}

@end
