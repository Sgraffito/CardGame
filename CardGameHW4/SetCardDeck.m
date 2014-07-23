//
//  SetCardDeck.m
//  CardGame
//
//  Created by Nicole on 6/2/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        for (NSString *symbol in [SetCard validSymbols]) {
            for (NSUInteger number = 1; number <= [SetCard maxNumber]; number++) {
                for (UIColor *color in [SetCard colorValues]) {
                    for (NSString *shading in [SetCard shadingStrings]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.symbol = symbol;
                        card.number = number;
                        card.color = color;
                        card.shading = shading;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    return self;
}

@end