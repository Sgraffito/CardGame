//
//  SetCard.h
//  CardGame
//
//  Created by Nicole on 6/2/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *symbol;
@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) NSString *shading;

+ (NSArray *)validSymbols;
+ (NSUInteger)maxNumber;
+ (NSArray *)colorValues;
+ (NSArray *)shadingStrings;

@end;