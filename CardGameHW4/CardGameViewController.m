//
//  CardGameViewController.m
//  CardGameHW4
//
//  Created by Nicole on 7/22/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "SetCardView.h"
#import "CardMatchingGame.h"
#import "Grid.h"
#import "GameOverView.h"

@interface CardGameViewController ()
@property (strong, nonatomic) Grid *grid;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (strong, nonatomic) NSMutableArray *cardViewsNotOnBoard;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UIView *gridView;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) NSMutableArray *cardsTapped; // Of UIView
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIView *gameOverView;
@property (weak, nonatomic) IBOutlet UIView *cardsMatched;
@property (weak, nonatomic) IBOutlet UIView *cardsUnmatched;
@property (nonatomic) NSUInteger *numberOfEmptySpacesOnBoard;
@property (strong, nonatomic) NSMutableArray *locationOfEmptySpacesOnBoardX;
@property (strong, nonatomic) NSMutableArray *locationOFEmptySpacesOnBoardY;
@property (strong, nonatomic) NSMutableArray *emptyTags;
@end

@implementation CardGameViewController

#pragma mark - Initialization

/* Called after the controller’s view is loaded into memory */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the tint color for the tab bar
    [self.tabBarController.tabBar setTintColor:[UIColor blackColor]];
}

#pragma mark - Properties

/*  Create a new game */
- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc]
                         initWithCardCount:self.sizeOfDeck
                         usingDeck:[self createDeck]];
    return _game;
}

/*  Lazy instantiation */
- (NSMutableArray *)cardViews {
    if (!_cardViews) _cardViews = [NSMutableArray arrayWithCapacity:self.numberOfColumns * self.numberOfRows];
    return _cardViews;
}

/*  Lazy instantiation */
- (NSMutableArray *)cardViewsNotOnBoard {
    if (!_cardViewsNotOnBoard) _cardViewsNotOnBoard = [[NSMutableArray alloc] init];
    return _cardViewsNotOnBoard;
}

/*  Lazy instantiation */
- (NSMutableArray *)cardsTapped {
    if (!_cardsTapped) _cardsTapped = [[NSMutableArray alloc] init];
    return _cardsTapped;
}

/*  Lazy instantiation */
- (NSMutableArray *)locationOfEmptySpacesOnBoardX {
    if (!_locationOfEmptySpacesOnBoardX) _locationOfEmptySpacesOnBoardX = [[NSMutableArray alloc] init];
    return _locationOfEmptySpacesOnBoardX;
}

/*  Lazy instantiation */
- (NSMutableArray *)locationOfEmptySpacesOnBoardY {
    if (!_locationOFEmptySpacesOnBoardY) _locationOFEmptySpacesOnBoardY = [[NSMutableArray alloc] init];
    return _locationOFEmptySpacesOnBoardY;
}

/*  Lazy instantiation */
- (NSMutableArray *)emptyTags {
    if (!_emptyTags) _emptyTags = [[NSMutableArray alloc] init];
    return _emptyTags;
}

/*  Shuffle the deck of cards */
- (Deck *)createDeck {
    // Abstract
    return nil;
}

#pragma mark - Drawing

/*  Lays the cards out on the board and adds a tap gesture to each card
    If there is a deck of cards, draws the cards in a stack 
 */
