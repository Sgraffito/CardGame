//
//  Deck.h
//  CardGame
//
//  Created by Nicole on 5/13/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;
- (Card *)drawRandomCard;

@end
