//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Justin Gazlay on 9/3/15.
//  Copyright (c) 2015 Justin Gazlay. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, readwrite) BOOL gameStarted;
@property (nonatomic, strong, readwrite) NSMutableArray *lastChosenCards; // of Card
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(NSMutableArray *)lastChosenCards
{
    if (!_lastChosenCards) _lastChosenCards = [[NSMutableArray alloc] init];
    return _lastChosenCards;
}


-(BOOL)gameStarted
{
    if (!_gameStarted) _gameStarted = NO;
    return _gameStarted;
}

@synthesize numberOfCardsToCompareMatch = _numberOfCardsToCompareMatch;

- (void)setNumberOfCardsToCompareMatch:(NSUInteger)numberOfCardsToCompareMatch
{
    if (!self.gameStarted) {
        _numberOfCardsToCompareMatch = numberOfCardsToCompareMatch;
    }
}

- (NSUInteger)numberOfCardsToCompareMatch
{
    if (!_numberOfCardsToCompareMatch) _numberOfCardsToCompareMatch = 2;
        return _numberOfCardsToCompareMatch;

        
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init]; // super's designated initializer
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
            
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

-(void)choosecardAtIndex:(NSUInteger)index
{
    if (!self.gameStarted) {
        self.gameStarted = YES;
    }
    
    if (self.lastChosenCards.count == self.numberOfCardsToCompareMatch) {
        self.lastChosenCards = nil;
        for (Card *card in self.cards) {
            if (!card.isMatched && card.isChosen) {
                [self.lastChosenCards addObject:card];
            }
        }
    }
    
    
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            [self.lastChosenCards removeObject:card];
        } else {
            // find out if enough cards are chosen to compare for a match
            card.chosen = YES;
            [self.lastChosenCards addObject:card];
            //NSLog(@"card was chosen");
            if (self.lastChosenCards.count == self.numberOfCardsToCompareMatch) {
                [self matchCards:[self.lastChosenCards copy]];
//                if (!self.lastMatchAttemptSuccessful){
//                    [self.lastChosenCards addObject:card];
//                }
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
    int lastChosenCardCount = [self.lastChosenCards count];
    //NSLog(@"%d card", lastChosenCardCount);
}

- (NSArray *)getCardsToMatch
{
    NSMutableArray *chosenUnmatchedCards = [[NSMutableArray alloc] init];
    for (Card *otherCard in self.cards){
        if (otherCard.isChosen && !otherCard.isMatched) {
            [chosenUnmatchedCards addObject:otherCard];
        }
    }
    return chosenUnmatchedCards;
}

- (void)matchCards:(NSArray *)cards
{
   // NSLog(@"matchCards: called");
    int matchScore = 0;
    for (Card *otherCard in cards) {
        int otherCardIndex = [cards indexOfObject:otherCard];
        NSMutableArray *remainingCards = [[NSMutableArray alloc] init];
        for (int newIndex = otherCardIndex + 1; newIndex < cards.count; newIndex++) {
            [remainingCards addObject:cards[newIndex]];
        }
        if (remainingCards.count >= 1) {
            matchScore += [otherCard match:remainingCards];
        }
    }
    if (matchScore) {
       // NSLog(@"match");
        self.score += matchScore * MATCH_BONUS;
        self.lastAttemptedMatchScoreChange = matchScore * MATCH_BONUS;
        self.lastMatchAttemptSuccessful = YES;
        for (Card *otherCard in cards) {
            otherCard.matched = YES;
            //[self.lastChosenCards removeObject:otherCard];
        }
    } else {
       // NSLog(@"mismatch");
        self.score -= MISMATCH_PENALTY;
        self.lastAttemptedMatchScoreChange = -MISMATCH_PENALTY;
        self.lastMatchAttemptSuccessful = NO;
        for (Card *otherCard in cards) {
            otherCard.chosen = NO;
            //[self.lastChosenCards removeObject:otherCard];
        }
    }

}


@end