- (void)drawUI {
    
    // Set background color of the views
    self.backgroundColor = [UIColor colorWithRed:50 / 255.0 green:70 / 255.0 blue:114 / 255.0 alpha:1.0];
    
    // Get the number of cards to be matched (2 or 3)
    [self.game setCardMatchingCount:[self cardMatchingCount]];
    
    // Calculate space between the columns of cards
    int gapWidth = self.gridView.bounds.size.width - (self.numberOfColumns * self.cardWidth);
    int gapWidthSpace = gapWidth / (self.numberOfColumns - 1);
    
    // Calculate space between the rows of cards
    int gapHeight = self.gridView.bounds.size.height - (self.numberOfRows * self.cardHeight);
    int gapHeightSpace = gapHeight / (self.numberOfRows - 1);
    
    int cardTag = 0;
    
    // Draw the cards on the game board
    for (int i = 0; i < self.numberOfColumns; i += 1) {
        for (int j = 0; j < self.numberOfRows; j += 1) {
            
            Card *card = [self.game cardAtIndex:cardTag];
            
            // Make the views
            CGRect rect = CGRectMake(i * self.cardWidth + i * gapWidthSpace,
                                     j * self.cardHeight + j * gapHeightSpace,
                                     self.cardWidth,
                                     self.cardHeight);
            UIView *view = [self getTypeOfView:&rect];
            
            // Give the view the type of card to be drawn
            [self updateView:view forCard:card];
            
            // Add a tag to the view
            view.tag = cardTag;
            cardTag += 1;
            
            // Make the background of the view transparent (gets rid of the black corners)
            view.backgroundColor = [UIColor clearColor];
           
            // Add a tap gesture recognizer to the view
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)];
            tap.numberOfTapsRequired = 1;
            [view addGestureRecognizer:tap];
            view.userInteractionEnabled = YES;
            
            // Add a pan gesture recognizer to the view
            UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
            [self.view addGestureRecognizer:panRecognizer];

            
            // Save view to array
            [self.cardViews addObject:view];
            
            // Add the view to the board
            [self.gridView addSubview:view];
        }
    }
    
    int cardUnmatchedTag = 0;
    
    // If there are cards in the deck not on the board, draw them in a stack
    if (self.sizeOfDeck > (self.numberOfColumns * self.numberOfRows)) {
       
        // Make all the cards face down
        [self makeFaceUp:self.cardsMatched];
        
        // If the card is not on the deck...
        while (cardUnmatchedTag < self.sizeOfDeck - (self.numberOfColumns * self.numberOfRows)) {
            
            // Get the card
            Card *card = [self.game cardAtIndex:cardTag + cardUnmatchedTag];
            
            // Make the view
            CGRect rect = CGRectMake(self.cardsUnmatched.bounds.origin.x,
                                     self.cardsUnmatched.bounds.origin.y,
                                     self.cardsUnmatched.bounds.size.width,
                                     self.cardsUnmatched.bounds.size.height);
            UIView *view = [self getTypeOfView:&rect];
            
            // Give the view the type of card to be drawn
            [self updateView:view forCard:card];
            
            // Add a tag to the view
            view.tag = cardUnmatchedTag;
            cardUnmatchedTag += 1;
            
            // Make the background of the view transparent (gets rid of black corners)
            view.backgroundColor = [UIColor clearColor];
            
            // Add a tap gesture recognizer to the view
            UITapGestureRecognizer *tapForMoreCards = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapForMoreCards:)];
            tapForMoreCards.numberOfTapsRequired = 1;
            [view addGestureRecognizer:tapForMoreCards];
            view.userInteractionEnabled = YES;
            
            // Add view to the board
            [self makeFaceDown:view];
            
            self.cardsUnmatched.layer.zPosition = -1;
            view.layer.zPosition = cardUnmatchedTag;
            [self.cardsUnmatched addSubview:view];
            
            // Save view to cardViews not in array
            [self.cardViewsNotOnBoard addObject:view];
        }
    }
}

#pragma mark - Gestures

/*  Moves cards from the deck to the game board */
- (void)tapForMoreCards:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        // Will only move cards if there are at least 3 empty spots on the game board
        if ((int)self.numberOfEmptySpacesOnBoard >= 3) {
            
            // Get the first three cards on top of the stack
            UIView *firstView = [self.cardViewsNotOnBoard objectAtIndex:gesture.view.tag];
            UIView *secondView = [self.cardViewsNotOnBoard objectAtIndex:gesture.view.tag - 1];
            UIView *thirdView = [self.cardViewsNotOnBoard objectAtIndex:gesture.view.tag - 2];
            
            // Move the cards from the deck to the board
            [self moveCardFromStackToBoard:firstView];
            [self moveCardFromStackToBoard:secondView];
            [self moveCardFromStackToBoard:thirdView];
            
            // Remove the cards from the deck array
            [self.cardViewsNotOnBoard removeObject:firstView];
            [self.cardViewsNotOnBoard removeObject:secondView];
            [self.cardViewsNotOnBoard removeObject:thirdView];
            
            // Number of empty spaces has decreased by 3
            self.numberOfEmptySpacesOnBoard -= 3;
        }
        
        // If there are no more cards on the deck, hide the bottom card
        if ([self.cardViewsNotOnBoard count] <= 0) {
            self.cardsUnmatched.hidden = YES;
        }
    }
}

