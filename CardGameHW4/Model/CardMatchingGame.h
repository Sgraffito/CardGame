//
//  CardMatchingGame.h
//  CardGame
//
//  Created by Nicole on 5/16/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// Designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (BOOL)endOfGame:(NSArray *)unmatchedCards;

// Readonly means there is no setter (only a getter)
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSUInteger cardMatchingCount;
@property (nonatomic, strong) NSMutableAttributedString *matchingAnnoucement;
@property (nonatomic, strong) NSMutableArray *cards; // Of Card

@end
