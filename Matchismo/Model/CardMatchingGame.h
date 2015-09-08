//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Justin Gazlay on 9/3/15.
//  Copyright (c) 2015 Justin Gazlay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// Designated initalizer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)choosecardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSUInteger numberOfCardsToCompareMatch;
@property (nonatomic, readonly) BOOL gameStarted;
@property (nonatomic) NSInteger lastAttemptedMatchScoreChange;
@property (nonatomic) BOOL lastMatchAttemptSuccessful;
@property (nonatomic, strong, readonly) NSMutableArray *lastChosenCards; // of Card

@end