/*  Moves the card from the deck to the game board */
- (void)moveCardFromStackToBoard:(UIView *)view {
   
    // Put card back into same location after subview is switched
    CGRect oldFrameLocation = CGRectMake(self.cardsUnmatched.frame.origin.x - 20,
                                    self.cardsUnmatched.frame.origin.y - 81,
                                    self.cardsUnmatched.bounds.size.width,
                                    self.cardsUnmatched.bounds.size.height);
    
    // New location of the card after it is moved
    CGRect newFrameLocation = CGRectMake([[self.locationOfEmptySpacesOnBoardX firstObject] floatValue],
                             [[self.locationOfEmptySpacesOnBoardY firstObject] floatValue],
                             self.cardWidth,
                             self.cardHeight);
    
    [self.locationOfEmptySpacesOnBoardX removeObjectAtIndex:0];
    [self.locationOfEmptySpacesOnBoardY removeObjectAtIndex:0];
    
    // Remove old tap gesture
    view.userInteractionEnabled = NO;

    // Add new tap gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)];
    tap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tap];
    view.userInteractionEnabled = YES;
    
    // Get the card attached to the view
    Card *newCard = [self.game cardAtIndex:(view.tag + (self.numberOfColumns * self.numberOfRows))];

    // Update tag number
    view.tag = [[self.emptyTags objectAtIndex:0] intValue];
    [self.emptyTags removeObjectAtIndex:0];
    
    // Replace card view
    [self.cardViews replaceObjectAtIndex:view.tag withObject:view];
    [self.game.cards replaceObjectAtIndex:view.tag withObject:newCard];
    
    // Change view from umatched card stack to game board
    [view removeFromSuperview];
    [self.gridView addSubview:view];
    
    // Adjust location of the card (so it is still in same place after switching views)
    view.frame = oldFrameLocation;
    
    // Animate moving the card
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         view.frame = newFrameLocation;
                     }
                     completion:^(BOOL finished){
                         [self turnCardOver:view];
                     }];
}

/*  Moves cards from the board to the matched deck */
- (void)moveMatchedCards:(UIView *)view {
    
    // Save the old location on the screen
    [self.locationOfEmptySpacesOnBoardX addObject:[NSNumber numberWithFloat:view.frame.origin.x]];
    [self.locationOfEmptySpacesOnBoardY addObject:[NSNumber numberWithFloat:view.frame.origin.y]];
    [self.emptyTags addObject:[NSNumber numberWithInteger:view.tag]];

    // Put card back into same location after subview is switched
    CGRect oldFrameLocation = CGRectMake(view.frame.origin.x - self.gridView.frame.size.width + self.cardsMatched.frame.origin.x - 30,
                                         view.frame.origin.y - self.gridView.frame.size.height - 8,
                                         self.cardWidth,
                                         self.cardHeight);
    
    // Move the cards to the cards matched deck after the subview is switched
    CGRect newFrameLocation = CGRectMake(self.cardsMatched.bounds.origin.x,
                                         self.cardsMatched.bounds.origin.y,
                                         self.cardsMatched.bounds.size.width,
                                         self.cardsMatched.bounds.size.height);
    
    // Switch the subviews
    [view removeFromSuperview];
    [self.cardsMatched addSubview:view];
    view.frame = oldFrameLocation;
    
    // Animate moving the card
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         view.frame = newFrameLocation;
                     }
                     completion:^(BOOL finished){
                         // Turn off blue background
                         [self flipCard:view];
                     }];

}

