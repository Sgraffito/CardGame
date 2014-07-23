//
//  Card.h
//  CardGame
//
//  Created by Nicole on 5/13/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic, getter = isChoosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards; // Abstract
- (NSAttributedString *)createTitle:(NSArray *)otherCards; // Abstract
- (BOOL)isGameOver:(NSArray *)unmatchedCards; // Abstract

@end

