//
//  CardGameViewController.m
//  CardGameHW4
//
//  Created by Nicole on 7/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardView.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface CardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(PlayingCardView) NSArray *threeCards;
@property (strong, nonatomic) Deck *deck;
@end

@implementation CardGameViewController

/*  Lazy instantiation */
- (Deck *)deck {
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

/* Called after the controller’s view is loaded into memory */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup the game board with a new deck of cards
    [self setUp];
}

/* Lays the cards out on the board and adds a tap gesture to each card */
- (void)setUp {
    
    // For each card on the board, get a suit and rank for the card
    for (PlayingCardView *eachCard in self.threeCards) {
        Card *card = [self.deck drawRandomCard];
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            eachCard.rank = playingCard.rank;
            eachCard.suit = playingCard.suit;
            eachCard.faceUp = NO;
        }
        
        // Add a tap gesture recognizer to the card (card will flip over when touched)
        [self addTapGestureToView:eachCard];
    }
}

/*  Adds a tap gesture recognizer to each card on the board
    When the user clicks on the card once, the card flips over */
- (void)addTapGestureToView:(PlayingCardView *)card {
    UITapGestureRecognizer *cardTap = [[UITapGestureRecognizer alloc] initWithTarget:card action:@selector(tap:)];
    cardTap.numberOfTapsRequired = 1;
    cardTap.numberOfTouchesRequired = 1;
    [card addGestureRecognizer:cardTap];
}

/*  Shuffles the card deck lays out a new set of cards on the board */
- (IBAction)resetButtonPressed:(id)sender {
    
    // Create a new deck of cards
    self.deck = [[PlayingCardDeck alloc] init];
    
    // Draw the cards on the board
    [self setUp];
}

@end
