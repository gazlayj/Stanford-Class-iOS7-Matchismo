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
@property (strong, nonatomic) NSMutableArray *chosenCardsResultHistory; // of NSString
@property (weak, nonatomic) IBOutlet UISlider *resultsHistorySlider;

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



-(NSMutableArray *)chosenCardsResultHistory
{
    if (!_chosenCardsResultHistory) _chosenCardsResultHistory = [[NSMutableArray alloc] init];
    return _chosenCardsResultHistory;
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
    self.chosenCardsResultHistory = nil;
    [self updateUI];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game choosecardAtIndex:chosenButtonIndex];
    [self updateUI];
    [self.resultsHistorySlider setValue:self.resultsHistorySlider.maximumValue animated:YES];
    [self.gameActionDescriptionLabel setAlpha:1.0];
}

- (IBAction)resultsHistorySilderValuChanged:(UISlider *)sender
{
    int chosenCardsResultHistoryIndex = sender.value;
    if (self.chosenCardsResultHistory.count > chosenCardsResultHistoryIndex) {
        [self.gameActionDescriptionLabel setAlpha:0.5];
        self.gameActionDescriptionLabel.text = self.chosenCardsResultHistory[chosenCardsResultHistoryIndex];
    } else {
        [self.gameActionDescriptionLabel setAlpha:1.0];
    }
}
// Helper Methods

- (void)updateUI
{
    
    [self updateCards];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    self.matchTypeButton.enabled = !self.game.gameStarted;
    [self updateGameActionDescriptionLabel];
    [self updateResultsHistory];
    
}

- (void)updateCards
{
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
}

- (void)updateResultsHistory
{
    [self.chosenCardsResultHistory addObject:self.gameActionDescriptionLabel.text];
    self.resultsHistorySlider.maximumValue = self.chosenCardsResultHistory.count;
}

- (void)updateGameActionDescriptionLabel
{
    //NSLog(cardsDescription);
    NSString *cardsDescription = [self composeGameActionDescription];
    
    if (self.game.lastChosenCards.count == self.game.numberOfCardsToCompareMatch) {
        if (self.game.lastMatchAttemptSuccessful) {
            self.gameActionDescriptionLabel.text = [NSString stringWithFormat:@"Matched %@ for %ld points.", cardsDescription, (long)self.game.lastAttemptedMatchScoreChange];
            //NSLog(@"successful match");
        } else {
            self.gameActionDescriptionLabel.text = [NSString stringWithFormat:@"%@ don't match! %ld point penalty!", cardsDescription, (long)-self.game.lastAttemptedMatchScoreChange];
            //NSLog(@"unsuccessful match");
        }
    } else {
        self.gameActionDescriptionLabel.text = cardsDescription;
        
    }
}

- (NSString *)composeGameActionDescription
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
    
    return cardsDescription;
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
