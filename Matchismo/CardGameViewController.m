//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Justin Gazlay on 9/1/15.
//  Copyright (c) 2015 Justin Gazlay. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchTypeButton;
@property (weak, nonatomic) IBOutlet UILabel *gameActionDescriptionLabel;

@end

@implementation CardGameViewController

-(CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    
    return _game;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchNumberOfCardsToMatchButton:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        self.game.numberOfCardsToCompareMatch = 2;
    } else if (sender.selectedSegmentIndex == 1) {
        self.game.numberOfCardsToCompareMatch = 3;
    }
}

- (IBAction)touchResetCardsButton:(UIButton *)sender
{
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    [self updateUI];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game choosecardAtIndex:chosenButtonIndex];
    [self updateUI];
}

// Helper Methods

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
        self.matchTypeButton.enabled = !self.game.gameStarted;
        [self updateGameActionDescriptionLabel];
    }
}

- (void)updateGameActionDescriptionLabel
{
    NSString *cardsDescription = @"";
    for (Card *card in self.game.lastChosenCards) {
        
        if ([cardsDescription isEqualToString:@""]) {
            cardsDescription = card.contents;
        } else {
            //NSLog(@"card Added");
            NSString *newCardsDescription = [NSString stringWithFormat:@"%@, %@", cardsDescription, card.contents];
            cardsDescription = newCardsDescription;
        }
    }
    //NSLog(cardsDescription);
    
    if (self.game.lastChosenCards.count == self.game.numberOfCardsToCompareMatch) {
        if (self.game.lastMatchAttemptSuccessful) {
            self.gameActionDescriptionLabel.text = [NSString stringWithFormat:@"Matched %@ for %d points.", cardsDescription, self.game.lastAttemptedMatchScoreChange];
            //NSLog(@"successful match");
        } else {
            self.gameActionDescriptionLabel.text = [NSString stringWithFormat:@"%@ don't match! %d point penalty!", cardsDescription, -self.game.lastAttemptedMatchScoreChange];
            //NSLog(@"unsuccessful match");
        }
    } else {
        self.gameActionDescriptionLabel.text = cardsDescription;
        
    }
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
}


@end