/*  If the card on the game board has been tapped */
- (void)cardTapped:(UITapGestureRecognizer *)gesture {
        
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        // Get the card and view that was tapped
        UIView *view = [self.cardViews objectAtIndex:gesture.view.tag];
                
        Card *card = [self.game cardAtIndex:gesture.view.tag];
        
        // If no other cards have been flipped on the game board, add the card to the cardsTapped array
        if ([self.cardsTapped count] == 0) {
            
            [self.cardsTapped addObject:view];
            
            // Flip the card that was tapped
            [self flipCard:view];
        }
        
        // If one other card has been flipped on the game board...
        else if ([self.cardsTapped count] == 1 && self.cardMatchingCount == 2) {
            
            // Get the previously tapped card
            UIView *firstCardTapped = [self.cardsTapped lastObject];
            
            // If the same card is being flipped, flip it back over
            if (view.tag == firstCardTapped.tag) {
                [self.cardsTapped removeLastObject];
                [self flipCard:view];
                
                // Check the score (twice because the cards are the same)
                [self.game chooseCardAtIndex:view.tag];
                [self.game chooseCardAtIndex:view.tag];
                
                // Update the score
                self.score.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
            }
            
            // Else flip the second card over
            else {
                
                // Add the card to the cardsTapped array
                [self.cardsTapped addObject:view];
                
                // Flip the second card that was tapped
                [self flipCard:view];
                
                /* If cards are unmatched flip both cards back
                If they are matched, disable the card */
                if ([self.cardsTapped count] == 2) {
                    
                    // Check to see if the cards match
                    for (UIView *tappedCard in self.cardsTapped) {
                        [self.game chooseCardAtIndex:tappedCard.tag];
                    }
                    
                    // Animate flipping the cards
                    [UIView animateWithDuration:2.5
                                    //Dummy animation
                                     animations:^{
                                         if (view.alpha == 2.0) {
                                             view.alpha = 1.0;
                                         }
                                         else {
                                             view.alpha = 2.0;
                                         }
                                     }
                                    // When animation is finished
                                     completion:^(BOOL finished) {
                                         
                                         // If the cards do not match, flip them back over
                                         if (!card.isMatched) {
                                             // Flip both cards back
                                             [self flipCard:view];
                                             [self flipCard:firstCardTapped];
                                         }
                                         
                                         // If the cards match, grey out cards
                                         else {
                                             [self disableCard:view];
                                             [self disableCard:firstCardTapped];
                                         }
                                         
                                         // Animation
                                         [UIView animateWithDuration:2.5
                                                        // Dummy animation
                                                          animations:^ {
                                                              if ([view.backgroundColor isEqual:[UIColor clearColor]]) {
                                                                  view.backgroundColor = [UIColor blackColor]; // KEEP!
                                                                  view.backgroundColor = [UIColor clearColor]; // KEEP! only way animation works
                                                              }
                                                              else {
                                                                  view.backgroundColor = [UIColor clearColor];
                                                              }
                                                          }
                                          
                                                        // When animation is finished
                                                          completion:^(BOOL finished) {
                                                              
                                                              // Update the score
                                                              self.score.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
                                                              
                                                              // Remove all cards from cardsTapped array
                                                              [self.cardsTapped removeAllObjects];
                                                              
                                                              // If the cards are matched, disable the buttons
                                                              if (card.isMatched) {
                                                                  if ([gesture isMemberOfClass:[UITapGestureRecognizer class]]) {
                                                                      view.userInteractionEnabled = NO;
                                                                      firstCardTapped.userInteractionEnabled = NO;
                                                                  }
                                                              }
                                                              
                                                              // If the game is over, grey out and disable all cards
                                                              if ([self cardsStillInPlay]) {
                                                                  [self gameOver];
                                                              }
                                                          }];
                                         }];
                }
            }
        }
        
        // If one other card has been flipped on the game board...
        else if ([self.cardsTapped count] == 1 && self.cardMatchingCount == 3) {
            
            // Get the previously tapped card
            UIView *firstCardTapped = [self.cardsTapped lastObject];

            // If the same card is being flipped, flip it back over
            if (view.tag == firstCardTapped.tag) {
                [self.cardsTapped removeLastObject];
                [self flipCard:view];
                
                // Check the score (twice because the cards are the same)
                [self.game chooseCardAtIndex:view.tag];
                [self.game chooseCardAtIndex:view.tag];
                
                // Update the score
                self.score.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
            }

            // Else flip the second card over
            else {

                // Add the card to the cardsTapped array
                [self.cardsTapped addObject:view];
                
                // Flip the second card that was tapped
                [self flipCard:view];
            }
        }
        
        else if ([self.cardsTapped count] == 2 && self.cardMatchingCount == 3) {
            
            UIView *firstCardTapped = [self.cardsTapped objectAtIndex:0];
            UIView *secondCardTapped = [self.cardsTapped objectAtIndex:1];
            
            // Flip the first card over if it is the same card
            if (view.tag == firstCardTapped.tag) {
                [self.cardsTapped removeObject:firstCardTapped];
                [self flipCard:firstCardTapped];
                
                // Check the score (twice because the cards are the same)
                [self.game chooseCardAtIndex:view.tag];
                [self.game chooseCardAtIndex:view.tag];
                
                // Update the score
                self.score.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
            }
            
            // Flip the second card over if it is the same card
            else if (view.tag == secondCardTapped.tag) {
                [self.cardsTapped removeObject:secondCardTapped];
                [self flipCard:secondCardTapped];
                
                // Check the score (twice because the cards are the same)
                [self.game chooseCardAtIndex:view.tag];
                [self.game chooseCardAtIndex:view.tag];
                
                // Update the score
                self.score.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
            }
            
            // Else flip the third card over
            else {
                
                // Add the card to the cardsTapped array
                [self.cardsTapped addObject:view];
                
                // Flip the third card that was tapped
                [self flipCard:view];

                /* If cards are unmatched flip both cards back
                 If they are matched, disable the card */
                if ([self.cardsTapped count] == 3) {
                    
                    
                    // Check to see if the cards match
                    for (UIView *tappedCard in self.cardsTapped) {
                        [self.game chooseCardAtIndex:tappedCard.tag];
                    }
                    
                    // Animate flipping the cards
                    [UIView animateWithDuration:2.5
                     //Dummy animation
                                     animations:^{
                                         if (view.alpha == 2.0) {
                                             view.alpha = 1.0;
                                         }
                                         else {
                                             view.alpha = 2.0;
                                         }
                                     }
                                    // When animation is finished
                                     completion:^(BOOL finished) {
                                         
                                         // If the cards do not match, flip them back over
                                         if (!card.isMatched) {
                                             // Flip all cards back
                                             [self flipCard:view];
                                             [self flipCard:firstCardTapped];
                                             [self flipCard:secondCardTapped];
                                         }
                                         
                                         // If the cards match, move the cards off the board
                                         else {
                                             
                                             
                                             // Move the cards to matched cards pile
                                             [self moveMatchedCards:view];
                                             [self moveMatchedCards:firstCardTapped];
                                             [self moveMatchedCards:secondCardTapped];
                                             
                                             // Increase number of empty spaces on board
                                             self.numberOfEmptySpacesOnBoard += 3;
                                             
                                         }
                                         
                                         // Animation
                                         [UIView animateWithDuration:2.5
                                          // Dummy animation
                                                          animations:^ {
                                                              if ([view.backgroundColor isEqual:[UIColor clearColor]]) {
                                                                  view.backgroundColor = [UIColor blackColor]; // KEEP!
                                                                  view.backgroundColor = [UIColor clearColor]; // KEEP! only way animation works
                                                              }
                                                              else {
                                                                  view.backgroundColor = [UIColor clearColor];
                                                              }
                                                          }
                                          
                                                        // When animation is finished
                                                          completion:^(BOOL finished) {
                                                              
                                                              // Update the score
                                                              self.score.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
                                                              
                                                              // Remove all cards from cardsTapped array
                                                              [self.cardsTapped removeAllObjects];
                                                              
                                                              // If the cards are matched, disable the buttons
                                                              if (card.isMatched) {
                                                                  if ([gesture isMemberOfClass:[UITapGestureRecognizer class]]) {
                                                                      view.userInteractionEnabled = NO;
                                                                      firstCardTapped.userInteractionEnabled = NO;
                                                                      secondCardTapped.userInteractionEnabled = NO;
                                                                  }
                                                              }
                                                              
                                                              // If the game is over, grey out and disable all cards
                                                              if ([self cardsStillInPlay]) {
                                                                  [self gameOver];
                                                              }
                                                          }];
                                     }];
                }
            }
        }
    }
}


