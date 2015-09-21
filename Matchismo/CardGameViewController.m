//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Justin Gazlay on 9/1/15.
//  Copyright (c) 2015 Justin Gazlay. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "GameActionHistoryViewController.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameActionDescriptionLabel;


@end

@implementation CardGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUI];
    
}

-(CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    
    return _game;
}

- (Deck *)createDeck // abstract
{
    return nil;
}


- (IBAction)touchResetCardsButton:(UIButton *)sender
{
    
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    [self updateUI];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game choosecardAtIndex:chosenButtonIndex];
    [self updateUI];
    [self.gameActionDescriptionLabel setAlpha:1.0];
}


// Helper Methods

- (void)updateUI
{
    [self updateCards];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    [self updateGameActionDescriptionLabel];
}

- (void)updateCards
{
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
}


- (NSAttributedString *)descriptionForGameAction:(CardGameAction *)action
{
    NSAttributedString *cardsDescription = [self descriptionForCards:action.chosenCards];
    NSMutableAttributedString *gameActionDescription = [cardsDescription mutableCopy];
    
    switch (action.actionType) {
        case Mismatch:
            {
                NSAttributedString *mismatchDescription = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match! %ld point pentalty!", (long)action.pointsEarned]];
                [gameActionDescription appendAttributedString:mismatchDescription];
                break;
             }
        case Match:
            {
                NSAttributedString *matchDescription = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" matched for %ld points!", (long)action.pointsEarned]];
                [gameActionDescription appendAttributedString:matchDescription];
                break;
            }
        default:
            break;
    }
    
    return gameActionDescription;
}

- (NSAttributedString *)descriptionForCards:(NSArray *)cards
{
    NSMutableAttributedString *cardsDescription = [[NSMutableAttributedString alloc] init];
    
    for (Card *card in cards) {
        if ([cardsDescription length] > 0) {
            [cardsDescription appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
        }
        [cardsDescription appendAttributedString:[self cardDescription:card]];
    }
    
    return cardsDescription;
}

- (void)updateGameActionDescriptionLabel
{
    if ([self.game.gameActions count] > 0) {
        self.gameActionDescriptionLabel.attributedText = [self descriptionForGameAction:[self.game.gameActions lastObject]];
    } else {
        self.gameActionDescriptionLabel.attributedText = nil;
    }
}

-(NSAttributedString *)cardDescription:(Card *)card
{
    NSMutableAttributedString *description = [[self titleForCard:card] mutableCopy];
    if ([description length] == 0) {
        description = [[NSMutableAttributedString alloc] initWithString:card.contents];
    }
    
    return [description copy];
}


- (NSAttributedString *)titleForCard:(Card *)card
{
    
    return card.isChosen ? [[NSAttributedString alloc] initWithString:card.contents] : [[NSAttributedString alloc] initWithString:@""];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toHistorySegue"]) {
        if ([segue.destinationViewController isKindOfClass:[GameActionHistoryViewController class]]) {
            
            NSMutableArray *gameActionsDescriptions = [[NSMutableArray alloc] init];
            for (CardGameAction *action in self.game.gameActions) {
                NSAttributedString *actionDescription = [self descriptionForGameAction:action];
                [gameActionsDescriptions addObject:actionDescription];
            }
            GameActionHistoryViewController *vc = segue.destinationViewController;
            vc.gameActionHistoryStrings = [gameActionsDescriptions copy];
        }
    }
}


@end
