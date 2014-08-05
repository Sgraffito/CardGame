//
//  CardGameViewController.h
//  CardGameHW4
//
//  Created by Nicole on 7/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

- (Deck *)createDeck; // Abstract
- (UIView *)getTypeOfView:(CGRect *)rect; // Abstract
- (void)updateView:(UIView *)view forCard:(Card *)card; // Abstract
- (int)cardMatchingCount; // Abstract
- (void)drawUI;
- (void)flipCard:(UIView *)view; // Abstract
- (void)disableCard:(UIView *)view; // Abstract
- (void)makeFaceUp:(UIView *)view; // Abstract
- (void)makeFaceDown:(UIView *)view; // Abstract
- (void)turnCardOver:(UIView *)view; //Abstract

@property (nonatomic) NSUInteger numberOfColumns;
@property (nonatomic) NSUInteger numberOfRows;
@property (nonatomic) NSUInteger cardWidth;
@property (nonatomic) NSUInteger cardHeight;
@property (nonatomic) NSUInteger sizeOfDeck;

@end