#pragma mark - Playing Game

- (UIView *)getTypeOfView:(CGRect *)rect {
    // Abstract
    return nil;
}

- (void)flipCard:(UIView *)view {
    // Abstract
}

- (void)disableCard:(UIView *)view {
    // Abstract
}

/*  Gives each view the type of card to be drawn */
- (void)updateView:(UIView *)view forCard:(Card *)card {
     // Abstract
}

- (int)cardMatchingCount {
    // Abstract
    return 0;
}

- (void)makeFaceUp:(UIView *)view {
    // Abstract
}

- (void)makeFaceDown:(UIView *)view {
    // Abstract
}

- (void)turnCardOver:(UIView *)view {
    // Abstract
}

#pragma mark - Game Over

/*  Shuffles the card deck lays out a new set of cards on the board */
- (IBAction)resetButtonPressed:(id)sender {
    
    // Create a new deck of cards
    _game = [[CardMatchingGame alloc]
             initWithCardCount:self.sizeOfDeck
             usingDeck:[self createDeck]];
    
    // Remove the cards from the superview
    // If you do not do this, the old cards will appear beneath the new ones
    for (UIView *view in self.cardViews) {
        [view removeFromSuperview];
    }
    
    NSArray *some = [self.cardsMatched subviews];
    for (UIView *someone in some) {
        [someone removeFromSuperview];
    }
    
    // Remove all cards from array
    [self.cardViews removeAllObjects];
    [self.cardViewsNotOnBoard removeAllObjects];
    self.numberOfEmptySpacesOnBoard = 0;
    [self.locationOfEmptySpacesOnBoardX removeAllObjects];
    [self.locationOFEmptySpacesOnBoardY removeAllObjects];
    [self.emptyTags removeAllObjects];
    
    // Reset the score label
    self.score.text = [NSString stringWithFormat:@"Score: 0"];
    
    // Hide the game over notice
    self.gameOverView.hidden = YES;
    
    // Show the unmatched cards
    self.cardsUnmatched.hidden = NO;
    
    // Draw the cards on the board
    [self drawUI];
}

