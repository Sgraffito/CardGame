//
//  SetCardGameViewController.m
//  CardGameHW4
//
//  Created by Nicole on 7/23/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardView.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetCardGameViewController ()
@property (strong, nonatomic) NSMutableArray *cardsToFlip;
@end

@implementation SetCardGameViewController

- (NSMutableArray *)cardsToFlip {
    if (!_cardsToFlip) _cardsToFlip = [[NSMutableArray alloc] init];
    return _cardsToFlip;
}

- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

- (void)updateView:(UIView *)view forCard:(Card *)card {

    if (![card isKindOfClass:[SetCard class]]) { return; }
    if (![view isKindOfClass:[SetCardView class]]) { return; }
    
    SetCard *setCard = (SetCard *)card;
    SetCardView *setCardView = (SetCardView *)view;
    setCardView.color = setCard.color;
    setCardView.shading = setCard.shading;
    setCardView.number = setCard.number;
    setCardView.symbol = setCard.symbol;
    setCardView.selected = NO;
    setCardView.faceUp = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberOfColumns = 5;
    self.numberOfRows = 5;
    self.cardWidth = 45;
    self.cardHeight = 65;
    self.sizeOfDeck = (self.numberOfColumns * self.numberOfRows) + (3 * 6); // Each deal is 3 cards
    [self drawUI];
    
    // Set color of navigation controller title
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
}

- (UIView *)getTypeOfView:(CGRect *)rect {
    SetCardView *view = [[SetCardView alloc] initWithFrame:*rect];
    return view;
}

- (int)cardMatchingCount {
    return 3;
}

- (void)flipCard:(UIView *)view {
    SetCardView *cardTapped = (SetCardView *)view;
    [cardTapped tap];
}

- (void)disableCard:(UIView *)view {
    SetCardView *cardTapped = (SetCardView *)view;
    [cardTapped fadeCard];
}

- (void)makeFaceUp:(UIView *)view {
    SetCardView *card = (SetCardView *)view;
    card.faceUp = YES;
}

- (void)makeFaceDown:(UIView *)view {
    SetCardView *card = (SetCardView *)view;
    card.faceUp = NO;
}

- (void)turnCardOver:(UIView *)view {
    SetCardView *card = (SetCardView *)view;
    [card flipCardOver];
}

@end
