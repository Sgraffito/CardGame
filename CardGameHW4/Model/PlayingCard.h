//
//  PlayingCard.h
//  CardGame
//
//  Created by Nicole on 5/13/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

/* Suit contains a single character corrrespoinding
 * to the suit (i.e. a club, spade, heart or diamond */
@property (strong, nonatomic) NSString *suit;

// Rank is an integer from 0 (rank not set) to 13 (King)
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;


@end