// Check to see if game has ended
- (BOOL)cardsStillInPlay {
    
    NSMutableArray *cardsNotMatched = [[NSMutableArray alloc] init]; // Of UIView
    
    for (UIView *view in self.cardViews) {
        Card *card = [self.game cardAtIndex:view.tag];
        
        // Add all unmatched cards to array
        if (!card.isMatched) {
            [cardsNotMatched addObject:card];
        }
    }
    
    // Add the cards that are not on the board
    if (self.cardViewsNotOnBoard > 0) {
        for (UIView *view in self.cardViewsNotOnBoard) {
            Card *card = [self.game cardAtIndex:view.tag + (self.numberOfRows * self.numberOfColumns)];
            [cardsNotMatched addObject:card];
        }
    }
    
    // If there are no cards unmatched cards left in the game, return true
    if ([cardsNotMatched count] == 0) {
        return true;
    }
    
    // If the game has ended, return true
    if ([self.game endOfGame:cardsNotMatched]) {
        return true;
    }
    
    // If the game has not ended, return false
    return false;
}

/*  When game is over, disable all cards and display a game over sign */
- (void)gameOver {
    
    for (UIView *disableView in self.cardViews) {
        if (disableView.userInteractionEnabled == YES) {
            disableView.userInteractionEnabled = NO;
            disableView.alpha = 0.5;
        }
    }
    
    int gameOverViewWidth = (self.gridView.bounds.size.width / 4) * 3;
    int gameOverViewHeight = self.gridView.bounds.size.height / 3;
    
    CGRect gameOverRect = CGRectMake((self.gridView.bounds.size.width / 2) - (gameOverViewWidth / 2),
                                     ((self.gridView.bounds.size.height / 2) - (gameOverViewHeight) / 2),
                                     gameOverViewWidth,
                                     gameOverViewHeight);
    self.gameOverView = [[GameOverView alloc] initWithFrame:gameOverRect];
    self.gameOverView.backgroundColor = [UIColor clearColor];
    [self.gridView addSubview:self.gameOverView];
    
    // Add a tap gesture recognizer to the view
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGameOver:)];
    tap.numberOfTapsRequired = 1;
    [self.gameOverView addGestureRecognizer:tap];
}

- (void)tapGameOver:(UITapGestureRecognizer *)gesture {
    [self resetButtonPressed:gesture];
}

@end
