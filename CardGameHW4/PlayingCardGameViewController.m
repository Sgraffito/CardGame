//
//  PlayingCardGameViewController.m
//  CardGameHW4
//
//  Created by Nicole on 7/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"

@interface PlayingCardGameViewController ()
@property (strong, nonatomic) NSMutableArray *cardsToFlip;
@end

@implementation PlayingCardGameViewController

- (NSMutableArray *)cardsToFlip {
    if (!_cardsToFlip) _cardsToFlip = [[NSMutableArray alloc] init];
    return _cardsToFlip;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}


/* Lays the cards out on the board and adds a tap gesture to each card */
- (void)updateView:(UIView *)view forCard:(Card *)card {
    if (![card isKindOfClass:[PlayingCard class]]) { return; }
    if (![view isKindOfClass:[PlayingCardView class]]) { return; }
    
    PlayingCard *playingCard = (PlayingCard *)card;
    PlayingCardView *playingCardView = (PlayingCardView *)view;
    playingCardView.rank = playingCard.rank;
    playingCardView.suit = playingCard.suit;
    playingCardView.faceUp = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberOfColumns = 5;
    self.numberOfRows = 5;
    self.cardWidth = 45;
    self.cardHeight = 65;
    self.sizeOfDeck = (self.numberOfRows * self.numberOfColumns);
    [self drawUI];
    
    // Set color of navigation controller title
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
}

- (UIView *)getTypeOfView:(CGRect *)rect {
    PlayingCardView *view = [[PlayingCardView alloc] initWithFrame:*rect];
    return view;
}

- (int)cardMatchingCount {
    return 2;
}

- (void)flipCard:(UIView *)view {
    PlayingCardView *cardTapped = (PlayingCardView *)view;
    [cardTapped tap];
}

- (void)disableCard:(UIView *)view {
    PlayingCardView *cardTapped = (PlayingCardView *)view;
    [cardTapped fadeCard];
}

@end
